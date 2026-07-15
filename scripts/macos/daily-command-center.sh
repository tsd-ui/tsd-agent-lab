#!/usr/bin/env bash
#
# daily-command-center.sh
# Consolidates daily reports into a single command center digest.
#
# Usage: ./scripts/macos/daily-command-center.sh [--dry-run] [--post-slack] [--help]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPORT_DIR="${REPO_ROOT}/reports"
TODAY="$(date +%Y-%m-%d)"
YESTERDAY="$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d 'yesterday' +%Y-%m-%d 2>/dev/null || echo "")"
DRY_RUN=false
POST_SLACK=false

HEALTH_FILE="${REPORT_DIR}/health-${TODAY}.md"
STALE_DOCS_FILE="${REPORT_DIR}/stale-docs-${TODAY}.md"
BROKEN_BUILDS_FILE="${REPORT_DIR}/broken-builds-${TODAY}.md"
PR_STATE_FILE="${HOME}/workspaces/runs/.pr-review-state.json"

MD_OUT="${REPORT_DIR}/command-center-${TODAY}.md"
JSON_OUT="${REPORT_DIR}/command-center-${TODAY}.json"
YESTERDAY_JSON="${REPORT_DIR}/command-center-${YESTERDAY}.json"

# launchd jobs run with a minimal PATH
if [[ -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:${HOME}/.local/bin:${PATH}"
fi

usage() {
  cat <<'USAGE'
Usage: daily-command-center.sh [OPTIONS]

Consolidate daily health, stale-docs, broken-builds, and PR review
reports into a single command center digest.

Options:
  --dry-run      Print outputs to stdout without writing files
  --post-slack   Post digest to Slack after generating (requires webhook config)
  --help         Show this help message

Output:
  Default: writes to reports/command-center-YYYY-MM-DD.md
           and reports/command-center-YYYY-MM-DD.json
  Dry run: prints both to stdout
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --post-slack) POST_SLACK=true; shift ;;
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

file_available() {
  [[ -f "$1" ]] && [[ -s "$1" ]]
}

# Extract a count from text matching a pattern like "N failure(s)" or "N findings"
extract_count() {
  local text="$1" pattern="$2"
  echo "$text" | grep -oE "[0-9]+ ${pattern}" | head -1 | grep -oE '^[0-9]+' || echo "0"
}

# ---------------------------------------------------------------------------
# Section: CI / Builds
# ---------------------------------------------------------------------------

ci_failures=0
ci_repos_affected=0
ci_status_line="No broken-builds report found for today"
ci_top_failures="[]"
ci_section=""

if file_available "$BROKEN_BUILDS_FILE"; then
  ci_status_line=$(grep -m1 '| Status |' "$BROKEN_BUILDS_FILE" | awk -F'|' '{print $3}' | xargs)
  if [[ -z "$ci_status_line" ]]; then
    ci_status_line=$(grep -m1 -E '^[0-9]+ failure' "$BROKEN_BUILDS_FILE" || echo "unknown")
  fi
  ci_failures=$(extract_count "$ci_status_line" "failure")
  ci_repos_affected=$(extract_count "$ci_status_line" "repo")

  # Extract repo-level failure headings as top failures
  top_failures_raw=$(grep -E '^### ' "$BROKEN_BUILDS_FILE" | head -10 | sed 's/^### //' || true)
  ci_top_json="["
  first=true
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if [[ "$first" == "true" ]]; then
      first=false
    else
      ci_top_json+=","
    fi
    escaped=$(echo "$line" | sed 's/"/\\"/g')
    ci_top_json+="\"${escaped}\""
  done <<< "$top_failures_raw"
  ci_top_json+="]"
  ci_top_failures="$ci_top_json"

  ci_section="### CI / Builds

${ci_status_line}

"
  # Extract per-repo sections (### headings and their first #### failure)
  current_repo=""
  while IFS= read -r line; do
    if [[ "$line" =~ ^###\  ]]; then
      current_repo="${line#\#\#\# }"
      ci_section+="**${current_repo}**"$'\n'
    elif [[ "$line" =~ ^####\  ]]; then
      failure="${line#\#\#\#\# Failure: }"
      ci_section+="- ${failure}"$'\n'
    fi
  done < <(grep -E '^(###|####) ' "$BROKEN_BUILDS_FILE" || true)
else
  ci_section="### CI / Builds

No broken-builds report available for ${TODAY}.
"
fi

# ---------------------------------------------------------------------------
# Section: Documentation Health
# ---------------------------------------------------------------------------

docs_findings=0
docs_critical=0
docs_section=""

if file_available "$STALE_DOCS_FILE"; then
  summary_line=$(grep -m1 '^\*\*Summary:\*\*' "$STALE_DOCS_FILE" || true)
  if [[ -n "$summary_line" ]]; then
    docs_findings=$(extract_count "$summary_line" "stale")
    docs_review=$(extract_count "$summary_line" "for review")
    docs_findings=$((docs_findings + docs_review))
    docs_critical=$(extract_count "$summary_line" "stale")
  fi

  docs_section="### Documentation Health

${summary_line:-No summary line found}

"
  # List affected files
  affected_files=$(grep -E '^### `' "$STALE_DOCS_FILE" | sed 's/### `//;s/`$//' || true)
  if [[ -n "$affected_files" ]]; then
    docs_section+="Affected files:"$'\n'
    while IFS= read -r f; do
      [[ -z "$f" ]] && continue
      docs_section+="- \`${f}\`"$'\n'
    done <<< "$affected_files"
  fi
else
  docs_section="### Documentation Health

No stale-docs report available for ${TODAY}.
"
fi

# ---------------------------------------------------------------------------
# Section: System Health
# ---------------------------------------------------------------------------

health_status="unknown"
health_warnings=()
health_section=""

if file_available "$HEALTH_FILE"; then
  health_status_line=$(grep -m1 '^\- \*\*Status:\*\*' "$HEALTH_FILE" || true)
  if echo "$health_status_line" | grep -q "healthy"; then
    health_status="ok"
  else
    health_status="warnings"
    warn_text=$(echo "$health_status_line" | sed 's/.*\*\*Status:\*\* //')
    health_warnings+=("$warn_text")
  fi

  # Extract failed jobs
  failed_section=false
  while IFS= read -r line; do
    if [[ "$line" == "## Failed Jobs" ]]; then
      failed_section=true
      continue
    fi
    if [[ "$failed_section" == "true" ]] && [[ "$line" =~ ^## ]]; then
      break
    fi
    if [[ "$failed_section" == "true" ]] && [[ "$line" =~ ^\| ]] && ! [[ "$line" =~ ^\|\ Exit ]] && ! [[ "$line" =~ ^\|--  ]]; then
      health_warnings+=("Failed job: $(echo "$line" | awk -F'|' '{print $3}' | xargs)")
    fi
  done < "$HEALTH_FILE"

  # Extract disk capacity warnings
  while IFS= read -r line; do
    if echo "$line" | grep -q "WARNING"; then
      mount=$(echo "$line" | awk -F'|' '{print $7}' | xargs)
      cap=$(echo "$line" | awk -F'|' '{print $6}' | xargs | sed 's/ *\*\*WARNING\*\*//')
      health_warnings+=("Disk ${mount} at ${cap}")
    fi
  done < <(grep "WARNING" "$HEALTH_FILE" || true)

  health_section="### System Health

**Status:** ${health_status}
"
  if [[ ${#health_warnings[@]} -gt 0 ]]; then
    health_section+=$'\n'"Warnings:"$'\n'
    for w in "${health_warnings[@]}"; do
      health_section+="- ${w}"$'\n'
    done
  fi
else
  health_section="### System Health

No health report available for ${TODAY}.
"
fi

# ---------------------------------------------------------------------------
# Section: PR Activity
# ---------------------------------------------------------------------------

prs_reviewed=0
prs_open=0
pr_section=""

if file_available "$PR_STATE_FILE"; then
  if command -v jq >/dev/null 2>&1; then
    prs_reviewed=$(jq '[.reviewed | to_entries[]] | length' "$PR_STATE_FILE" 2>/dev/null || echo "0")

    # Try to get open PR count via gh if available
    if command -v gh >/dev/null 2>&1; then
      repos_json=$(jq -r '[.reviewed | keys[] | split("/")[0:2] | join("/")] | unique[]' "$PR_STATE_FILE" 2>/dev/null || true)
      if [[ -n "$repos_json" ]]; then
        while IFS= read -r repo; do
          [[ -z "$repo" ]] && continue
          count=$(gh pr list --repo "$repo" --state open --limit 100 --json number 2>/dev/null | jq 'length' 2>/dev/null || echo "0")
          prs_open=$((prs_open + count))
        done <<< "$repos_json"
      fi
    fi

    # Build recent reviews list
    recent_reviews=$(jq -r '
      .reviewed | to_entries
      | sort_by(.value.reviewed_at) | reverse
      | .[0:5]
      | .[] | "\(.key) (reviewed \(.value.reviewed_at | split("T")[0]))"
    ' "$PR_STATE_FILE" 2>/dev/null || true)
  else
    prs_reviewed=$(grep -c '"reviewed_at"' "$PR_STATE_FILE" 2>/dev/null || echo "0")
    recent_reviews=""
  fi

  pr_section="### PR Activity

- **${prs_reviewed}** PRs reviewed (lifetime)
- **${prs_open}** PRs currently open across monitored repos
"
  if [[ -n "${recent_reviews:-}" ]]; then
    pr_section+=$'\n'"Recent reviews:"$'\n'
    while IFS= read -r review; do
      [[ -z "$review" ]] && continue
      pr_section+="- ${review}"$'\n'
    done <<< "$recent_reviews"
  fi
else
  pr_section="### PR Activity

No PR review state file found.
"
fi

# ---------------------------------------------------------------------------
# Action Items
# ---------------------------------------------------------------------------

action_items=()

if [[ "$ci_failures" -gt 0 ]]; then
  action_items+=("Review ${ci_failures} CI failure(s) across ${ci_repos_affected} repo(s)")
fi

if [[ "$docs_critical" -gt 0 ]]; then
  action_items+=("Fix ${docs_critical} stale doc link(s)")
fi

if [[ ${#health_warnings[@]} -gt 0 ]]; then
  action_items+=("Address ${#health_warnings[@]} system health warning(s)")
fi

action_section="### Action Items
"
if [[ ${#action_items[@]} -eq 0 ]]; then
  action_section+=$'\n'"No action items. All clear."$'\n'
else
  action_section+=$'\n'
  for item in "${action_items[@]}"; do
    action_section+="- [ ] ${item}"$'\n'
  done
fi

# ---------------------------------------------------------------------------
# Overall status
# ---------------------------------------------------------------------------

overall_status="green"
status_emoji="🟢"

if [[ "$ci_failures" -gt 0 ]] || [[ ${#health_warnings[@]} -gt 0 ]] || [[ "$docs_critical" -gt 0 ]]; then
  overall_status="yellow"
  status_emoji="🟡"
fi

if [[ "$ci_failures" -ge 10 ]] || [[ "$health_status" == "warnings" && ${#health_warnings[@]} -ge 3 ]]; then
  overall_status="red"
  status_emoji="🔴"
fi

# ---------------------------------------------------------------------------
# Diff comparison with yesterday
# ---------------------------------------------------------------------------

diff_section=""
if [[ -n "$YESTERDAY" ]] && file_available "$YESTERDAY_JSON" && command -v jq >/dev/null 2>&1; then
  y_ci=$(jq -r '.ci.failures // 0' "$YESTERDAY_JSON" 2>/dev/null || echo "0")
  y_docs=$(jq -r '.docs.findings // 0' "$YESTERDAY_JSON" 2>/dev/null || echo "0")
  y_status=$(jq -r '.status // "unknown"' "$YESTERDAY_JSON" 2>/dev/null || echo "unknown")

  ci_delta=$((ci_failures - y_ci))
  docs_delta=$((docs_findings - y_docs))

  changes=()
  if [[ "$ci_delta" -gt 0 ]]; then
    changes+=("${ci_delta} new CI failure(s)")
  elif [[ "$ci_delta" -lt 0 ]]; then
    changes+=("$(( -ci_delta )) CI failure(s) resolved")
  fi
  if [[ "$docs_delta" -gt 0 ]]; then
    changes+=("${docs_delta} new stale doc finding(s)")
  elif [[ "$docs_delta" -lt 0 ]]; then
    changes+=("$(( -docs_delta )) stale doc finding(s) resolved")
  fi
  if [[ "$overall_status" != "$y_status" ]]; then
    changes+=("Status changed: ${y_status} -> ${overall_status}")
  fi

  if [[ ${#changes[@]} -gt 0 ]]; then
    diff_section="### Changes Since Yesterday
"
    for c in "${changes[@]}"; do
      diff_section+="- ${c}"$'\n'
    done
    diff_section+=$'\n'
  fi
fi

# ---------------------------------------------------------------------------
# Compose markdown report
# ---------------------------------------------------------------------------

report="# Daily Command Center — ${TODAY}

## Status: ${status_emoji}

### Summary

- ${ci_failures} CI failure(s) across ${ci_repos_affected} repo(s)
- ${docs_findings} stale docs finding(s)
- System health: ${health_status}
- ${prs_reviewed} PRs reviewed, ${prs_open} open across monitored repos

${diff_section}${ci_section}
${docs_section}
${health_section}
${pr_section}
${action_section}"

clean=$(printf '%s' "$report" | sed 's/[[:space:]]*$//')

# ---------------------------------------------------------------------------
# Compose JSON summary
# ---------------------------------------------------------------------------

# Build health warnings JSON array
hw_json="["
hw_first=true
for w in "${health_warnings[@]+"${health_warnings[@]}"}"; do
  [[ -z "$w" ]] && continue
  if [[ "$hw_first" == "true" ]]; then
    hw_first=false
  else
    hw_json+=","
  fi
  escaped=$(echo "$w" | sed 's/"/\\"/g')
  hw_json+="\"${escaped}\""
done
hw_json+="]"

# Build action items JSON array
ai_json="["
ai_first=true
for item in "${action_items[@]+"${action_items[@]}"}"; do
  [[ -z "$item" ]] && continue
  if [[ "$ai_first" == "true" ]]; then
    ai_first=false
  else
    ai_json+=","
  fi
  escaped=$(echo "$item" | sed 's/"/\\"/g')
  ai_json+="\"${escaped}\""
done
ai_json+="]"

json_summary=$(cat <<ENDJSON
{
  "date": "${TODAY}",
  "status": "${overall_status}",
  "ci": {
    "failures": ${ci_failures},
    "repos_affected": ${ci_repos_affected},
    "top_failures": ${ci_top_failures}
  },
  "docs": {
    "findings": ${docs_findings},
    "critical": ${docs_critical}
  },
  "health": {
    "status": "${health_status}",
    "warnings": ${hw_json}
  },
  "prs": {
    "reviewed": ${prs_reviewed},
    "open": ${prs_open}
  },
  "action_items": ${ai_json}
}
ENDJSON
)

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------

if [[ "$DRY_RUN" == "true" ]]; then
  echo "=== MARKDOWN REPORT ==="
  printf '%s\n' "$clean"
  echo ""
  echo "=== JSON SUMMARY ==="
  printf '%s\n' "$json_summary"
else
  mkdir -p "$REPORT_DIR"
  printf '%s\n' "$clean" > "$MD_OUT"
  printf '%s\n' "$json_summary" > "$JSON_OUT"
  echo "Markdown report written to ${MD_OUT}"
  echo "JSON summary written to ${JSON_OUT}"
fi

# ---------------------------------------------------------------------------
# Optional: post to Slack
# ---------------------------------------------------------------------------

if [[ "$POST_SLACK" == "true" ]]; then
  SLACK_SCRIPT="${SCRIPT_DIR}/post-to-slack.sh"
  if [[ -x "$SLACK_SCRIPT" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      echo ""
      echo "=== SLACK POST (dry-run) ==="
      "$SLACK_SCRIPT" --dry-run "$JSON_OUT"
    else
      "$SLACK_SCRIPT" "$JSON_OUT"
    fi
  else
    echo "Warning: post-to-slack.sh not found or not executable at ${SLACK_SCRIPT}" >&2
  fi
fi
