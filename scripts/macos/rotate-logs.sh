#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
LOG_DIR="${REPO_ROOT}/logs"

source "${REPO_ROOT}/harness/lib/common.sh"
require_command find

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
fi

rotated_count=0

while IFS= read -r logfile; do
  basename_file=$(basename "$logfile")

  if [[ $DRY_RUN -eq 1 ]]; then
    log_info "[DRY-RUN] Would rotate: $basename_file"
    [[ -f "${logfile}.3" ]] && log_info "[DRY-RUN]   Delete: ${basename_file}.3"
    [[ -f "${logfile}.2" ]] && log_info "[DRY-RUN]   Move: ${basename_file}.2 → ${basename_file}.3"
    [[ -f "${logfile}.1" ]] && log_info "[DRY-RUN]   Move: ${basename_file}.1 → ${basename_file}.2"
    log_info "[DRY-RUN]   Move: ${basename_file} → ${basename_file}.1"
    log_info "[DRY-RUN]   Create: empty ${basename_file}"
    ((rotated_count++))
  else
    [[ -f "${logfile}.3" ]] && rm -f "${logfile}.3"
    [[ -f "${logfile}.2" ]] && mv "${logfile}.2" "${logfile}.3"
    [[ -f "${logfile}.1" ]] && mv "${logfile}.1" "${logfile}.2"
    mv "$logfile" "${logfile}.1"
    touch "$logfile"
    log_success "Rotated: $basename_file"
    ((rotated_count++))
  fi
done < <(find "$LOG_DIR" -maxdepth 1 -name "*.log" -size +500k)

if [[ $DRY_RUN -eq 1 ]]; then
  log_info "[DRY-RUN] Summary: would rotate $rotated_count file(s)"
else
  log_success "Summary: rotated $rotated_count file(s)"
fi
