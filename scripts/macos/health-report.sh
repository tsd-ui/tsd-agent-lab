#!/usr/bin/env bash
#
# health-report.sh
# Daily health report for the agent-lab environment
#
# Usage: ./scripts/macos/health-report.sh [--dry-run] [--help]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPORT_DIR="${REPO_ROOT}/docs/admin/reports"
TODAY="$(date +%Y-%m-%d)"
REPORT_FILE="${REPORT_DIR}/health-${TODAY}.md"
DRY_RUN=false
DISK_THRESHOLD=80

usage() {
  cat <<'USAGE'
Usage: health-report.sh [OPTIONS]

Produce a daily health report for the agent-lab environment.

Options:
  --dry-run   Print the report to stdout without writing a file
  --help      Show this help message

Output:
  Default: writes to docs/admin/reports/health-YYYY-MM-DD.md
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

warnings=0
body=""

section() {
  body+="$1"$'\n'
}

# ---------------------------------------------------------------------------
# Check: tsd-agent-lab launchd agents and their current status
# ---------------------------------------------------------------------------
check_launchd_agents() {
  section "## Launchd Agents"
  section ""

  local relevant
  relevant=$(launchctl list 2>/dev/null | grep -i "tsd-agent-lab" || true)

  if [[ -z "$relevant" ]]; then
    section "No tsd-agent-lab launchd agents registered."
  else
    section "| Status | Last Exit | Label |"
    section "|--------|-----------|-------|"
    while IFS=$'\t' read -r pid exit_code label; do
      local run_status="not running"
      if [[ "$pid" != "-" ]]; then
        run_status="running (PID ${pid})"
      fi
      section "| ${run_status} | ${exit_code} | ${label} |"
    done <<< "$relevant"
  fi
  section ""
}

# ---------------------------------------------------------------------------
# Check: tsd-agent-lab jobs that exited with non-zero status
# ---------------------------------------------------------------------------
check_failed_jobs() {
  section "## Failed Jobs"
  section ""

  local failed
  failed=$(launchctl list 2>/dev/null \
    | awk -F'\t' '$2 != "0" && $2 != "-" && $3 ~ /tsd-agent-lab/' || true)

  if [[ -z "$failed" ]]; then
    section "No failed tsd-agent-lab jobs detected."
  else
    section "The following jobs had non-zero exit status on their last run:"
    section ""
    section "| Exit Code | Label |"
    section "|-----------|-------|"
    while IFS=$'\t' read -r _pid exit_code label; do
      section "| ${exit_code} | ${label} |"
      warnings=$((warnings + 1))
    done <<< "$failed"
  fi
  section ""
}

# ---------------------------------------------------------------------------
# Check: system log errors/faults in the last 24 hours
# ---------------------------------------------------------------------------
check_recent_errors() {
  section "## Recent Log Errors (Last 24h)"
  section ""

  local log_lines
  # log show --last 24h can be slow on busy systems; output capped at 1001 lines
  log_lines=$(log show --last 24h \
    --predicate 'messageType == error OR messageType == fault' \
    --style compact 2>/dev/null \
    | grep -v '^Filtering' \
    | head -1001 || true)

  if [[ -z "$log_lines" ]]; then
    section "No errors or faults in the last 24 hours."
  else
    local count
    count=$(printf '%s\n' "$log_lines" | wc -l | tr -d ' ')
    local qualifier=""
    if [[ "$count" -gt 1000 ]]; then
      count=1000
      qualifier="+"
    fi

    if [[ "$count" -ge 100 ]]; then
      warnings=$((warnings + 1))
      section "**Warning:** ${count}${qualifier} errors/faults in the last 24 hours."
    else
      section "${count} errors/faults in the last 24 hours."
    fi
    section ""
    section "<details>"
    section "<summary>Most recent entries (up to 20)</summary>"
    section ""
    section '```'
    section "$(printf '%s\n' "$log_lines" | tail -20)"
    section '```'
    section ""
    section "</details>"
  fi
  section ""
}

# ---------------------------------------------------------------------------
# Check: disk usage on local volumes, warn above threshold
# ---------------------------------------------------------------------------
check_disk_usage() {
  section "## Disk Usage"
  section ""
  section "| Filesystem | Size | Used | Avail | Capacity | Mounted On |"
  section "|------------|------|------|-------|----------|------------|"

  while read -r fs size used avail capacity _iused _ifree _piused mount; do
    local pct="${capacity%%%}"
    local warn=""
    if [[ "$pct" =~ ^[0-9]+$ ]] && [[ "$pct" -ge "$DISK_THRESHOLD" ]]; then
      warn=" **WARNING**"
      warnings=$((warnings + 1))
    fi
    section "| ${fs} | ${size} | ${used} | ${avail} | ${capacity}${warn} | ${mount} |"
  done < <(df -h 2>/dev/null | grep -E '^/dev/' || true)

  section ""
  section "Threshold: ${DISK_THRESHOLD}%"
  section ""
}

# ---------------------------------------------------------------------------
# Check: notable background processes (claude, node, python)
# ---------------------------------------------------------------------------
check_background_processes() {
  section "## Background Processes"
  section ""

  local user
  user=$(whoami)
  local procs
  procs=$(ps -u "$user" -o pid=,etime=,comm= 2>/dev/null \
    | awk '$3 ~ /claude|node|python|fullsend/' \
    | grep -v grep || true)

  if [[ -z "$procs" ]]; then
    section "No notable background processes running (checked: claude, node, python, fullsend)."
  else
    section "| PID | Elapsed | Command |"
    section "|-----|---------|---------|"
    while read -r pid etime comm; do
      section "| ${pid} | ${etime} | ${comm} |"
    done <<< "$procs"
  fi
  section ""
}

# ---------------------------------------------------------------------------
# Run all checks
# ---------------------------------------------------------------------------
check_launchd_agents
check_failed_jobs
check_recent_errors
check_disk_usage
check_background_processes

# ---------------------------------------------------------------------------
# Compose final report with header and status summary
# ---------------------------------------------------------------------------
status="healthy"
if [[ "$warnings" -gt 0 ]]; then
  status="${warnings} warning(s)"
fi

report="# Agent Lab Health Report

- **Date:** ${TODAY}
- **Host:** $(hostname)
- **User:** $(whoami)
- **Generated:** $(date '+%Y-%m-%d %H:%M:%S')
- **Status:** ${status}

${body}"

# Trim trailing whitespace per line, ensure single trailing newline
clean=$(printf '%s' "$report" | sed 's/[[:space:]]*$//')

if [[ "$DRY_RUN" == "true" ]]; then
  printf '%s\n' "$clean"
else
  mkdir -p "$REPORT_DIR"
  printf '%s\n' "$clean" > "$REPORT_FILE"
  echo "Report written to ${REPORT_FILE}"
fi
