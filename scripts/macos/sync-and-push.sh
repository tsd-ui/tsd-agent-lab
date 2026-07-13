#!/usr/bin/env bash
#
# sync-and-push.sh
# Auto-commit and push changes from the Obsidian-synced tsd-agent-lab repo.
#
# Designed to run as a user LaunchAgent. Pulls remote changes (rebase),
# commits any local changes, and pushes to origin/main.
#
# Usage: ./scripts/macos/sync-and-push.sh [--dry-run] [--help]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
LOG_DIR="${REPO_ROOT}/logs"
LOG_FILE="${LOG_DIR}/sync-and-push.log"
DRY_RUN=false

usage() {
  cat <<'USAGE'
Usage: sync-and-push.sh [OPTIONS]

Auto-commit and push changes from the tsd-agent-lab repo.

Options:
  --dry-run   Show what would happen without making changes
  --help      Show this help message
USAGE
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --help)    usage; exit 0 ;;
    *)         echo "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

mkdir -p "$LOG_DIR"

log() {
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[${ts}] $*" >> "$LOG_FILE"
}

cd "$REPO_ROOT"

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  log "ERROR: ${REPO_ROOT} is not a git repository"
  exit 1
fi

BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null || true)"
if [[ "$BRANCH" != "main" ]]; then
  log "SKIP: not on main branch (on '${BRANCH}')"
  exit 0
fi

if git rev-parse --verify refs/stash &>/dev/null 2>&1 && [[ "$(git stash list | wc -l)" -gt 0 ]]; then
  log "SKIP: stash is non-empty — manual intervention may be in progress"
  exit 0
fi

if [[ -d "${REPO_ROOT}/.git/rebase-merge" ]] || [[ -d "${REPO_ROOT}/.git/rebase-apply" ]]; then
  log "SKIP: rebase in progress"
  exit 0
fi

log "--- sync started ---"

# Pull remote changes
git fetch origin main --quiet 2>>"$LOG_FILE"

LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main)"

if [[ "$LOCAL" != "$REMOTE" ]]; then
  BEHIND="$(git rev-list HEAD..origin/main --count)"
  if [[ "$BEHIND" -gt 0 ]]; then
    log "Pulling ${BEHIND} remote commit(s) via rebase"
    if "$DRY_RUN"; then
      log "DRY-RUN: would rebase onto origin/main"
    else
      if ! git rebase origin/main 2>>"$LOG_FILE"; then
        log "ERROR: rebase failed — aborting"
        git rebase --abort 2>>"$LOG_FILE" || true
        exit 1
      fi
    fi
  fi
fi

# Stage and commit local changes
UNTRACKED="$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')"
MODIFIED="$(git diff --name-only | wc -l | tr -d ' ')"
TOTAL=$((UNTRACKED + MODIFIED))

if [[ "$TOTAL" -eq 0 ]]; then
  log "No local changes to commit"
else
  log "Found ${MODIFIED} modified, ${UNTRACKED} untracked file(s)"

  if "$DRY_RUN"; then
    log "DRY-RUN: would commit ${TOTAL} file(s)"
  else
    git add -A
    SUMMARY="$(git diff --cached --stat | tail -1 | sed 's/^ *//')"
    git commit -m "chore(auto-sync): ${SUMMARY}" --no-verify 2>>"$LOG_FILE"
    log "Committed: ${SUMMARY}"
  fi
fi

# Push if ahead of remote
AHEAD="$(git rev-list origin/main..HEAD --count)"
if [[ "$AHEAD" -gt 0 ]]; then
  log "Pushing ${AHEAD} commit(s) to origin/main"
  if "$DRY_RUN"; then
    log "DRY-RUN: would push ${AHEAD} commit(s)"
  else
    git push origin main 2>>"$LOG_FILE"
    log "Push complete"
  fi
else
  log "Nothing to push"
fi

log "--- sync finished ---"
