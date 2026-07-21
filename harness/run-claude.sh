#!/usr/bin/env bash
#
# run-claude.sh — Run Claude Code against a prepared task
#
# Usage: ./harness/run-claude.sh <task-file> --run-dir <run-dir> [--dry-run]
#
# Composes a prompt from safety preamble + task prompt, then invokes
# claude -p inside the task's worktree. Updates run-metadata.json with
# the result.
#
# Prerequisites:
#   - claude CLI installed and on PATH
#   - Run directory created by create-run.sh
#   - Repository prepared by prepare-repo.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/agent.sh"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  echo "Usage: $(basename "$0") <task-file> --run-dir <run-dir> [--dry-run]"
  echo ""
  echo "Run Claude Code against a prepared task."
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
# Read task fields
# ---------------------------------------------------------------------------
agent=$(read_yaml_field "$TASK_FILE" "agent")
agent="${agent:-claude-code}"
mode=$(read_yaml_field_required "$TASK_FILE" "mode")
max_runtime=$(read_yaml_field "$TASK_FILE" "max_runtime_minutes")
max_turns=$(read_yaml_field "$TASK_FILE" "max_turns")

# ---------------------------------------------------------------------------
# Validate agent
# ---------------------------------------------------------------------------
if [[ "$agent" != "claude-code" ]]; then
  die "run-claude.sh only supports agent 'claude-code', got '${agent}'"
fi

# ---------------------------------------------------------------------------
# Resolve prompt and worktree
# ---------------------------------------------------------------------------
prompt_file=$(resolve_prompt_file "$TASK_FILE")
worktree_path=$(resolve_worktree "$RUN_DIR")

# ---------------------------------------------------------------------------
# Dry-run
# ---------------------------------------------------------------------------
if [[ "$DRY_RUN_FLAG" == "true" ]]; then
  print_banner "Dry Run: run-claude"
  log_info "Task file:     ${TASK_FILE}"
  log_info "Agent:         ${agent}"
  log_info "Mode:          ${mode}"
  log_info "Prompt file:   ${prompt_file}"
  log_info "Worktree:      ${worktree_path}"
  log_info "Run directory: ${RUN_DIR}"
  if [[ -n "$max_runtime" ]]; then
    log_info "Max runtime:   ${max_runtime} minutes"
  fi
  if [[ -n "$max_turns" ]]; then
    log_info "Max turns:     ${max_turns}"
  fi
  echo ""
  log_info "Would perform:"
  log_info "  1. Compose safety preamble + task prompt → composed-prompt.md"
  log_info "  2. Run: claude -p --output-format text < composed-prompt.md > agent-output.md"
  log_info "     (inside worktree: ${worktree_path})"
  log_info "  3. Update run-metadata.json with result"
  exit 0
fi

# ---------------------------------------------------------------------------
# Check prerequisites
# ---------------------------------------------------------------------------
if ! check_command claude; then
  die "Claude CLI not found. Install it first: https://docs.anthropic.com/en/docs/claude-code"
fi

require_command jq

# ---------------------------------------------------------------------------
# Execute
# ---------------------------------------------------------------------------
print_banner "Run Claude"

log_step "Step 1: Verify agent is claude-code"
log_success "Agent: ${agent}"
echo ""

log_step "Step 2: Resolve worktree"
log_success "Worktree: ${worktree_path}"
echo ""

log_step "Step 3: Resolve prompt"
log_success "Prompt file: ${prompt_file}"
echo ""

log_step "Step 4: Compose prompt"
composed=$(compose_prompt "$prompt_file" "$RUN_DIR")
echo ""

log_step "Step 5: Run Claude"
start_time=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# Show elapsed time so the user knows Claude is still running
_show_elapsed() {
  local start=$SECONDS
  while kill -0 "$1" 2>/dev/null; do
    local elapsed=$(( SECONDS - start ))
    local mins=$(( elapsed / 60 ))
    local secs=$(( elapsed % 60 ))
    printf "\r  ⏱  Elapsed: %dm%02ds" "$mins" "$secs"
    sleep 5
  done
  printf "\r%40s\r" ""
}

exit_code=0
run_claude "$composed" "$worktree_path" "$RUN_DIR" "$max_runtime" "$max_turns" "$mode" &
agent_pid=$!
_show_elapsed "$agent_pid" &
timer_pid=$!
wait "$agent_pid" || exit_code=$?
# The elapsed-time display is a background process that is almost always
# mid-`sleep` when Claude finishes. Killing it makes `wait` return 143
# (128+SIGTERM); under `set -e` that would abort this script and mask
# Claude's real exit code. Tolerate the signal so we reach the metadata
# update below and exit with Claude's actual status.
kill "$timer_pid" 2>/dev/null || true
wait "$timer_pid" 2>/dev/null || true
end_time=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

if [[ "$exit_code" -eq 0 ]]; then
  log_success "Claude completed successfully"
  agent_status="agent-complete"
elif [[ "$exit_code" -eq 124 ]]; then
  log_warn "Claude timed out after ${max_runtime} minutes"
  agent_status="agent-timeout"
else
  log_error "Claude exited with code ${exit_code}"
  agent_status="agent-failed"
fi
echo ""

log_step "Step 6: Update run metadata"
tmp=$(mktemp)
jq --arg status "$agent_status" \
   --arg exit_code "$exit_code" \
   --arg start "$start_time" \
   --arg end "$end_time" \
   --arg agent "$agent" \
   '. + {status: $status, agent_exit_code: ($exit_code | tonumber), agent_started_at: $start, agent_finished_at: $end, agent: $agent}' \
   "${RUN_DIR}/run-metadata.json" > "$tmp"
mv "$tmp" "${RUN_DIR}/run-metadata.json"
log_success "Updated run-metadata.json (status: ${agent_status})"

echo ""
if [[ "$exit_code" -eq 0 ]]; then
  log_success "Agent run complete"
  echo ""
  echo "Next steps:"
  echo "  1. Review agent output: ${RUN_DIR}/agent-output.md"
  echo "  2. Run verification:    ./harness/verify-run.sh ${TASK_FILE} --run-dir ${RUN_DIR}"
  echo "  3. Generate report:     ./harness/write-report.sh ${RUN_DIR}"
else
  log_warn "Agent run finished with issues (exit code: ${exit_code})"
  echo ""
  echo "Next steps:"
  echo "  1. Check agent output: ${RUN_DIR}/agent-output.md"
  echo "  2. Review run metadata: ${RUN_DIR}/run-metadata.json"
fi

exit "$exit_code"
