#!/usr/bin/env bash
#
# export-patch.sh — Export a .patch file from a completed run's worktree diff
#
# Usage: ./harness/export-patch.sh <run-dir> [--dry-run]
#
# Reads the worktree path from run-metadata.json, runs git diff, and writes
# changes.patch + changed-files.txt into the run directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/agent.sh"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  echo "Usage: $(basename "$0") <run-dir> [--dry-run]"
  echo ""
  echo "Export a .patch file from the worktree diff of a completed run."
  echo ""
  echo "Outputs:"
  echo "  <run-dir>/changes.patch      — diff suitable for git apply"
  echo "  <run-dir>/changed-files.txt  — list of changed file paths"
  echo ""
  echo "Options:"
  echo "  --dry-run    Print what would be generated without writing files"
  exit 1
}

# ---------------------------------------------------------------------------
# Mode check
# ---------------------------------------------------------------------------
ALLOWED_MODES="patch-only draft-pr commit-allowed"

mode_allows_patch() {
  local mode="$1"
  for allowed in $ALLOWED_MODES; do
    [[ "$mode" == "$allowed" ]] && return 0
  done
  return 1
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
  usage
fi

RUN_DIR="$1"
shift

if [[ ! -d "$RUN_DIR" ]]; then
  die "Run directory not found: ${RUN_DIR}"
fi

if [[ ! -f "${RUN_DIR}/run-metadata.json" ]]; then
  die "Not a valid run directory (missing run-metadata.json): ${RUN_DIR}"
fi

require_command jq

run_id=$(jq -r '.run_id' "${RUN_DIR}/run-metadata.json")
mode=$(jq -r '.mode' "${RUN_DIR}/run-metadata.json")
task_id=$(jq -r '.task_id' "${RUN_DIR}/run-metadata.json")

if ! mode_allows_patch "$mode"; then
  die "Mode '${mode}' does not support patch export. Allowed modes: ${ALLOWED_MODES}"
fi

print_banner "Export Patch: ${run_id}"

worktree_path=$(resolve_worktree "$RUN_DIR")
log_info "Worktree:   ${worktree_path}"
log_info "Run dir:    ${RUN_DIR}"
log_info "Mode:       ${mode}"

# ---------------------------------------------------------------------------
# Check for changes
# ---------------------------------------------------------------------------
diff_stat=$(git -C "$worktree_path" diff --stat 2>/dev/null || echo "")

if [[ -z "$diff_stat" ]]; then
  log_warn "No uncommitted changes found in worktree: ${worktree_path}"
  log_warn "The agent may have committed changes (check git log) or made no edits."
  exit 0
fi

log_info "Diff summary:"
echo "$diff_stat"
echo ""

PATCH_FILE="${RUN_DIR}/changes.patch"
CHANGED_FILES="${RUN_DIR}/changed-files.txt"

# ---------------------------------------------------------------------------
# Dry-run
# ---------------------------------------------------------------------------
if is_dry_run "$@"; then
  log_info "[dry-run] Would write: ${PATCH_FILE}"
  log_info "[dry-run] Would write: ${CHANGED_FILES}"
  echo ""
  log_info "Apply instructions (for reference):"
  log_info "  cd <target-repo> && git apply ${PATCH_FILE}"
  log_info "  cd <target-repo> && git apply --check ${PATCH_FILE}  # verify first"
  exit 0
fi

# ---------------------------------------------------------------------------
# Write outputs
# ---------------------------------------------------------------------------
git -C "$worktree_path" diff > "$PATCH_FILE"
git -C "$worktree_path" diff --name-only > "$CHANGED_FILES"

log_success "Patch written:        ${PATCH_FILE}"
log_success "Changed files list:   ${CHANGED_FILES}"

changed_count=$(wc -l < "$CHANGED_FILES" | tr -d ' ')
log_info "Files changed: ${changed_count}"

echo ""
log_step "To apply this patch to a target repository:"
log_info "  cd <target-repo>"
log_info "  git apply --check ${PATCH_FILE}   # dry-run check"
log_info "  git apply ${PATCH_FILE}            # apply"
log_info "  git apply --stat ${PATCH_FILE}     # show stats only"
