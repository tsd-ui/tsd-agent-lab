#!/usr/bin/env bash
#
# migrate-reports-to-subdirs.sh
# One-time migration: move flat reports/ files into type subdirectories.
#
# Usage: ./scripts/macos/migrate-reports-to-subdirs.sh [--dry-run] [--help]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPORT_DIR="${REPO_ROOT}/reports"
DRY_RUN=false

usage() {
  cat <<'USAGE'
Usage: migrate-reports-to-subdirs.sh [OPTIONS]

Migrate flat reports/ files into subdirectories with
current/previous/archive layout.

Options:
  --dry-run   Show what would happen without moving files
  --help      Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

run_cmd() {
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

# Discover unique report types from dated filenames
types=""
for f in "${REPORT_DIR}"/*-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].*; do
  [[ -f "$f" ]] || continue
  bn="$(basename "$f")"
  t="${bn%-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].*}"
  case "$types" in
    *"|${t}|"*) ;;
    *) types="${types}|${t}|" ;;
  esac
done

if [[ -z "$types" ]]; then
  echo "No dated report files found in ${REPORT_DIR}. Nothing to migrate."
  exit 0
fi

# Process each type
echo "$types" | tr '|' '\n' | sort -u | while IFS= read -r type; do
  [[ -z "$type" ]] && continue
  echo "Migrating type: ${type}"

  subdir="${REPORT_DIR}/${type}"
  archive_dir="${subdir}/archive"
  run_cmd mkdir -p "$archive_dir"

  # Find unique extensions for this type
  exts=""
  for f in "${REPORT_DIR}/${type}"-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].*; do
    [[ -f "$f" ]] || continue
    ext="${f##*.}"
    case "$exts" in
      *"|${ext}|"*) ;;
      *) exts="${exts}|${ext}|" ;;
    esac
  done

  echo "$exts" | tr '|' '\n' | sort -u | while IFS= read -r ext; do
    [[ -z "$ext" ]] && continue

    # Collect and sort files for this type+ext
    sorted=()
    while IFS= read -r filepath; do
      [[ -z "$filepath" ]] && continue
      sorted+=("$filepath")
    done < <(ls -1 "${REPORT_DIR}/${type}"-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]."${ext}" 2>/dev/null | sort)

    count=${#sorted[@]}
    [[ "$count" -eq 0 ]] && continue

    for filepath in "${sorted[@]}"; do
      bn="$(basename "$filepath")"
      echo "  Moving ${bn} -> ${type}/archive/${bn}"
      run_cmd mv "$filepath" "${archive_dir}/${bn}"
    done

    # Latest -> current
    latest_bn="$(basename "${sorted[$((count - 1))]}")"
    echo "  Copying archive/${latest_bn} -> current.${ext}"
    run_cmd cp "${archive_dir}/${latest_bn}" "${subdir}/current.${ext}"

    # Second-latest -> previous
    if [[ "$count" -ge 2 ]]; then
      prev_bn="$(basename "${sorted[$((count - 2))]}")"
      echo "  Copying archive/${prev_bn} -> previous.${ext}"
      run_cmd cp "${archive_dir}/${prev_bn}" "${subdir}/previous.${ext}"
    fi
  done
done

# Remove .gitkeep if present
if [[ -f "${REPORT_DIR}/.gitkeep" ]]; then
  echo "Removing .gitkeep"
  run_cmd rm "${REPORT_DIR}/.gitkeep"
fi

echo ""
if [[ "$DRY_RUN" == "true" ]]; then
  echo "Dry run complete. No files were moved."
else
  echo "Migration complete."
fi
