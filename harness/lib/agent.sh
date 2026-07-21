#!/usr/bin/env bash
#
# agent.sh — Agent invocation utilities for TSD Agent Lab
#
# Provides functions for prompt resolution, composition, and agent execution.
#
# Source guard: safe to source multiple times
[[ -n "${_AGENT_SH_LOADED:-}" ]] && return 0
_AGENT_SH_LOADED=1

SCRIPT_DIR_AGENT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT_AGENT="$(cd "${SCRIPT_DIR_AGENT}/../.." && pwd)"

# ---------------------------------------------------------------------------
# Prompt resolution
# ---------------------------------------------------------------------------

# Derive default prompt file from agent + mode
_default_prompt_file() {
  local agent="$1"
  local mode="$2"

  case "${agent}" in
    claude-code)
      case "${mode}" in
        read-only)       echo "prompts/claude/read-only-codebase-map.md" ;;
        patch-only)      echo "prompts/claude/bugfix-patch-only.md" ;;
        branch-only)     echo "prompts/claude/bugfix-patch-only.md" ;;
        review-only)     echo "prompts/claude/review-only.md" ;;
        commit-allowed)  echo "prompts/claude/bugfix-patch-only.md" ;;
        *)               echo "" ;;
      esac
      ;;
    *)
      echo ""
      ;;
  esac
}

# Resolve prompt file: explicit prompt_file field, or derive from agent + mode
resolve_prompt_file() {
  local task_file="$1"
  local prompt_file
  prompt_file=$(read_yaml_field "$task_file" "prompt_file")

  if [[ -n "$prompt_file" ]]; then
    if [[ "$prompt_file" != /* ]]; then
      prompt_file="${LAB_ROOT_AGENT}/${prompt_file}"
    fi
    echo "$prompt_file"
    return
  fi

  local agent mode
  agent=$(read_yaml_field "$task_file" "agent")
  agent="${agent:-claude-code}"
  mode=$(read_yaml_field_required "$task_file" "mode")

  local default
  default=$(_default_prompt_file "$agent" "$mode")

  if [[ -z "$default" ]]; then
    die "Cannot resolve prompt: no prompt_file set and no default for agent='${agent}' mode='${mode}'"
  fi

  echo "${LAB_ROOT_AGENT}/${default}"
}

# ---------------------------------------------------------------------------
# Prompt composition
# ---------------------------------------------------------------------------

# Concatenate safety preamble + task prompt into composed-prompt.md
compose_prompt() {
  local prompt_file="$1"
  local run_dir="$2"
  local preamble="${LAB_ROOT_AGENT}/prompts/common/safety-preamble.md"
  local composed="${run_dir}/composed-prompt.md"

  if [[ ! -f "$preamble" ]]; then
    die "Safety preamble not found: ${preamble}"
  fi

  if [[ ! -f "$prompt_file" ]]; then
    die "Prompt file not found: ${prompt_file}"
  fi

  {
    cat "$preamble"
    echo ""
    echo "---"
    echo ""
    cat "$prompt_file"
  } > "$composed"

  log_success "Composed prompt: ${composed}" >&2
  echo "$composed"
}

# ---------------------------------------------------------------------------
# Worktree resolution
# ---------------------------------------------------------------------------

# Read worktree_path from run-metadata.json
resolve_worktree() {
  local run_dir="$1"
  local metadata="${run_dir}/run-metadata.json"
  local worktree_path

  if [[ ! -f "$metadata" ]]; then
    die "run-metadata.json not found in ${run_dir}"
  fi

  require_command jq
  worktree_path=$(jq -r '.worktree_path // empty' "$metadata" 2>/dev/null || echo "")

  if [[ -z "$worktree_path" ]]; then
    worktree_path="${run_dir}/worktree"
  fi

  if [[ ! -d "$worktree_path" ]]; then
    die "Worktree directory not found: ${worktree_path}"
  fi

  echo "$worktree_path"
}

# ---------------------------------------------------------------------------
# Agent execution
# ---------------------------------------------------------------------------

# Run claude -p with the composed prompt in the worktree
#
# Args: composed_prompt worktree_path run_dir [max_runtime] [max_turns] [mode]
run_claude() {
  local composed_prompt="$1"
  local worktree_path="$2"
  local run_dir="$3"
  local max_runtime="${4:-}"
  local output="${run_dir}/agent-output.md"

  local max_turns="${5:-}"
  local mode="${6:-}"
  local cmd="claude -p --output-format text"

  # Mode-based tool restrictions
  if [[ "$mode" == "review-only" ]]; then
    cmd="${cmd} --dangerously-skip-permissions"
    cmd="${cmd} --disallowedTools \"Edit,Write,NotebookEdit,Bash(git push*),Bash(git checkout*),Bash(gh pr *),Bash(gh issue *),Bash(curl *),Bash(wget *)\""
    cmd="${cmd} --max-budget-usd 2"
    cmd="${cmd} --model sonnet"
  fi

  if [[ -n "$max_turns" && "$max_turns" -gt 0 ]] 2>/dev/null; then
    cmd="${cmd} --max-turns ${max_turns}"
  fi

  if [[ -n "$max_runtime" && "$max_runtime" -gt 0 ]] 2>/dev/null; then
    local timeout_seconds=$((max_runtime * 60))
    if check_command timeout; then
      cmd="timeout ${timeout_seconds} ${cmd}"
    elif check_command gtimeout; then
      cmd="gtimeout ${timeout_seconds} ${cmd}"
    else
      log_warn "No timeout command available; ignoring max_runtime_minutes=${max_runtime}"
    fi
  fi

  log_info "Running Claude in: ${worktree_path}"
  log_info "Output: ${output}"
  if [[ "$mode" == "review-only" ]]; then
    log_info "Mode: review-only (tool restrictions active)"
  fi

  local exit_code=0
  local stderr_log="${run_dir}/agent-stderr.log"
  (cd "$worktree_path" && eval $cmd < "$composed_prompt" > "$output" 2>"$stderr_log") || exit_code=$?

  return "$exit_code"
}
