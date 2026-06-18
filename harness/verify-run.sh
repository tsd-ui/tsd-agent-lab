#!/usr/bin/env bash
#
# verify-run.sh — Run verification commands from a task specification
#
# Usage: ./harness/verify-run.sh <task-file> --run-dir <run-dir> [--dry-run]
#
# Reads verification_commands from the task YAML, runs each command
# inside the worktree, and captures results to verification.log.
# Stops on first failure.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/agent.sh"
source "${SCRIPT_DIR}/lib/verify.sh"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  echo "Usage: $(basename "$0") <task-file> --run-dir <run-dir> [--dry-run]"
  echo ""
  echo "Run verification commands defined in the task specification."
  echo ""
  echo "Options:"
  echo "  --run-dir <dir>  Run directory (created by create-run.sh)"
  echo "  --dry-run        Print what would happen without executing"
  exit 1
}

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
TASK_FILE=""
RUN_DIR=""
DRY_RUN_FLAG=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --run-dir)
      RUN_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN_FLAG=true
      shift
      ;;
    -*)
      die "Unknown option: $1"
      ;;
    *)
      if [[ -z "$TASK_FILE" ]]; then
        TASK_FILE="$1"
      else
        die "Unexpected argument: $1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$TASK_FILE" || -z "$RUN_DIR" ]]; then
  usage
fi

if [[ ! -f "$TASK_FILE" ]]; then
  die "Task file not found: ${TASK_FILE}"
fi

if [[ ! -d "$RUN_DIR" ]]; then
  die "Run directory not found: ${RUN_DIR}"
fi

# ---------------------------------------------------------------------------
# Resolve worktree and commands
# ---------------------------------------------------------------------------
worktree_path=$(resolve_worktree "$RUN_DIR")
commands=$(read_yaml_array "$TASK_FILE" "verification_commands")
log_file="${RUN_DIR}/verification.log"

# ---------------------------------------------------------------------------
# Dry-run
# ---------------------------------------------------------------------------
if [[ "$DRY_RUN_FLAG" == "true" ]]; then
  print_banner "Dry Run: verify-run"
  log_info "Task file:     ${TASK_FILE}"
  log_info "Worktree:      ${worktree_path}"
  log_info "Log file:      ${log_file}"
  echo ""
  if [[ -z "$commands" ]]; then
    log_info "No verification commands defined in task"
  else
    log_info "Would run these commands (inside worktree, fail-fast):"
    local_idx=0
    while IFS= read -r cmd; do
      [[ -z "$cmd" ]] && continue
      local_idx=$((local_idx + 1))
      log_info "  [${local_idx}] ${cmd}"
    done <<< "$commands"
  fi
  exit 0
fi

# ---------------------------------------------------------------------------
# Execute
# ---------------------------------------------------------------------------
require_command jq

print_banner "Verify Run"

log_step "Step 1: Resolve worktree"
log_success "Worktree: ${worktree_path}"
echo ""

log_step "Step 2: Read verification commands"
if [[ -z "$commands" ]]; then
  log_info "No verification commands defined — skipping"
  verification_result="skipped"
else
  cmd_count=$(echo "$commands" | grep -c '^' || echo 0)
  log_info "${cmd_count} command(s) to run"
  echo ""

  log_step "Step 3: Run verification commands"
  exit_code=0
  run_verification_suite "$TASK_FILE" "$worktree_path" "$log_file" || exit_code=$?

  if [[ "$exit_code" -eq 0 ]]; then
    verification_result="passed"
  else
    verification_result="failed"
  fi
fi

echo ""
log_step "Step 4: Update run metadata"
tmp=$(mktemp)
jq --arg result "$verification_result" \
   --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
   '. + {verification_result: $result, verified_at: $ts, status: (if $result == "passed" then "verified" elif $result == "skipped" then .status else "verification-failed" end)}' \
   "${RUN_DIR}/run-metadata.json" > "$tmp"
mv "$tmp" "${RUN_DIR}/run-metadata.json"
log_success "Updated run-metadata.json (verification: ${verification_result})"

echo ""
if [[ "$verification_result" == "passed" ]]; then
  log_success "All verification commands passed"
elif [[ "$verification_result" == "skipped" ]]; then
  log_info "No verification commands to run"
else
  log_error "Verification failed — see ${log_file}"
fi

echo ""
echo "Next steps:"
echo "  1. Review verification log: ${log_file}"
echo "  2. Generate report: ./harness/write-report.sh ${RUN_DIR}"
