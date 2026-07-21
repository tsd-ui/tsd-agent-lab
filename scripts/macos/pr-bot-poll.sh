#!/bin/bash
#
# pr-bot-poll.sh
# Poll GitHub for /agent review comments on PRs, validate authorization,
# and write durable queue files for a separate worker to process.
#
# Invoked via: run-automation pr-bot-poll
#
# Options:
#   --detect-only   Poll and authorize candidates, print them to stdout,
#                   but do not write queue files or add reactions.
#                   Still updates the poll watermark.
#   --help          Show this help message
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

# ── constants ──────────────────────────────────────────────────────
QUEUE_DIR="${HOME}/workspaces/runs/.pr-bot-queue"
STATE_FILE="${HOME}/workspaces/runs/.pr-bot-state.json"
ALLOWLIST="${REPO_ROOT}/policies/bot-commenter-allowlist.yaml"
INVENTORY="${REPO_ROOT}/policies/generated/repo-inventory.txt"
COMMAND_REGEX='^[[:space:]]*/agent[[:space:]]+review[[:space:]]*$'
GLOBAL_RATE_LIMIT=20
USER_RATE_LIMIT=5

DETECT_ONLY=false

# ── argument parsing ───────────────────────────────────────────────

usage() {
  cat <<'USAGE'
Usage: pr-bot-poll.sh [OPTIONS]

Poll GitHub for /agent review comments, validate authorization,
and write queue files for pr-bot-worker to process.

Options:
  --detect-only   Show candidates but don't write queue files or reactions
  --help          Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --detect-only) DETECT_ONLY=true; shift ;;
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

# ── prerequisite checks ───────────────────────────────────────────

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI not found on PATH" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq not found on PATH" >&2
  exit 1
fi

mkdir -p "$QUEUE_DIR"
mkdir -p "$(dirname "$STATE_FILE")"

# ── helper functions ───────────────────────────────────────────────

now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

hour_bucket() {
  date -u +"%Y-%m-%dT%H"
}

read_state() {
  if [[ -f "$STATE_FILE" ]]; then
    cat "$STATE_FILE"
  else
    echo '{}'
  fi
}

write_state() {
  printf '%s\n' "$1" > "$STATE_FILE"
}

# Check if commenter is in the static allowlist
is_allowed_commenter() {
  local username="$1"
  grep -q "^\s*- username: ${username}\s*$" "$ALLOWLIST" 2>/dev/null
}

# Check if author_association is permitted
is_allowed_association() {
  local association="$1"
  case "$association" in
    COLLABORATOR|MEMBER|OWNER) return 0 ;;
    *) return 1 ;;
  esac
}

# Check if a comment body contains /agent review outside code blocks,
# blockquotes, and inline code
has_agent_review_command() {
  local body="$1"
  local in_code_block=false
  local line

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Toggle code block state on triple-backtick fences
    if [[ "$line" =~ ^\`\`\` ]]; then
      if [[ "$in_code_block" == true ]]; then
        in_code_block=false
      else
        in_code_block=true
      fi
      continue
    fi

    # Skip lines inside code blocks
    if [[ "$in_code_block" == true ]]; then
      continue
    fi

    # Skip blockquote lines
    if [[ "$line" =~ ^[[:space:]]*\> ]]; then
      continue
    fi

    # Strip inline code (backtick-wrapped) before matching
    local stripped
    stripped="$(printf '%s' "$line" | sed 's/`[^`]*`//g')"

    if printf '%s\n' "$stripped" | grep -qE "$COMMAND_REGEX"; then
      return 0
    fi
  done <<< "$body"

  return 1
}

# Check and update rate limits; returns 0 if under limit, 1 if rate limited
check_rate_limit() {
  local username="$1"
  local state="$2"
  local bucket
  bucket="$(hour_bucket)"

  local global_count user_count
  global_count="$(printf '%s' "$state" | jq -r --arg b "$bucket" '.rate_limits._global[$b] // 0')"
  user_count="$(printf '%s' "$state" | jq -r --arg b "$bucket" --arg u "$username" '.rate_limits[$u][$b] // 0')"

  if [[ "$global_count" -ge "$GLOBAL_RATE_LIMIT" ]] || [[ "$user_count" -ge "$USER_RATE_LIMIT" ]]; then
    return 1
  fi
  return 0
}

# Increment rate limit counters in state JSON; prints updated state
increment_rate_limit() {
  local username="$1"
  local state="$2"
  local bucket
  bucket="$(hour_bucket)"

  printf '%s' "$state" | jq \
    --arg b "$bucket" \
    --arg u "$username" \
    '.rate_limits._global[$b] = ((.rate_limits._global[$b] // 0) + 1)
     | .rate_limits[$u][$b] = ((.rate_limits[$u][$b] // 0) + 1)'
}

# ── compute watermark ─────────────────────────────────────────────

STATE="$(read_state)"
LAST_POLL="$(printf '%s' "$STATE" | jq -r '.last_poll_at // empty' 2>/dev/null || true)"

if [[ -n "$LAST_POLL" ]]; then
  # 10 minutes before last_poll_at (overlapping watermark)
  if date -v-10M >/dev/null 2>&1; then
    # macOS date
    WATERMARK="$(date -u -j -v-10M -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_POLL" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u -v-10M +"%Y-%m-%dT%H:%M:%SZ")"
  else
    # GNU date
    WATERMARK="$(date -u -d "${LAST_POLL} - 10 minutes" +"%Y-%m-%dT%H:%M:%SZ")"
  fi
else
  # No state — default to 1 hour ago
  if date -v-1H >/dev/null 2>&1; then
    WATERMARK="$(date -u -v-1H +"%Y-%m-%dT%H:%M:%SZ")"
  else
    WATERMARK="$(date -u -d "1 hour ago" +"%Y-%m-%dT%H:%M:%SZ")"
  fi
fi

echo "Polling since watermark: ${WATERMARK}"

# ── poll each maintained repo ─────────────────────────────────────

ALL_OK=true

while IFS=$'\t' read -r repo tag rest; do
  # Only process maintained repos
  if [[ "$tag" != "maintained" ]]; then
    continue
  fi

  echo "Checking ${repo}..."

  # Fetch all comments since watermark; --paginate may emit multiple
  # JSON arrays, so merge them with jq -s.
  COMMENTS=""
  if ! COMMENTS="$(gh api "repos/${repo}/issues/comments" \
      -X GET \
      --paginate \
      -f since="$WATERMARK" \
      -f per_page=100 2>&1)"; then
    echo "Warning: failed to fetch comments for ${repo}: ${COMMENTS}" >&2
    ALL_OK=false
    continue
  fi

  # Merge paginated arrays and skip if empty
  COMMENTS="$(printf '%s' "$COMMENTS" | jq -s 'add // []')"
  if [[ "$(printf '%s' "$COMMENTS" | jq 'length')" == "0" ]]; then
    continue
  fi

  # Process each comment (process substitution avoids subshell)
  while IFS= read -r comment; do
    COMMENT_ID="$(printf '%s' "$comment" | jq -r '.id')"
    BODY="$(printf '%s' "$comment" | jq -r '.body // ""')"
    COMMENTER="$(printf '%s' "$comment" | jq -r '.user.login')"
    ASSOCIATION="$(printf '%s' "$comment" | jq -r '.author_association')"
    ISSUE_URL="$(printf '%s' "$comment" | jq -r '.issue_url')"

    # Check for /agent review command
    if ! has_agent_review_command "$BODY"; then
      continue
    fi

    # Extract PR number from issue_url
    PR_NUMBER="$(printf '%s' "$ISSUE_URL" | grep -oE '[0-9]+$')"
    if [[ -z "$PR_NUMBER" ]]; then
      echo "  Warning: could not extract PR number from ${ISSUE_URL}" >&2
      continue
    fi

    echo "  Found /agent review from ${COMMENTER} on PR #${PR_NUMBER} (comment ${COMMENT_ID})"

    # ── authorization ──────────────────────────────────────────
    if ! is_allowed_commenter "$COMMENTER"; then
      echo "  Skipped: ${COMMENTER} not in allowlist"
      continue
    fi

    if ! is_allowed_association "$ASSOCIATION"; then
      echo "  Skipped: author_association=${ASSOCIATION} not permitted"
      continue
    fi

    # ── deduplication ──────────────────────────────────────────
    QUEUE_FILE="${QUEUE_DIR}/${COMMENT_ID}.json"
    if [[ -f "$QUEUE_FILE" ]]; then
      echo "  Skipped: already queued"
      continue
    fi

    # ── detect-only mode ───────────────────────────────────────
    if [[ "$DETECT_ONLY" == true ]]; then
      echo "  [detect-only] Would queue: repo=${repo} pr=${PR_NUMBER} commenter=${COMMENTER}"
      continue
    fi

    # ── rate limiting ──────────────────────────────────────────
    STATE="$(read_state)"
    if ! check_rate_limit "$COMMENTER" "$STATE"; then
      echo "  Rate limited: ${COMMENTER}"
      gh api "repos/${repo}/issues/comments/${COMMENT_ID}/reactions" \
        -f content=hourglass_flowing_sand --silent 2>/dev/null || true
      continue
    fi

    # ── fetch head SHA ─────────────────────────────────────────
    HEAD_SHA=""
    HEAD_SHA="$(gh pr view "$PR_NUMBER" --repo "$repo" \
      --json headRefOid -q '.headRefOid' 2>/dev/null || true)"
    if [[ -z "$HEAD_SHA" ]]; then
      echo "  Warning: could not fetch head SHA for PR #${PR_NUMBER}" >&2
      continue
    fi

    # ── write queue file ───────────────────────────────────────
    QUEUED_AT="$(now_iso)"
    jq -n \
      --argjson cid "$COMMENT_ID" \
      --arg repo "$repo" \
      --argjson pr "$PR_NUMBER" \
      --arg commenter "$COMMENTER" \
      --arg sha "$HEAD_SHA" \
      --arg queued "$QUEUED_AT" \
      '{
        comment_id: $cid,
        repo: $repo,
        pr_number: $pr,
        commenter: $commenter,
        head_sha: $sha,
        queued_at: $queued,
        status: "queued"
      }' > "$QUEUE_FILE"

    echo "  Queued: ${QUEUE_FILE}"

    # ── add :eyes: reaction ────────────────────────────────────
    gh api "repos/${repo}/issues/comments/${COMMENT_ID}/reactions" \
      -f content=eyes --silent 2>/dev/null || true

    # ── update rate limit counters ─────────────────────────────
    STATE="$(read_state)"
    STATE="$(increment_rate_limit "$COMMENTER" "$STATE")"
    write_state "$STATE"

  done < <(printf '%s' "$COMMENTS" | jq -c '.[]')

done < "$INVENTORY"

# ── update watermark ──────────────────────────────────────────────

if [[ "$ALL_OK" == true ]]; then
  STATE="$(read_state)"
  STATE="$(printf '%s' "$STATE" | jq --arg ts "$(now_iso)" '.last_poll_at = $ts')"
  write_state "$STATE"
  echo "Watermark updated to $(now_iso)"
else
  echo "Warning: some repos failed; watermark not advanced" >&2
fi

echo "Done."
