#!/bin/bash
#
# pr-bot-worker.sh
# Process queued PR review requests: run lab-action review-pr, format
# the output, and post it as a GitHub comment.
#
# Invoked via: run-automation pr-bot-worker
#
# Processes ONE queued request per invocation (the worker runs on a
# 5-minute interval schedule).
#
# Options:
#   --format-fixture FILE   Test output formatting against a sample
#                           agent-output.md file; prints the formatted
#                           comment to stdout and exits without touching
#                           the queue or GitHub.
#   --help                  Show this help message
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# launchd jobs run with a minimal PATH that doesn't include user-installed
# tool locations; add them explicitly rather than relying on the caller's
# shell environment.
NVM_NODE=""
if [[ -d "${HOME}/.nvm/versions/node" ]]; then
  NVM_NODE="$(find "${HOME}/.nvm/versions/node/" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null | sort -V | tail -1)"
fi
if [[ -n "$NVM_NODE" ]]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:${HOME}/.local/bin:${NVM_NODE}/bin:${PATH}"
else
  export PATH="/opt/homebrew/bin:/usr/local/bin:${HOME}/.local/bin:${PATH}"
fi

export CLAUDE_CODE_USE_VERTEX="1"
export ANTHROPIC_VERTEX_PROJECT_ID="it-gcp-tsd-ui"
export GOOGLE_APPLICATION_CREDENTIALS="/Users/agent-lab/.config/agent-lab-vertex-key.json"
export CLOUD_ML_REGION="global"

cd "$REPO_ROOT"

# ── constants ─────────────────────────────────────────────────────
QUEUE_DIR="${HOME}/workspaces/runs/.pr-bot-queue"
STATE_FILE="${HOME}/workspaces/runs/.pr-review-state.json"
MAX_COMMENT_BYTES=50000

# ── argument parsing ──────────────────────────────────────────────

FORMAT_FIXTURE=""

usage() {
  cat <<'USAGE'
Usage: pr-bot-worker.sh [OPTIONS]

Process the oldest queued PR review request, run the review via
lab-action review-pr, format the output, and post it as a GitHub
comment.

Options:
  --format-fixture FILE   Test output formatting against a sample
                          agent-output.md file; prints the formatted
                          comment to stdout and exits.
  --help                  Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --format-fixture)
      FORMAT_FIXTURE="$2"
      shift 2
      ;;
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

# ── prerequisite checks ──────────────────────────────────────────

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI not found on PATH" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq not found on PATH" >&2
  exit 1
fi

# ── helper functions ──────────────────────────────────────────────

now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# Format agent output for a GitHub comment: neutralize @mentions,
# scrub local paths, and truncate to MAX_COMMENT_BYTES.
format_agent_output() {
  local raw="$1"
  local formatted

  # Neutralize @mentions: wrap the @ in backticks and insert a
  # zero-width space (U+200B) before the username so GitHub does
  # not send notifications.
  local zwsp
  zwsp="$(printf '\xe2\x80\x8b')"
  formatted="$(printf '%s' "$raw" | sed "s/@\([a-zA-Z0-9_-]\)/\`@\`${zwsp}\1/g")"

  # Scrub local paths — replace /Users/agent-lab/... with [run-dir]
  formatted="$(printf '%s' "$formatted" | sed 's|/Users/agent-lab/[^ ]*|[run-dir]|g')"

  # Truncate if over MAX_COMMENT_BYTES
  local byte_count
  byte_count="$(printf '%s' "$formatted" | wc -c | tr -d ' ')"
  if [[ "$byte_count" -gt "$MAX_COMMENT_BYTES" ]]; then
    formatted="$(printf '%s' "$formatted" | head -c "$MAX_COMMENT_BYTES")"
    formatted="${formatted}

_(Output truncated at 50KB)_"
  fi

  printf '%s' "$formatted"
}

# Build the full comment body.
build_comment() {
  local agent_output="$1"
  local comment_id="$2"
  local commenter="$3"
  local short_sha="$4"
  local runtime_seconds="$5"

  local formatted
  formatted="$(format_agent_output "$agent_output")"

  cat <<EOF
## :robot: TSD Agent Lab — PR Review

<!-- tsd-agent-lab:trigger-comment-id=${comment_id} -->

<details>
<summary><strong>Review Findings</strong> (click to expand)</summary>

${formatted}

</details>

---
<sub>Triggered by @${commenter} · Reviewed at commit ${short_sha} ·
Runtime: ${runtime_seconds}s · To re-review: comment <code>/agent review</code></sub>
EOF
}

# ── --format-fixture mode ─────────────────────────────────────────

if [[ -n "$FORMAT_FIXTURE" ]]; then
  if [[ ! -f "$FORMAT_FIXTURE" ]]; then
    echo "Error: fixture file not found: ${FORMAT_FIXTURE}" >&2
    exit 1
  fi

  fixture_content="$(cat "$FORMAT_FIXTURE")"
  build_comment "$fixture_content" "0000000" "test-user" "abc1234" "42"
  exit 0
fi

# ── step 1: claim oldest queued request ───────────────────────────

mkdir -p "$QUEUE_DIR"

oldest_file=""
oldest_queued_at=""

for f in "${QUEUE_DIR}"/*.json; do
  [[ -f "$f" ]] || continue

  file_status="$(jq -r '.status // ""' "$f" 2>/dev/null || true)"
  if [[ "$file_status" != "queued" ]]; then
    continue
  fi

  file_queued_at="$(jq -r '.queued_at // ""' "$f" 2>/dev/null || true)"
  if [[ -z "$oldest_queued_at" ]] || [[ "$file_queued_at" < "$oldest_queued_at" ]]; then
    oldest_queued_at="$file_queued_at"
    oldest_file="$f"
  fi
done

if [[ -z "$oldest_file" ]]; then
  echo "No queued requests found."
  exit 0
fi

echo "Claiming request: ${oldest_file}"

# Read request fields
comment_id="$(jq -r '.comment_id' "$oldest_file")"
repo="$(jq -r '.repo' "$oldest_file")"
pr_number="$(jq -r '.pr_number' "$oldest_file")"
commenter="$(jq -r '.commenter' "$oldest_file")"
head_sha="$(jq -r '.head_sha' "$oldest_file")"

started_at="$(now_iso)"

# Claim: update status to running
jq --arg ts "$started_at" \
  '.status = "running" | .started_at = $ts' \
  "$oldest_file" > "${oldest_file}.tmp" && mv "${oldest_file}.tmp" "$oldest_file"

# ── step 2: verify head SHA is still current ──────────────────────

echo "Verifying head SHA for ${repo}#${pr_number}..."
current_sha="$(gh pr view "$pr_number" --repo "$repo" \
  --json headRefOid -q '.headRefOid' 2>/dev/null || true)"

if [[ "$current_sha" != "$head_sha" ]]; then
  echo "SHA mismatch: queued=${head_sha} current=${current_sha}. Marking stale."
  jq --arg ts "$(now_iso)" \
    '.status = "stale" | .finished_at = $ts' \
    "$oldest_file" > "${oldest_file}.tmp" && mv "${oldest_file}.tmp" "$oldest_file"
  exit 0
fi

# ── step 3: run review ────────────────────────────────────────────

result_file="$(mktemp /tmp/pr-bot-result.XXXXXX.json)"
trap 'rm -f "$result_file"' EXIT

echo "Running review: ${repo}#${pr_number} at ${head_sha}..."
review_exit=0
"${REPO_ROOT}/bin/lab-action" review-pr "${repo}#${pr_number}" \
  --expected-head-sha "$head_sha" \
  --result-file "$result_file" || review_exit=$?

echo "lab-action exited with code ${review_exit}"

# Read result file
result_status="$(jq -r '.status // "failed"' "$result_file" 2>/dev/null || echo "failed")"
output_file="$(jq -r '.output_file // ""' "$result_file" 2>/dev/null || echo "")"
run_dir="$(jq -r '.run_dir // ""' "$result_file" 2>/dev/null || echo "")"
run_id="$(basename "$run_dir" 2>/dev/null || echo "unknown")"

short_sha="${head_sha:0:7}"
finished_at="$(now_iso)"

# Calculate runtime in seconds
if date -j >/dev/null 2>&1; then
  # macOS date
  start_epoch="$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$started_at" +%s 2>/dev/null || date +%s)"
  end_epoch="$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$finished_at" +%s 2>/dev/null || date +%s)"
else
  # GNU date
  start_epoch="$(date -d "$started_at" +%s 2>/dev/null || date +%s)"
  end_epoch="$(date -d "$finished_at" +%s 2>/dev/null || date +%s)"
fi
runtime_seconds=$(( end_epoch - start_epoch ))

# ── step 4: format comment ───────────────────────────────────────

final_status="failed"

if [[ "$result_status" == "completed" ]] && [[ -n "$output_file" ]] && [[ -f "$output_file" ]]; then
  agent_output="$(cat "$output_file")"
  comment_body="$(build_comment "$agent_output" "$comment_id" "$commenter" "$short_sha" "$runtime_seconds")"
  final_status="completed"
else
  echo "Review did not produce output (status=${result_status}). Skipping comment."
fi

# ── steps 5–6: idempotency check and post comment ────────────────

if [[ "$final_status" == "completed" ]]; then
  echo "Checking for existing comment with idempotency marker..."
  already_posted=false
  if gh api "repos/${repo}/issues/${pr_number}/comments" --paginate -q '.[].body' 2>/dev/null \
      | grep -q "tsd-agent-lab:trigger-comment-id=${comment_id}"; then
    already_posted=true
  fi

  if [[ "$already_posted" == true ]]; then
    echo "Duplicate detected — comment already posted for comment_id=${comment_id}. Skipping."
  else
    tmpfile="$(mktemp /tmp/pr-bot-comment.XXXXXX.md)"
    printf '%s\n' "$comment_body" > "$tmpfile"
    echo "Posting comment to ${repo}#${pr_number}..."
    if gh pr comment "$pr_number" --repo "$repo" --body-file "$tmpfile"; then
      echo "Comment posted successfully."
    else
      echo "Error: failed to post comment" >&2
      final_status="failed"
    fi
    rm -f "$tmpfile"
  fi
fi

# ── step 7: update queue file ────────────────────────────────────

jq --arg status "$final_status" \
   --arg ts "$finished_at" \
   --arg rid "$run_id" \
  '.status = $status | .finished_at = $ts | .run_id = $rid' \
  "$oldest_file" > "${oldest_file}.tmp" && mv "${oldest_file}.tmp" "$oldest_file"

echo "Queue file updated: status=${final_status}"

# ── step 8: update .pr-review-state.json ─────────────────────────

state_key="${repo}#${pr_number}"

existing_state='{}'
if [[ -f "$STATE_FILE" ]]; then
  existing_state="$(cat "$STATE_FILE")"
fi

updated_state="$(printf '%s' "$existing_state" | jq \
  --arg key "$state_key" \
  --arg reviewed_at "$finished_at" \
  --arg run_id "$run_id" \
  --arg status "$final_status" \
  '.reviewed[$key] = {
    reviewed_at: $reviewed_at,
    run_id: $run_id,
    status: $status,
    triggered_by: "pr-bot"
  }')"

printf '%s\n' "$updated_state" > "$STATE_FILE"

echo "State file updated: ${state_key} -> ${final_status}"
echo "Done."
