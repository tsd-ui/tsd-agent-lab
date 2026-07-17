#!/bin/bash
#
# pr-risk-triage-skill-run.sh
# Unattended wrapper for the pr-risk-triage skill, intended for
# scheduled/launchd use.
#
# Usage: ./scripts/macos/pr-risk-triage-skill-run.sh [--dry-run] [--include-drafts] [--help]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
MAX_BUDGET_USD="2"
TIMEOUT_SECONDS=300
TODAY="$(date +%Y-%m-%d)"
REPORT_DIR="${REPO_ROOT}/reports/pr-triage"
REPORT_FILE="${REPORT_DIR}/current.md"
ARCHIVE_FILE="${REPORT_DIR}/archive/pr-triage-${TODAY}.md"

source "${SCRIPT_DIR}/lib-report-rotation.sh"
DRY_RUN=false
COLLECTOR_EXTRA_ARGS=()

# launchd jobs run with a minimal PATH
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

# ── argument parsing ────────────────────────────────────────────────

usage() {
  cat <<'USAGE'
Usage: pr-risk-triage-skill-run.sh [OPTIONS]

Collect open PR data and run the pr-risk-triage skill to produce
a prioritized risk report.

Options:
  --dry-run            Print skill output to stdout instead of writing
                       a report file; also passes --dry-run to the
                       collector
  --include-drafts     Include draft PRs in the triage
  --help               Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      COLLECTOR_EXTRA_ARGS+=(--dry-run)
      shift
      ;;
    --include-drafts)
      COLLECTOR_EXTRA_ARGS+=(--include-drafts)
      shift
      ;;
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

# ── prerequisite checks ────────────────────────────────────────────

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: claude CLI not found on PATH" >&2
  exit 1
fi

timeout_cmd=()
if command -v gtimeout >/dev/null 2>&1; then
  timeout_cmd=(gtimeout "${TIMEOUT_SECONDS}")
elif command -v timeout >/dev/null 2>&1; then
  timeout_cmd=(timeout "${TIMEOUT_SECONDS}")
else
  echo "Warning: no timeout/gtimeout available; running without a runtime cap" >&2
fi

# ── step (a): ensure repo inventory is fresh ────────────────────────

INVENTORY_SCRIPT="${REPO_ROOT}/scripts/macos/generate-repo-inventory.sh"
ALLOWLIST="${REPO_ROOT}/policies/repo-allowlist.yaml"
INVENTORY="${REPO_ROOT}/policies/generated/repo-inventory.txt"

if [[ -x "$INVENTORY_SCRIPT" ]]; then
  if [[ ! -f "$INVENTORY" ]] || [[ -f "$ALLOWLIST" && "$ALLOWLIST" -nt "$INVENTORY" ]]; then
    echo "Regenerating repo inventory..."
    "$INVENTORY_SCRIPT"
  fi
fi

# ── step (b): run PR inventory collector ──────────────────────────

COLLECTOR="${REPO_ROOT}/collectors/pr-inventory/collect.sh"
JSON_BUNDLE="${REPO_ROOT}/pr-inventory-data-${TODAY}.json"
DATA_CONTENT=""

if [[ -x "$COLLECTOR" ]]; then
  echo "Running PR inventory collector..."
  if [[ "$DRY_RUN" == "true" ]]; then
    DATA_CONTENT="$("$COLLECTOR" "${COLLECTOR_EXTRA_ARGS[@]+"${COLLECTOR_EXTRA_ARGS[@]}"}")"
  else
    "$COLLECTOR" "${COLLECTOR_EXTRA_ARGS[@]+"${COLLECTOR_EXTRA_ARGS[@]}"}"
  fi
else
  echo "Warning: collector not found at ${COLLECTOR}" >&2
fi

# ── step (c): locate JSON bundle (full-run mode only) ───────────────

if [[ "$DRY_RUN" != "true" ]]; then
  if [[ ! -f "$JSON_BUNDLE" ]]; then
    JSON_BUNDLE="$(find "$REPO_ROOT" -maxdepth 1 -name "pr-inventory-data-${TODAY}.json" -print -quit 2>/dev/null || true)"
  fi

  if [[ -z "$JSON_BUNDLE" || ! -f "$JSON_BUNDLE" ]]; then
    echo "Error: no pr-inventory JSON bundle found for ${TODAY}" >&2
    exit 1
  fi

  DATA_CONTENT="$(cat "$JSON_BUNDLE")"
fi

if [[ -z "$DATA_CONTENT" ]]; then
  echo "Error: collector produced no data" >&2
  exit 1
fi

# ── step (d): invoke the skill ─────────────────────────────────────

echo "Running pr-risk-triage skill..."

PROMPT_CONTENT="$(cat "${REPO_ROOT}/prompts/common/safety-preamble.md" "${REPO_ROOT}/skills/pr-risk-triage/SKILL.md")"
COMBINED_PROMPT="${PROMPT_CONTENT}

## Input Data

${DATA_CONTENT}"

SKILL_OUTPUT="$(printf '%s' "$COMBINED_PROMPT" \
  | "${timeout_cmd[@]+"${timeout_cmd[@]}"}" claude -p \
      --output-format text \
      --dangerously-skip-permissions \
      --disallowedTools "Edit,NotebookEdit" \
      --max-budget-usd "${MAX_BUDGET_USD}")"

# ── step (e): write or print report ──────────────────────────────

CLEAN_OUTPUT="$(printf '%s' "$SKILL_OUTPUT" | sed 's/[[:space:]]*$//')"

if [[ "$DRY_RUN" == "true" ]]; then
  printf '%s\n' "$CLEAN_OUTPUT"
else
  rotate_report "$REPORT_DIR" "pr-triage" "$TODAY" "md"
  printf '%s\n' "$CLEAN_OUTPUT" > "$REPORT_FILE"
  cp "$REPORT_FILE" "$ARCHIVE_FILE"
  echo "Report written to ${REPORT_FILE}"
fi
