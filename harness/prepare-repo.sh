#!/usr/bin/env bash
#
# prepare-repo.sh — Safe clone + worktree creation for a run
#
# Usage: ./harness/prepare-repo.sh <task-file> --run-dir <run-dir> [--dry-run]
#
# Clones the repository (if not already cloned), fetches the base ref,
# and creates a detached worktree inside the run directory.
#
# Safety: detached HEAD (no branch to push), never modifies the
# reference clone, never pushes, never creates remote branches.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/git.sh"

LAB_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  echo "Usage: $(basename "$0") <task-file> --run-dir <run-dir> [--dry-run]"
  echo ""
  echo "Clone the task's repository and create an isolated worktree."
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
repo_url=$(read_yaml_field_required "$TASK_FILE" "repo_url")
base_ref=$(read_yaml_field "$TASK_FILE" "base_ref")
base_ref="${base_ref:-main}"

repo_name=$(basename "$repo_url" .git)
clone_dir="${TSD_REPOS_DIR}/${repo_name}"
worktree_path="${RUN_DIR}/worktree"

# ---------------------------------------------------------------------------
# Dry-run
# ---------------------------------------------------------------------------
if [[ "$DRY_RUN_FLAG" == "true" ]]; then
  print_banner "Dry Run: prepare-repo"
  log_info "Task file:     ${TASK_FILE}"
  log_info "Repo URL:      ${repo_url}"
  log_info "Base ref:      ${base_ref}"
  log_info "Clone dir:     ${clone_dir}"
  log_info "Worktree path: ${worktree_path}"
  echo ""
  log_info "Would perform:"
  log_info "  1. Check repo allowlist"
  log_info "  2. Clone ${repo_url} → ${clone_dir} (if needed)"
  log_info "  3. Fetch origin/${base_ref}"
  log_info "  4. Create detached worktree at ${worktree_path}"
  log_info "  5. Update run-metadata.json"
  exit 0
fi

# ---------------------------------------------------------------------------
# Execute
# ---------------------------------------------------------------------------
require_command git

print_banner "Prepare Repository"

log_step "Step 1: Check allowlist"
check_repo_allowlist "$repo_url" "$LAB_ROOT"
echo ""

log_step "Step 2: Clone repository"
ensure_directory "$TSD_REPOS_DIR"
git_clone_if_needed "$repo_url" "$clone_dir"
echo ""

log_step "Step 3: Fetch base ref"
git_fetch_ref "$clone_dir" "$base_ref"
echo ""

log_step "Step 4: Create worktree"
git_create_worktree "$clone_dir" "$worktree_path" "$base_ref"
echo ""

log_step "Step 5: Update run metadata"
if [[ -f "${RUN_DIR}/run-metadata.json" ]] && check_command jq; then
  tmp=$(mktemp)
  jq --arg wp "$worktree_path" \
     --arg br "$base_ref" \
     --arg cd "$clone_dir" \
     '. + {worktree_path: $wp, base_ref: $br, clone_dir: $cd, status: "repo-ready"}' \
     "${RUN_DIR}/run-metadata.json" > "$tmp"
  mv "$tmp" "${RUN_DIR}/run-metadata.json"
  log_success "Updated run-metadata.json"
else
  log_warn "Could not update run-metadata.json (missing file or jq)"
fi

echo ""
log_success "Repository prepared for run"
echo ""
echo "Next steps:"
echo "  1. cd ${worktree_path}"
echo "  2. Run your agent or analysis"
echo "  3. Generate a report: ./harness/write-report.sh ${RUN_DIR}"
