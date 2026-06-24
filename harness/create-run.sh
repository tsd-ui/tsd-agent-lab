#!/usr/bin/env bash
#
# create-run.sh — Create a timestamped run directory from a task file
#
# Usage: ./harness/create-run.sh <task-file> [--dry-run]
#
# Validates the task file, generates a unique run ID, and creates
# a run directory with placeholder files. Prints the run directory
# path as the final line of output (for capture).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  echo "Usage: $(basename "$0") <task-file> [--dry-run]"
  echo ""
  echo "Create a new run directory from a task specification file."
  echo ""
  echo "Options:"
  echo "  --dry-run    Print what would be created without creating anything"
  exit 1
}

# ---------------------------------------------------------------------------
# Validate mode
# ---------------------------------------------------------------------------
VALID_MODES="read-only patch-only branch-only commit-allowed review-only"

validate_mode() {
  local mode="$1"
  for valid in $VALID_MODES; do
    if [[ "$mode" == "$valid" ]]; then
      return 0
    fi
  done
  die "Invalid mode '${mode}'. Must be one of: ${VALID_MODES}"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
  usage
fi

TASK_FILE="$1"
shift

if [[ ! -f "$TASK_FILE" ]]; then
  log_error "Task file not found: ${TASK_FILE}"
  exit 2
fi

task_id=$(read_yaml_field_required "$TASK_FILE" "task_id")
title=$(read_yaml_field_required "$TASK_FILE" "title")
mode=$(read_yaml_field_required "$TASK_FILE" "mode")
repo_url=$(read_yaml_field_required "$TASK_FILE" "repo_url")

validate_mode "$mode"

run_id=$(generate_run_id "$task_id")
run_dir="${TSD_RUNS_DIR}/${run_id}"

if is_dry_run "$@"; then
  print_banner "Dry Run: create-run" >&2
  log_info "Task file:  ${TASK_FILE}" >&2
  log_info "Task ID:    ${task_id}" >&2
  log_info "Title:      ${title}" >&2
  log_info "Mode:       ${mode}" >&2
  log_info "Repo URL:   ${repo_url}" >&2
  log_info "Run ID:     ${run_id}" >&2
  log_info "Run dir:    ${run_dir}" >&2
  echo "" >&2
  log_info "Would create:" >&2
  log_info "  ${run_dir}/task.yaml" >&2
  log_info "  ${run_dir}/agent-output.md" >&2
  log_info "  ${run_dir}/verification.log" >&2
  log_info "  ${run_dir}/summary.md" >&2
  log_info "  ${run_dir}/changed-files.txt" >&2
  log_info "  ${run_dir}/run-metadata.json" >&2
  exit 0
fi

ensure_directory "$run_dir" >&2

cp "$TASK_FILE" "${run_dir}/task.yaml"

touch "${run_dir}/agent-output.md"
touch "${run_dir}/verification.log"
touch "${run_dir}/summary.md"
touch "${run_dir}/changed-files.txt"

cat > "${run_dir}/run-metadata.json" <<EOF
{
  "run_id": "${run_id}",
  "task_id": "${task_id}",
  "title": "${title}",
  "mode": "${mode}",
  "repo_url": "${repo_url}",
  "created_at": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "status": "created"
}
EOF

log_success "Run directory created: ${run_dir}" >&2
echo "$run_dir"
