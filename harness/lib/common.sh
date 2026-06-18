#!/usr/bin/env bash
#
# common.sh — Shared utilities for TSD Agent Lab harness scripts
#
# Source guard: safe to source multiple times
[[ -n "${_COMMON_SH_LOADED:-}" ]] && return 0
_COMMON_SH_LOADED=1

set -euo pipefail

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
log_info()    { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warn()    { echo -e "${YELLOW}○${NC} $*"; }
log_error()   { echo -e "${RED}✗${NC} $*"; }
log_step()    { echo -e "${BLUE}$*${NC}"; }

die() {
  log_error "$@" >&2
  exit 1
}

print_banner() {
  local title="$1"
  local width=60
  echo -e "${CYAN}"
  echo "╔$(printf '═%.0s' $(seq 1 $width))╗"
  printf "║ %-${width}s║\n" "${title}"
  echo "╚$(printf '═%.0s' $(seq 1 $width))╝"
  echo -e "${NC}"
}

# ---------------------------------------------------------------------------
# Tool checks
# ---------------------------------------------------------------------------
require_command() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    die "Required command not found: ${cmd}"
  fi
}

check_command() {
  command -v "$1" &>/dev/null
}

# ---------------------------------------------------------------------------
# Directory helpers
# ---------------------------------------------------------------------------
ensure_directory() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    log_success "${dir} (exists)"
  else
    mkdir -p "$dir"
    log_success "${dir} (created)"
  fi
}

# ---------------------------------------------------------------------------
# Workspace path defaults (override via env vars)
# ---------------------------------------------------------------------------
TSD_RUNS_DIR="${TSD_RUNS_DIR:-${HOME}/workspaces/runs}"
TSD_REPOS_DIR="${TSD_REPOS_DIR:-${HOME}/workspaces/repos}"
TSD_REPORTS_DIR="${TSD_REPORTS_DIR:-${HOME}/workspaces/reports}"

# ---------------------------------------------------------------------------
# YAML reading — dual-path: yq if available, grep/sed fallback
# ---------------------------------------------------------------------------
read_yaml_field() {
  local file="$1"
  local field="$2"
  local value=""

  if check_command yq; then
    value=$(yq eval ".${field}" "$file" 2>/dev/null || echo "")
    if [[ "$value" == "null" ]]; then
      value=""
    fi
  else
    value=$(grep "^${field}:" "$file" 2>/dev/null | head -1 | sed 's/^[^:]*:[[:space:]]*//' | sed 's/^["'"'"']//' | sed 's/["'"'"']$//' || echo "")
  fi

  echo "$value"
}

read_yaml_field_required() {
  local file="$1"
  local field="$2"
  local value
  value=$(read_yaml_field "$file" "$field")

  if [[ -z "$value" ]]; then
    die "Required field '${field}' is missing or empty in ${file}"
  fi

  echo "$value"
}

# ---------------------------------------------------------------------------
# Run ID generation
# ---------------------------------------------------------------------------
generate_run_id() {
  local task_id="$1"
  echo "${task_id}-$(date '+%Y-%m-%d-%H%M%S')"
}

# ---------------------------------------------------------------------------
# Dry-run support
# ---------------------------------------------------------------------------
is_dry_run() {
  if [[ "${DRY_RUN:-}" == "1" || "${DRY_RUN:-}" == "true" ]]; then
    return 0
  fi

  for arg in "$@"; do
    if [[ "$arg" == "--dry-run" ]]; then
      return 0
    fi
  done

  return 1
}
