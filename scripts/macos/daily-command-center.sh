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
DRY_RUN=false
POST_SLACK=false

STALE_DOCS_FILE="${REPORT_DIR}/stale-docs/current.md"
BROKEN_BUILDS_FILE="${REPORT_DIR}/broken-builds/current.md"
PR_TRIAGE_FILE="${REPORT_DIR}/pr-triage/current.md"
PR_STATE_FILE="${HOME}/workspaces/runs/.pr-review-state.json"

CC_DIR="${REPORT_DIR}/command-center"
MD_OUT="${CC_DIR}/current.md"
JSON_OUT="${CC_DIR}/current.json"
YESTERDAY_JSON="${CC_DIR}/previous.json"
ARCHIVE_MD="${CC_DIR}/archive/command-center-${TODAY}.md"
ARCHIVE_JSON="${CC_DIR}/archive/command-center-${TODAY}.json"

source "${SCRIPT_DIR}/lib-report-rotation.sh"

# launchd jobs run with a minimal PATH
if [[ -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:${HOME}/.local/bin:${PATH}"
fi

usage() {
  cat <<'USAGE'
Usage: daily-command-center.sh [OPTIONS]

Consolidate daily stale-docs, broken-builds, and PR review
reports into a single command center digest.

Options:
  --dry-run      Print outputs to stdout without writing files
  --post-slack   Post digest to Slack after generating (requires webhook config)
  --help         Show this help message

Output:
  Default: writes to reports/command-center/current.md
           and reports/command-center/current.json
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
  ci_status_line=$(grep -m1 '| Status |' "$BROKEN_BUILDS_FILE" | awk -F'|' '{print $3}' | xargs) || ci_status_line=""
  if [[ -z "$ci_status_line" ]]; then
    ci_status_line=$(grep -m1 -oE '[0-9]+ failure[^.]*' "$BROKEN_BUILDS_FILE" || echo "unknown")
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
# Section: PR Risk Triage
# ---------------------------------------------------------------------------

triage_total=0
triage_critical=0
triage_high=0
triage_medium=0
triage_low=0
triage_section=""
triage_attention_rows=""
triage_upstream_rows=""
triage_attention_count=0
triage_upstream_count=0

if file_available "$PR_TRIAGE_FILE"; then
  triage_summary=$(grep -m1 -E '^[0-9]+ open PR' "$PR_TRIAGE_FILE" || true)
  if [[ -n "$triage_summary" ]]; then
    triage_total=$(echo "$triage_summary" | grep -oE '^[0-9]+' || echo "0")
    triage_critical=$(echo "$triage_summary" | grep -oE '[0-9]+ critical' | grep -oE '^[0-9]+' || echo "0")
    triage_high=$(echo "$triage_summary" | grep -oE '[0-9]+ high' | grep -oE '^[0-9]+' || echo "0")
    triage_medium=$(echo "$triage_summary" | grep -oE '[0-9]+ medium' | grep -oE '^[0-9]+' || echo "0")
    triage_low=$(echo "$triage_summary" | grep -oE '[0-9]+ low' | grep -oE '^[0-9]+' || echo "0")
  fi

  # Extract "Needs Attention Now" (maintained repos) and "### Upstream Alerts"
  # (dependency repos) table rows separately, enriching each PR link with its
  # title pulled from the "#### [#N: Title](url)" headings further down in the
  # report. These two subsections must stay separate: dependency-repo PRs use
  # awareness actions (assess-impact/watch) and must never be folded into the
  # maintained-repo "needs deep-review" list, even when they score higher.
  triage_rows=$(awk '
    FNR == NR {
      if ($0 ~ /^#### \[#[0-9]+: /) {
        line = $0
        if (match(line, /\]\([^)]+\)$/)) {
          url = substr(line, RSTART + 2, RLENGTH - 3)
          title = line
          sub(/^#### \[#[0-9]+: /, "", title)
          sub(/\]\([^)]+\)$/, "", title)
          map[url] = title
        }
      }
      next
    }
    $0 == "## Needs Attention Now" { section = "attention"; next }
    $0 == "### Upstream Alerts" { section = "upstream"; next }
    section != "" && /^## / { section = "" }
    (section == "attention" || section == "upstream") && /^\|/ && $0 !~ /^\| #/ && $0 !~ /^\|---/ {
      line = $0
      if (match(line, /\[[^]]+\]\([^)]+\)/)) {
        full = substr(line, RSTART, RLENGTH)
        text = full
        sub(/^\[/, "", text)
        sub(/\]\(.*/, "", text)
        url = full
        sub(/^[^(]*\(/, "", url)
        sub(/\)$/, "", url)
        if (url in map) {
          newfull = "[" text ": " map[url] "](" url ")"
          sub(/\[[^]]+\]\([^)]+\)/, newfull, line)
        }
      }
      print section "\t" line
    }
  ' "$PR_TRIAGE_FILE" "$PR_TRIAGE_FILE")

  triage_attention_rows=$(printf '%s\n' "$triage_rows" | grep '^attention\t' | sed 's/^attention\t//' || true)
  triage_upstream_rows=$(printf '%s\n' "$triage_rows" | grep '^upstream\t' | sed 's/^upstream\t//' || true)
  triage_attention_count=$(printf '%s\n' "$triage_attention_rows" | grep -c '^|' || true)
  triage_upstream_count=$(printf '%s\n' "$triage_upstream_rows" | grep -c '^|' || true)
  if [[ -n "$triage_attention_rows" ]]; then
    triage_attention_rows+=$'\n'
  fi
  if [[ -n "$triage_upstream_rows" ]]; then
    triage_upstream_rows+=$'\n'
  fi

  triage_section="### PR Risk Triage

${triage_total} PR(s) triaged: ${triage_critical} critical, ${triage_high} high, ${triage_medium} medium, ${triage_low} low.
"
  if [[ -n "$triage_attention_rows" ]]; then
    triage_section+=$'\n'"**Needs Attention (maintained repos):**"$'\n'$'\n'
    triage_section+="| # | PR | Score | Priority | Key Risks | Action |"$'\n'
    triage_section+="|---|---|---|---|---|---|"$'\n'
    triage_section+="${triage_attention_rows}"
  fi
  if [[ -n "$triage_upstream_rows" ]]; then
    triage_section+=$'\n'"**Upstream Alerts (dependency repos — awareness only, no deep-review):**"$'\n'$'\n'
    triage_section+="| # | PR | Score | Priority | Key Risks | Action |"$'\n'
    triage_section+="|---|---|---|---|---|---|"$'\n'
    triage_section+="${triage_upstream_rows}"
  fi
else
  triage_section="### PR Risk Triage

No PR triage report available for ${TODAY}.
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

if [[ "$triage_attention_count" -gt 0 ]]; then
  action_items+=("Triage ${triage_attention_count} critical/high-risk PR(s) in maintained repos")
fi

if [[ "$triage_upstream_count" -gt 0 ]]; then
  action_items+=("Assess impact of ${triage_upstream_count} high-impact upstream dependency PR(s) — awareness only, no deep-review needed")
fi

action_section="### Action Items
"
if [[ ${#action_items[@]} -eq 0 ]]; then
  action_section+=$'\n'"No issues detected — see Next Steps for proactive actions."$'\n'
else
  action_section+=$'\n'
  for item in "${action_items[@]}"; do
    action_section+="- [ ] ${item}"$'\n'
  done
fi

# ---------------------------------------------------------------------------
# Next Steps — actionable commands based on current state
# ---------------------------------------------------------------------------

next_steps=()

if [[ "$ci_failures" -gt 0 ]]; then
  next_steps+=("View broken-builds report: cat reports/broken-builds/current.md")
  next_steps+=("Re-run CI diagnosis: ./scripts/macos/broken-builds-skill-run.sh --force-rediagnose")
fi

if [[ "$docs_findings" -gt 0 ]]; then
  next_steps+=("View stale-docs report: cat reports/stale-docs/current.md")
  next_steps+=("Run full docs review: claude -p \"Follow skills/stale-docs-check/SKILL.md\"")
fi

if [[ "$prs_open" -gt 0 ]]; then
  next_steps+=("Review open PRs: claude -p \"Follow skills/pr-review/SKILL.md\"")
fi

if [[ "$triage_total" -gt 0 ]]; then
  next_steps+=("View PR triage report: cat reports/pr-triage/current.md")
  next_steps+=("Re-run PR triage: ./scripts/macos/pr-risk-triage-skill-run.sh --dry-run")
fi

if [[ ${#next_steps[@]} -eq 0 ]]; then
  next_steps+=("Check for new PRs: gh pr list --repo securesign/rhtas-console-ui --state open")
  next_steps+=("Run a codebase map: claude -p \"Follow skills/codebase-map/SKILL.md\"")
  next_steps+=("Re-run this digest: ./scripts/macos/daily-command-center.sh --dry-run")
fi

next_steps_section="### Next Steps
"
for step in "${next_steps[@]}"; do
  cmd="${step#*: }"
  label="${step%%: *}"
  next_steps_section+=$'\n'"- **${label}:** \`${cmd}\`"
done

# ---------------------------------------------------------------------------
# Overall status
# ---------------------------------------------------------------------------

overall_status="green"
status_emoji="🟢"

if [[ "$ci_failures" -gt 0 ]] || [[ "$docs_critical" -gt 0 ]] || [[ "$triage_attention_count" -gt 0 ]]; then
  overall_status="yellow"
  status_emoji="🟡"
fi

if [[ "$ci_failures" -ge 10 ]] || [[ "$triage_attention_count" -ge 3 ]]; then
  overall_status="red"
  status_emoji="🔴"
fi

# ---------------------------------------------------------------------------
# Diff comparison with yesterday
# ---------------------------------------------------------------------------

diff_section=""
if file_available "$YESTERDAY_JSON" && command -v jq >/dev/null 2>&1; then
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
- ${prs_reviewed} PRs reviewed, ${prs_open} open across monitored repos
- ${triage_total} PR(s) triaged: ${triage_critical} critical, ${triage_high} high

${diff_section}${ci_section}
${docs_section}
${pr_section}
${triage_section}
${action_section}
${next_steps_section}"

clean=$(printf '%s' "$report" | sed 's/[[:space:]]*$//')

# ---------------------------------------------------------------------------
# Compose JSON summary
# ---------------------------------------------------------------------------

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

# Build next steps JSON array
ns_json="["
ns_first=true
for step in "${next_steps[@]+"${next_steps[@]}"}"; do
  [[ -z "$step" ]] && continue
  if [[ "$ns_first" == "true" ]]; then
    ns_first=false
  else
    ns_json+=","
  fi
  escaped=$(echo "$step" | sed 's/"/\\"/g')
  ns_json+="\"${escaped}\""
done
ns_json+="]"

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
  "prs": {
    "reviewed": ${prs_reviewed},
    "open": ${prs_open}
  },
  "pr_triage": {
    "total_triaged": ${triage_total},
    "critical": ${triage_critical},
    "high": ${triage_high},
    "medium": ${triage_medium},
    "low": ${triage_low},
    "maintained_needs_attention": ${triage_attention_count},
    "upstream_alerts": ${triage_upstream_count}
  },
  "action_items": ${ai_json},
  "next_steps": ${ns_json}
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
  rotate_report "$CC_DIR" "command-center" "$TODAY" "md"
  rotate_report "$CC_DIR" "command-center" "$TODAY" "json"
  printf '%s\n' "$clean" > "$MD_OUT"
  printf '%s\n' "$json_summary" > "$JSON_OUT"
  cp "$MD_OUT" "$ARCHIVE_MD"
  cp "$JSON_OUT" "$ARCHIVE_JSON"
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
