#!/usr/bin/env bash
#
# verify.sh — Verification utilities for TSD Agent Lab
#
# Provides functions for running verification commands defined in task specs.
#
# Source guard: safe to source multiple times
[[ -n "${_VERIFY_SH_LOADED:-}" ]] && return 0
_VERIFY_SH_LOADED=1

SCRIPT_DIR_VERIFY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT_VERIFY="$(cd "${SCRIPT_DIR_VERIFY}/../.." && pwd)"

# ---------------------------------------------------------------------------
# Policy check (soft — warns but does not block)
# ---------------------------------------------------------------------------

check_command_allowed() {
  local cmd="$1"
  local allowlist="${LAB_ROOT_VERIFY}/policies/command-allowlist.yaml"

  if [[ ! -f "$allowlist" ]]; then
    log_warn "Command allowlist not found: ${allowlist}"
    return 0
  fi

  local base_cmd
  base_cmd=$(echo "$cmd" | awk '{print $1}')

  if check_command yq; then
    local found
    found=$(yq eval '.. | select(has("commands")) | .commands[].command' "$allowlist" 2>/dev/null | grep -x "$base_cmd" || echo "")
    if [[ -z "$found" ]]; then
      log_warn "Command '${base_cmd}' not found in allowlist (proceeding anyway)"
    fi
  else
    if ! grep -q "command: ${base_cmd}" "$allowlist" 2>/dev/null; then
      log_warn "Command '${base_cmd}' not found in allowlist (proceeding anyway)"
    fi
  fi

  return 0
}

# ---------------------------------------------------------------------------
# Run a single verification command
# ---------------------------------------------------------------------------

run_verification_command() {
  local cmd="$1"
  local worktree_path="$2"
  local log_file="$3"

  {
    echo "$ ${cmd}"
    echo "---"
  } >> "$log_file"

  local exit_code=0
  (cd "$worktree_path" && eval "$cmd" >> "$log_file" 2>&1) || exit_code=$?

  {
    echo ""
    if [[ "$exit_code" -eq 0 ]]; then
      echo "[PASS] exit code: 0"
    else
      echo "[FAIL] exit code: ${exit_code}"
    fi
    echo ""
  } >> "$log_file"

  return "$exit_code"
}

# ---------------------------------------------------------------------------
# Run the full verification suite
# ---------------------------------------------------------------------------

run_verification_suite() {
  local task_file="$1"
  local worktree_path="$2"
  local log_file="$3"

  local commands
  commands=$(read_yaml_array "$task_file" "verification_commands")

  if [[ -z "$commands" ]]; then
    log_info "No verification commands defined in task"
    echo "No verification commands defined." > "$log_file"
    return 0
  fi

  local total=0
  local passed=0
  local failed=0
  local failed_cmd=""

  {
    echo "# Verification Results"
    echo ""
    echo "Started: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    echo ""
  } > "$log_file"

  while IFS= read -r cmd; do
    [[ -z "$cmd" ]] && continue
    total=$((total + 1))

    check_command_allowed "$cmd"

    log_info "  [${total}] ${cmd}"

    if run_verification_command "$cmd" "$worktree_path" "$log_file"; then
      log_success "  [${total}] PASS"
      passed=$((passed + 1))
    else
      log_error "  [${total}] FAIL"
      failed=$((failed + 1))
      failed_cmd="$cmd"
      break
    fi
  done <<< "$commands"

  {
    echo "---"
    echo ""
    echo "## Summary"
    echo ""
    echo "Total:  ${total}"
    echo "Passed: ${passed}"
    echo "Failed: ${failed}"
    if [[ -n "$failed_cmd" ]]; then
      echo "Stopped at: ${failed_cmd}"
    fi
    echo ""
    echo "Finished: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  } >> "$log_file"

  echo ""
  if [[ "$failed" -eq 0 ]]; then
    log_success "Verification: ${passed}/${total} passed"
  else
    log_error "Verification: ${passed}/${total} passed, stopped at: ${failed_cmd}"
  fi

  return "$failed"
}
