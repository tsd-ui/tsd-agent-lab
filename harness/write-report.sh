#!/usr/bin/env bash
#
# write-report.sh — Generate a markdown report from a run directory
#
# Usage: ./harness/write-report.sh <run-dir>
#
# Reads whatever exists in the run directory and assembles a markdown
# report in summary.md. Copies the report to ~/workspaces/reports/
# if that directory exists.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  echo "Usage: $(basename "$0") <run-dir>"
  echo ""
  echo "Generate a markdown report from a completed run directory."
  exit 1
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
section() {
  echo ""
  echo "## $1"
  echo ""
}

include_file_if_exists() {
  local file="$1"
  local label="$2"
  if [[ -f "$file" && -s "$file" ]]; then
    echo '```'
    cat "$file"
    echo '```'
  else
    echo "_No ${label} recorded._"
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
  usage
fi

RUN_DIR="$1"

if [[ ! -d "$RUN_DIR" ]]; then
  die "Run directory not found: ${RUN_DIR}"
fi

if [[ ! -f "${RUN_DIR}/run-metadata.json" ]]; then
  die "Not a valid run directory (missing run-metadata.json): ${RUN_DIR}"
fi

require_command jq

run_id=$(jq -r '.run_id' "${RUN_DIR}/run-metadata.json")
task_id=$(jq -r '.task_id' "${RUN_DIR}/run-metadata.json")
title=$(jq -r '.title' "${RUN_DIR}/run-metadata.json")
mode=$(jq -r '.mode' "${RUN_DIR}/run-metadata.json")
repo_url=$(jq -r '.repo_url' "${RUN_DIR}/run-metadata.json")
created_at=$(jq -r '.created_at' "${RUN_DIR}/run-metadata.json")
status=$(jq -r '.status' "${RUN_DIR}/run-metadata.json")

REPORT="${RUN_DIR}/summary.md"

{
  echo "# Run Report: ${run_id}"
  echo ""
  echo "_Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')_"

  section "Run Info"
  echo "| Field | Value |"
  echo "|-------|-------|"
  echo "| Run ID | \`${run_id}\` |"
  echo "| Task ID | \`${task_id}\` |"
  echo "| Title | ${title} |"
  echo "| Mode | \`${mode}\` |"
  echo "| Status | \`${status}\` |"
  echo "| Created | ${created_at} |"

  section "Repository"
  echo "| Field | Value |"
  echo "|-------|-------|"
  echo "| URL | ${repo_url} |"
  worktree_path=$(jq -r '.worktree_path // empty' "${RUN_DIR}/run-metadata.json" 2>/dev/null || echo "")
  if [[ -n "$worktree_path" ]]; then
    echo "| Worktree | \`${worktree_path}\` |"
  fi
  base_ref=$(jq -r '.base_ref // empty' "${RUN_DIR}/run-metadata.json" 2>/dev/null || echo "")
  if [[ -n "$base_ref" ]]; then
    echo "| Base ref | \`${base_ref}\` |"
  fi

  section "Agent Output"
  include_file_if_exists "${RUN_DIR}/agent-output.md" "agent output"

  section "Changed Files"
  include_file_if_exists "${RUN_DIR}/changed-files.txt" "changed files"

  section "Verification Results"
  include_file_if_exists "${RUN_DIR}/verification.log" "verification results"

  section "Directory Contents"
  echo '```'
  ls -la "$RUN_DIR" 2>/dev/null || echo "(could not list directory)"
  echo '```'
} > "$REPORT"

log_success "Report written: ${REPORT}"

if [[ -d "$TSD_REPORTS_DIR" ]]; then
  cp "$REPORT" "${TSD_REPORTS_DIR}/${run_id}-report.md"
  log_success "Report copied to: ${TSD_REPORTS_DIR}/${run_id}-report.md"
fi
