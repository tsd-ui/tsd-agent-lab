#!/usr/bin/env bash
#
# stale-docs-check.sh
# Mechanical (path/link) staleness scan for repo documentation
#
# Usage: ./scripts/macos/stale-docs-check.sh [--dry-run] [--help]
#
# This script performs deterministic, mechanical checks only: it verifies
# that file paths and markdown links referenced in docs actually exist. It
# does NOT perform semantic review (e.g. "does this setup guide still match
# the bootstrap process?") — that requires LLM reasoning and is handled by
# the stale-docs-check skill (skills/stale-docs-check/SKILL.md), which runs
# this script for its mechanical pass and layers semantic findings on top.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPORT_DIR="${REPO_ROOT}/reports"
TODAY="$(date +%Y-%m-%d)"
REPORT_FILE="${REPORT_DIR}/stale-docs-${TODAY}.md"
DRY_RUN=false

usage() {
  cat <<'USAGE'
Usage: stale-docs-check.sh [OPTIONS]

Scan all Markdown files (excluding docs/archive/) for references to file
paths, scripts, and cross-doc links that no longer exist. This is the
mechanical half of the stale-docs-check; see skills/stale-docs-check/SKILL.md
for the full workflow that adds semantic review.

Options:
  --dry-run   Print the report to stdout without writing a file
  --help      Show this help message

Output:
  Default: writes to reports/stale-docs-YYYY-MM-DD.md
  Dry run: prints to stdout
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

cd "$REPO_ROOT"

stale_count=0
review_count=0
findings_body=""
current_finding_file=""

section() {
  findings_body+="$1"$'\n'
}

# Emits a finding row; opens a new "### <file>" heading whenever the file
# changes so findings stay grouped, per the report's grouped-by-file format.
add_finding() {
  local file=$1 line=$2 category=$3 message=$4 suggestion=$5

  if [[ "$file" != "$current_finding_file" ]]; then
    [[ -n "$current_finding_file" ]] && section ""
    section "### \`${file}\`"
    section ""
    section "| Line | Category | Finding | Suggested fix / question |"
    section "|------|----------|---------|---------------------------|"
    current_finding_file="$file"
  fi
  section "| ${line} | ${category} | ${message} | ${suggestion} |"

  if [[ "$category" == "stale" ]]; then
    stale_count=$((stale_count + 1))
  else
    review_count=$((review_count + 1))
  fi
}

# Resolves a referenced path against (1) the referencing doc's own directory
# and (2) the repo root, since docs mix both relative-to-doc and
# relative-to-root conventions. Returns 0 (found) or 1 (missing).
path_exists() {
  local doc_dir=$1 target=$2
  if [[ "$target" == /* ]]; then
    [[ -e "${REPO_ROOT}${target}" ]] && return 0
    return 1
  fi
  [[ -e "${doc_dir}/${target}" ]] && return 0
  [[ -e "${REPO_ROOT}/${target}" ]] && return 0
  return 1
}

# Skips obvious placeholders/templates so naming-convention examples (e.g.
# "{skill}-{target}-{variant}.yaml") aren't flagged as broken references.
looks_like_placeholder() {
  local target=$1
  case "$target" in
    *'{'*|*'}'*|*'<'*|*'>'*|*TODO*|*example.com*|*your-*|*'*'*) return 0 ;;
    *YYYY*|*NNNN*|*HHMMSS*) return 0 ;;
    *-N-*|*-N.*|*Phase-N*) return 0 ;;
  esac
  return 1
}

# ---------------------------------------------------------------------------
# Check: markdown links [text](path) — high confidence, categorized "stale"
# ---------------------------------------------------------------------------
check_markdown_links() {
  local file doc_dir lineno match target
  while IFS= read -r file; do
    doc_dir="$(dirname "${REPO_ROOT}/${file}")"
    while IFS=: read -r lineno match; do
      [[ -z "${lineno:-}" ]] && continue
      target="${match#*](}"
      target="${target%)}"
      target="${target%%#*}"
      [[ -z "$target" ]] && continue
      case "$target" in
        http://*|https://*|mailto:*|"") continue ;;
      esac
      looks_like_placeholder "$target" && continue
      if ! path_exists "$doc_dir" "$target"; then
        add_finding "$file" "$lineno" "stale" \
          "Markdown link target \`${target}\` does not exist" \
          "Update or remove the link"
      fi
    done < <(grep -noE '\]\([^)]+\)' "${REPO_ROOT}/${file}" 2>/dev/null || true)
  done < <(list_md_files)
}

# ---------------------------------------------------------------------------
# Check: bare path-like references outside markdown links — lower
# confidence (prose can describe paths loosely), categorized "review"
# ---------------------------------------------------------------------------
check_bare_path_references() {
  local file doc_dir lineno target
  local pattern='\b(scripts|docs|skills|harness|policies|protocols|examples|prompts|eval|environments|catalog)/[A-Za-z0-9_./-]+\.[A-Za-z0-9]+\b'
  while IFS= read -r file; do
    doc_dir="$(dirname "${REPO_ROOT}/${file}")"
    while IFS=: read -r lineno target; do
      [[ -z "${lineno:-}" ]] && continue
      looks_like_placeholder "$target" && continue
      if ! path_exists "$doc_dir" "$target"; then
        add_finding "$file" "$lineno" "review" \
          "Referenced path \`${target}\` was not found" \
          "Confirm whether this path was renamed, removed, or is illustrative"
      fi
    done < <(grep -noE "$pattern" "${REPO_ROOT}/${file}" 2>/dev/null || true)
  done < <(list_md_files)
}

# ---------------------------------------------------------------------------
# Check: scripts invoked with ./path/to/script.sh should exist AND be
# executable — non-executable is "review" (may be intentional, e.g. a
# library meant to be sourced rather than run)
# ---------------------------------------------------------------------------
check_script_invocations() {
  local file lineno target
  while IFS= read -r file; do
    while IFS=: read -r lineno target; do
      [[ -z "${lineno:-}" ]] && continue
      target="${target#./}"
      looks_like_placeholder "$target" && continue
      if [[ -e "${REPO_ROOT}/${target}" ]] && [[ ! -x "${REPO_ROOT}/${target}" ]]; then
        add_finding "$file" "$lineno" "review" \
          "\`${target}\` is referenced as an invoked script but is not executable" \
          "chmod +x if it's meant to be run directly, or confirm it's a sourced library"
      fi
    done < <(grep -noE '\./(scripts|harness)/[A-Za-z0-9_./-]+\.sh' "${REPO_ROOT}/${file}" 2>/dev/null || true)
  done < <(list_md_files)
}

list_md_files() {
  # reports/ holds this tool's own generated output (and health-report.sh's)
  # — scanning it back would re-flag prior findings as new ones, since the
  # report text itself contains path-like tokens.
  find . -name '*.md' \
    -not -path './docs/archive/*' \
    -not -path './reports/*' \
    -not -path './.git/*' \
    -not -path './node_modules/*' \
    | sed 's|^\./||' | sort
}

# ---------------------------------------------------------------------------
# Run all checks
# ---------------------------------------------------------------------------
check_markdown_links
check_bare_path_references
check_script_invocations

# ---------------------------------------------------------------------------
# Compose final report
# ---------------------------------------------------------------------------
total=$((stale_count + review_count))
if [[ "$total" -eq 0 ]]; then
  findings_section="No mechanical staleness findings. All referenced paths and links resolved."
else
  findings_section="$findings_body"
fi

report="# Stale Docs Check

- **Date:** ${TODAY}
- **Host:** $(hostname)
- **User:** $(whoami)
- **Generated:** $(date '+%Y-%m-%d %H:%M:%S')
- **Scope:** mechanical checks only (path/link existence) — no semantic review

**Summary:** ${stale_count} stale findings, ${review_count} for review (mechanical pass only)

## Mechanical Findings

${findings_section}

## Semantic Findings

Not performed by this script. Run the stale-docs-check skill
(\`skills/stale-docs-check/SKILL.md\`) for full semantic review layered on
top of these mechanical results.
"

clean=$(printf '%s' "$report" | sed 's/[[:space:]]*$//')

if [[ "$DRY_RUN" == "true" ]]; then
  printf '%s\n' "$clean"
else
  mkdir -p "$REPORT_DIR"
  printf '%s\n' "$clean" > "$REPORT_FILE"
  echo "Report written to ${REPORT_FILE}"
fi
