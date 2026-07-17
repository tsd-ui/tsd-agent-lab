#!/usr/bin/env bash
#
# stale-docs-check-skill-run.sh
# Unattended wrapper for the full stale-docs-check skill (mechanical +
# semantic review), intended for scheduled/launchd use.
#
# Usage: ./scripts/macos/stale-docs-check-skill-run.sh
#
# There is no TTY in a launchd context, so this runs claude -p with
# --dangerously-skip-permissions (required for any non-interactive tool use).
# As partial mitigation, Edit/NotebookEdit are disallowed — the skill only
# needs to Read/Grep/Glob/Bash(read-only)/Write the report file, never edit
# an existing doc — and spend/runtime are both capped. For an
# approval-prompting run instead, invoke Claude Code interactively and ask
# it to follow skills/stale-docs-check/SKILL.md.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
MAX_BUDGET_USD="2"
TIMEOUT_SECONDS=1800

# launchd jobs run with a minimal PATH that doesn't include user-installed
# tool locations; add them explicitly rather than relying on the caller's
# shell environment.
export PATH="${HOME}/.local/bin:${HOME}/.nvm/versions/node/v24.16.0/bin:/opt/homebrew/bin:/usr/local/bin:${PATH}"

export CLAUDE_CODE_USE_VERTEX="1"
export ANTHROPIC_VERTEX_PROJECT_ID="it-gcp-tsd-ui"
export GOOGLE_APPLICATION_CREDENTIALS="/Users/agent-lab/.config/agent-lab-vertex-key.json"
export CLOUD_ML_REGION="global"

cd "$REPO_ROOT"

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: claude CLI not found on PATH" >&2
  exit 1
fi

timeout_cmd=()
if command -v timeout >/dev/null 2>&1; then
  timeout_cmd=(timeout "${TIMEOUT_SECONDS}")
elif command -v gtimeout >/dev/null 2>&1; then
  timeout_cmd=(gtimeout "${TIMEOUT_SECONDS}")
else
  echo "Warning: no timeout/gtimeout available; running without a runtime cap" >&2
fi

cat "${REPO_ROOT}/prompts/common/safety-preamble.md" "${REPO_ROOT}/skills/stale-docs-check/SKILL.md" \
  | "${timeout_cmd[@]+"${timeout_cmd[@]}"}" claude -p \
      --output-format text \
      --dangerously-skip-permissions \
      --disallowedTools "Edit,NotebookEdit" \
      --max-budget-usd "${MAX_BUDGET_USD}"
