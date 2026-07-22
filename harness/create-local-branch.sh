#!/usr/bin/env bash
#
# create-local-branch.sh — Create a named local branch from worktree changes
#
# Usage: ./harness/create-local-branch.sh <run-dir> [--force] [--dry-run]
#
# Stages all uncommitted changes in the worktree, creates a branch named
# agent-lab/<task_id>, commits with a descriptive message, and prints the
# manual push command. Does NOT push.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/agent.sh"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  echo "Usage: $(basename "$0") <run-dir> [--force] [--dry-run]"
  echo ""
  echo "Create a local git branch from uncommitted changes in the run worktree."
  echo ""
  echo "Branch name: agent-lab/<task_id>"
  echo ""
  echo "Options:"
  echo "  --force      Overwrite existing branch of the same name"
  echo "  --dry-run    Print what would happen without making any changes"
  exit 1
}

# ---------------------------------------------------------------------------
# Mode check
# ---------------------------------------------------------------------------
ALLOWED_MODES="patch-only branch-only draft-pr commit-allowed"

mode_allows_branch() {
  local mode="$1"
  for allowed in $ALLOWED_MODES; do
    [[ "$mode" == "$allowed" ]] && return 0
  done
  return 1
}

# ---------------------------------------------------------------------------
# Arg parsing
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
  usage
fi

RUN_DIR="$1"
shift

FORCE=false
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --force)   FORCE=true ;;
    --dry-run) DRY_RUN=true ;;
    -h|--help) usage ;;
    *) die "Unknown argument: ${arg}" ;;
  esac
done

# ---------------------------------------------------------------------------
# Validate run directory
# ---------------------------------------------------------------------------
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

if ! mode_allows_branch "$mode"; then
  die "Mode '${mode}' does not support branch creation. Allowed modes: ${ALLOWED_MODES}"
fi

print_banner "Create Local Branch: ${run_id}"

worktree_path=$(resolve_worktree "$RUN_DIR")
branch_name="agent-lab/${task_id}"

log_info "Worktree:     ${worktree_path}"
log_info "Run dir:      ${RUN_DIR}"
log_info "Mode:         ${mode}"
log_info "Branch name:  ${branch_name}"

# ---------------------------------------------------------------------------
# Check for changes
# ---------------------------------------------------------------------------
diff_stat=$(git -C "$worktree_path" diff --stat 2>/dev/null || echo "")
staged_stat=$(git -C "$worktree_path" diff --cached --stat 2>/dev/null || echo "")

if [[ -z "$diff_stat" && -z "$staged_stat" ]]; then
  log_warn "No uncommitted changes found in worktree: ${worktree_path}"
  log_warn "The agent may have committed changes or made no edits."
  log_info "Check git log: cd ${worktree_path} && git log --oneline"
  exit 0
fi

if [[ -n "$diff_stat" ]]; then
  log_info "Unstaged changes:"
  echo "$diff_stat"
  echo ""
fi

# ---------------------------------------------------------------------------
# Check for existing branch
# ---------------------------------------------------------------------------
branch_exists=false
if git -C "$worktree_path" rev-parse --verify "refs/heads/${branch_name}" &>/dev/null; then
  branch_exists=true
fi

if $branch_exists && ! $FORCE; then
  die "Branch '${branch_name}' already exists. Use --force to overwrite."
fi

# ---------------------------------------------------------------------------
# Dry-run
# ---------------------------------------------------------------------------
if $DRY_RUN; then
  log_info "[dry-run] Would stage all changes: git -C ${worktree_path} add -A"
  if $branch_exists; then
    log_info "[dry-run] Would delete existing branch: git -C ${worktree_path} branch -D ${branch_name}"
  fi
  log_info "[dry-run] Would create branch: git -C ${worktree_path} checkout -b ${branch_name}"
  log_info "[dry-run] Would commit: git -C ${worktree_path} commit -m 'feat(agent-lab): ${title}'"
  echo ""
  log_info "Push command (for reference):"
  log_info "  cd ${worktree_path} && git push -u origin ${branch_name}"
  exit 0
fi

# ---------------------------------------------------------------------------
# Stage, branch, commit
# ---------------------------------------------------------------------------
log_step "Staging all changes..."
git -C "$worktree_path" add -A

if $branch_exists; then
  log_warn "Deleting existing branch: ${branch_name}"
  git -C "$worktree_path" branch -D "$branch_name"
fi

log_step "Creating branch: ${branch_name}"
git -C "$worktree_path" checkout -b "$branch_name"

commit_msg="feat(agent-lab): ${title}

Run ID: ${run_id}
Mode: ${mode}
Task: ${task_id}

Generated by TSD Agent Lab harness. Human review required before push."

log_step "Committing changes..."
git -C "$worktree_path" commit -m "$commit_msg"

log_success "Branch created: ${branch_name}"
log_info "Commit: $(git -C "$worktree_path" log --oneline -1)"

echo ""
log_step "To push this branch:"
log_info "  cd ${worktree_path}"
log_info "  git push -u origin ${branch_name}"
echo ""
log_step "To open a draft PR (GitHub CLI):"
log_info "  cd ${worktree_path}"
log_info "  gh pr create --draft --title '${title}' --head ${branch_name}"
