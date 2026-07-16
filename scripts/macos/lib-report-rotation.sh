#!/usr/bin/env bash
#
# lib-report-rotation.sh
# Shared report rotation library — sourced by report scripts.
#
# Usage: source scripts/macos/lib-report-rotation.sh
#        rotate_report <subdir> <report-name> <today> <ext>
#
# Manages current/previous/archive layout under reports/<subdir>/:
#   current.<ext>   — always the latest report
#   previous.<ext>  — the report that was current before this run
#   archive/        — all historical copies, date-stamped
#
# Same-day guard: if archive/<report-name>-<today>.<ext> already exists,
# this is a re-run — skip the current->previous rotation so yesterday's
# report isn't lost. The caller still overwrites current and archive.

rotate_report() {
  local subdir="$1" report_name="$2" today="$3" ext="$4"

  mkdir -p "${subdir}/archive"

  local archive_file="${subdir}/archive/${report_name}-${today}.${ext}"
  local current_file="${subdir}/current.${ext}"
  local previous_file="${subdir}/previous.${ext}"

  if [[ -f "$archive_file" ]]; then
    return 0
  fi

  if [[ -f "$current_file" ]]; then
    cp "$current_file" "$previous_file"
  fi
}
