#!/bin/bash
#
# broken-builds-skill-run.sh
# Unattended wrapper for the broken-builds skill, intended for
# scheduled/launchd use.
#
# Usage: ./scripts/macos/broken-builds-skill-run.sh [--dry-run] [--force-rediagnose] [--help]
#
# There is no TTY in a launchd context, so this runs claude -p with
# --dangerously-skip-permissions (required for any non-interactive tool use).
# As partial mitigation, Edit/NotebookEdit are disallowed — the skill only
# needs to Read/Grep/Glob/Bash(read-only)/Write the report file, never edit
# an existing doc — and spend/runtime are both capped. For an
# approval-prompting run instead, invoke Claude Code interactively and ask
# it to follow skills/broken-builds/SKILL.md.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
MAX_BUDGET_USD="2"
TIMEOUT_SECONDS=300
TODAY="$(date +%Y-%m-%d)"
REPORT_DIR="${REPO_ROOT}/docs/admin/reports"
REPORT_FILE="${REPORT_DIR}/broken-builds-${TODAY}.md"
DRY_RUN=false
COLLECTOR_EXTRA_ARGS=()

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

cd "$REPO_ROOT"

# ── argument parsing ────────────────────────────────────────────────

usage() {
  cat <<'USAGE'
Usage: broken-builds-skill-run.sh [OPTIONS]

Collect broken-build data and run the broken-builds skill to produce
a diagnostic report.

Options:
  --dry-run            Print skill output to stdout instead of writing
                       a report file; also passes --dry-run to the
                       collector
  --force-rediagnose   Pass --force-rediagnose to the collector
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
    --force-rediagnose)
      COLLECTOR_EXTRA_ARGS+=(--force-rediagnose)
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
  # Regenerate if inventory is missing or older than the allowlist
  if [[ ! -f "$INVENTORY" ]] || [[ -f "$ALLOWLIST" && "$ALLOWLIST" -nt "$INVENTORY" ]]; then
    echo "Regenerating repo inventory..."
    "$INVENTORY_SCRIPT"
  fi
fi

# ── step (b): run GitHub Actions collector ──────────────────────────

COLLECTOR="${REPO_ROOT}/collectors/github-actions/collect.sh"
JSON_BUNDLE="${REPO_ROOT}/broken-builds-data-${TODAY}.json"
DATA_CONTENT=""

if [[ -x "$COLLECTOR" ]]; then
  echo "Running GitHub Actions collector..."
  if [[ "$DRY_RUN" == "true" ]]; then
    # In dry-run mode the collector prints the bundle to stdout instead of
    # writing a file, so capture it directly rather than looking on disk.
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
    # Try finding it in the repo root with today's date
    JSON_BUNDLE="$(find "$REPO_ROOT" -maxdepth 1 -name "broken-builds-data-${TODAY}.json" -print -quit 2>/dev/null || true)"
  fi

  if [[ -z "$JSON_BUNDLE" || ! -f "$JSON_BUNDLE" ]]; then
    echo "Error: no broken-builds JSON bundle found for ${TODAY}" >&2
    exit 1
  fi

  DATA_CONTENT="$(cat "$JSON_BUNDLE")"
fi

if [[ -z "$DATA_CONTENT" ]]; then
  echo "Error: collector produced no data" >&2
  exit 1
fi

# ── step (d): invoke the skill ─────────────────────────────────────

echo "Running broken-builds skill..."

PROMPT_CONTENT="$(cat "${REPO_ROOT}/prompts/common/safety-preamble.md" "${REPO_ROOT}/skills/broken-builds/SKILL.md")"
COMBINED_PROMPT="${PROMPT_CONTENT}

## Input Data

${DATA_CONTENT}"

SKILL_OUTPUT="$(printf '%s' "$COMBINED_PROMPT" \
  | "${timeout_cmd[@]+"${timeout_cmd[@]}"}" claude -p \
      --output-format text \
      --dangerously-skip-permissions \
      --disallowedTools "Edit,NotebookEdit" \
      --max-budget-usd "${MAX_BUDGET_USD}")"

# ── step (e–g): write or print report ──────────────────────────────

# Trim trailing whitespace from each line and ensure single trailing newline
CLEAN_OUTPUT="$(printf '%s' "$SKILL_OUTPUT" | sed 's/[[:space:]]*$//')"

if [[ "$DRY_RUN" == "true" ]]; then
  printf '%s\n' "$CLEAN_OUTPUT"
else
  mkdir -p "$REPORT_DIR"
  printf '%s\n' "$CLEAN_OUTPUT" > "$REPORT_FILE"
  echo "Report written to ${REPORT_FILE}"
fi
