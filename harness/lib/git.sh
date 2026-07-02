#!/usr/bin/env bash
#
# git.sh — Git utility functions for TSD Agent Lab harness
#
# Source guard
[[ -n "${_GIT_SH_LOADED:-}" ]] && return 0
_GIT_SH_LOADED=1

_GIT_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_GIT_SH_DIR}/common.sh"

# ---------------------------------------------------------------------------
# Validation helpers
# ---------------------------------------------------------------------------
git_is_repo() {
  local dir="$1"
  git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null
}

# Normalizes a remote URL for comparison: strips a trailing ".git" and any
# trailing slash, so equivalent URLs (with/without .git suffix) match.
git_normalize_url() {
  local url="$1"
  url="${url%/}"
  url="${url%.git}"
  echo "$url"
}

git_verify_remote() {
  local dir="$1"
  local expected_url="$2"
  local actual_url
  actual_url=$(git -C "$dir" remote get-url origin 2>/dev/null || echo "")
  [[ "$(git_normalize_url "$actual_url")" == "$(git_normalize_url "$expected_url")" ]]
}

# ---------------------------------------------------------------------------
# Clone / fetch / worktree
# ---------------------------------------------------------------------------
git_clone_if_needed() {
  local url="$1"
  local target="$2"

  if [[ -d "$target" ]]; then
    if git_is_repo "$target"; then
      if git_verify_remote "$target" "$url"; then
        log_success "Clone exists and remote matches: ${target}"
        return 0
      else
        die "Clone exists at ${target} but remote URL does not match ${url}"
      fi
    else
      die "Directory exists at ${target} but is not a git repository"
    fi
  fi

  log_info "Cloning ${url} → ${target}"
  git clone "$url" "$target"
  log_success "Cloned: ${target}"
}

git_fetch_ref() {
  local dir="$1"
  local ref="$2"

  log_info "Fetching origin/${ref} in ${dir}"
  git -C "$dir" fetch origin "$ref"
  log_success "Fetched: origin/${ref}"
}

git_create_worktree() {
  local clone_dir="$1"
  local worktree_path="$2"
  local ref="$3"

  log_info "Creating worktree at ${worktree_path} (detached at origin/${ref})"
  git -C "$clone_dir" worktree add --detach "$worktree_path" "origin/${ref}"
  log_success "Worktree created: ${worktree_path}"
}

git_remove_worktree() {
  local clone_dir="$1"
  local worktree_path="$2"

  if [[ -d "$worktree_path" ]]; then
    log_info "Removing worktree: ${worktree_path}"
    git -C "$clone_dir" worktree remove "$worktree_path" --force
    log_success "Worktree removed: ${worktree_path}"
  else
    log_warn "Worktree directory not found: ${worktree_path}"
  fi
}

# ---------------------------------------------------------------------------
# Allowlist check (soft — warns but does not block)
# ---------------------------------------------------------------------------
check_repo_allowlist() {
  local repo_url="$1"
  local lab_root="$2"
  local allowlist="${lab_root}/policies/repo-allowlist.yaml"

  if [[ ! -f "$allowlist" ]]; then
    log_warn "No repo allowlist found at ${allowlist} (skipping check)"
    return 0
  fi

  if grep -q "$repo_url" "$allowlist" 2>/dev/null; then
    log_success "Repository found in allowlist"
    return 0
  fi

  local repo_name
  repo_name=$(basename "$repo_url" .git)
  if grep -q "$repo_name" "$allowlist" 2>/dev/null; then
    log_success "Repository name '${repo_name}' found in allowlist"
    return 0
  fi

  log_warn "Repository not found in allowlist: ${repo_url}"
  log_warn "Proceeding anyway (allowlist is advisory in Phase 3)"
  return 0
}
