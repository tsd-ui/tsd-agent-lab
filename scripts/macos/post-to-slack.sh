#!/usr/bin/env bash
#
# post-to-slack.sh
# Post a command center JSON summary to Slack via incoming webhook.
#
# Usage: ./scripts/macos/post-to-slack.sh [--dry-run] <json-file>
#
set -euo pipefail

DRY_RUN=false
JSON_FILE=""
WEBHOOK_CONFIG="${HOME}/.config/tsd-agent-lab/slack-webhook.env"

usage() {
  cat <<'USAGE'
Usage: post-to-slack.sh [OPTIONS] <json-file>

Post a command center JSON summary to Slack as a rich Block Kit message.

Arguments:
  json-file    Path to command-center-YYYY-MM-DD.json

Options:
  --dry-run    Print the Slack payload without posting
  --help       Show this help message

Configuration:
  Reads webhook URL from ~/.config/tsd-agent-lab/slack-webhook.env
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --help) usage; exit 0 ;;
    -*) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
    *)
      if [[ -z "$JSON_FILE" ]]; then
        JSON_FILE="$1"
      else
        echo "Error: unexpected argument '$1'" >&2; usage >&2; exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$JSON_FILE" ]]; then
  echo "Error: json-file argument required" >&2
  usage >&2
  exit 1
fi

if [[ ! -f "$JSON_FILE" ]]; then
  echo "Error: file not found: ${JSON_FILE}" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required but not found" >&2
  exit 1
fi

json_escape() {
  printf '%s' "$1" | jq -Rs . | sed 's/^"//;s/"$//'
}

# ---------------------------------------------------------------------------
# Load webhook URL (not needed for dry-run, but warn if missing)
# ---------------------------------------------------------------------------

SLACK_WEBHOOK_URL=""
if [[ -f "$WEBHOOK_CONFIG" ]]; then
  SLACK_WEBHOOK_URL=$(grep -E '^SLACK_WEBHOOK_URL=' "$WEBHOOK_CONFIG" | head -1 | cut -d= -f2- | xargs)
fi

if [[ -z "$SLACK_WEBHOOK_URL" ]] && [[ "$DRY_RUN" != "true" ]]; then
  echo "Error: SLACK_WEBHOOK_URL not configured in ${WEBHOOK_CONFIG}" >&2
  echo "Run with --dry-run to preview the payload, or configure the webhook first." >&2
  echo "See docs/admin/slack-integration.md for setup instructions." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Parse JSON
# ---------------------------------------------------------------------------

REPORT_REPO="tsd-ui/tsd-agent-lab"

date_val=$(jq -r '.date' "$JSON_FILE")
status=$(jq -r '.status' "$JSON_FILE")
ci_failures=$(jq -r '.ci.failures' "$JSON_FILE")
ci_repos=$(jq -r '.ci.repos_affected' "$JSON_FILE")
docs_findings=$(jq -r '.docs.findings' "$JSON_FILE")
docs_critical=$(jq -r '.docs.critical' "$JSON_FILE")
prs_open=$(jq -r '.prs.open' "$JSON_FILE")
triage_critical=$(jq -r '.pr_triage.critical // 0' "$JSON_FILE")
triage_high=$(jq -r '.pr_triage.high // 0' "$JSON_FILE")
triage_total=$(jq -r '.pr_triage.total_triaged // 0' "$JSON_FILE")

report_url="https://github.com/${REPORT_REPO}/blob/main/reports/command-center/current.md"

case "$status" in
  green) status_emoji=":large_green_circle:" ;;
  yellow) status_emoji=":large_yellow_circle:" ;;
  red) status_emoji=":red_circle:" ;;
  *) status_emoji=":white_circle:" ;;
esac

# Build alerts — only surface non-zero / non-ok items
alerts=""
if [[ "$ci_failures" -gt 0 ]]; then
  alerts+=":rotating_light: *${ci_failures} CI failure(s)* across ${ci_repos} repo(s)"$'\n'
  top_failures=$(jq -r '.ci.top_failures[]' "$JSON_FILE" 2>/dev/null || true)
  if [[ -n "$top_failures" ]]; then
    while IFS= read -r f; do
      alerts+="    • ${f}"$'\n'
    done <<< "$top_failures"
  fi
fi
if [[ "$triage_critical" -gt 0 || "$triage_high" -gt 0 ]]; then
  alerts+=":mag: *${triage_critical} critical, ${triage_high} high-risk PR(s)* out of ${triage_total} triaged"$'\n'
fi
if [[ "$docs_critical" -gt 0 ]]; then
  alerts+=":page_facing_up: *${docs_critical} stale doc link(s)*"$'\n'
fi
action_items=$(jq -r '.action_items[]' "$JSON_FILE" 2>/dev/null || true)
if [[ -n "$action_items" ]]; then
  while IFS= read -r item; do
    alerts+=":clipboard: ${item}"$'\n'
  done <<< "$action_items"
fi

# Summary line
summary="${prs_open} open PR(s)"
if [[ "$docs_findings" -gt 0 ]]; then
  summary+=", ${docs_findings} docs finding(s)"
fi

# ---------------------------------------------------------------------------
# Build Slack Block Kit payload
# ---------------------------------------------------------------------------

alerts=$(json_escape "$alerts")
summary=$(json_escape "$summary")

alerts_block=""
if [[ -n "$alerts" ]]; then
  alerts_block=$(cat <<ALERTBLOCK
    {
      "type": "section",
      "text": { "type": "mrkdwn", "text": "${alerts}" }
    },
    { "type": "divider" },
ALERTBLOCK
)
fi

payload=$(cat <<ENDPAYLOAD
{
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "$(json_escape "${status_emoji} Command Center — ${date_val}")",
        "emoji": true
      }
    },
    ${alerts_block}
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "${summary}  |  <${report_url}|View full report>"
      }
    },
    {
      "type": "context",
      "elements": [
        {
          "type": "mrkdwn",
          "text": "tsd-agent-lab command center"
        }
      ]
    }
  ]
}
ENDPAYLOAD
)

# ---------------------------------------------------------------------------
# Post or print
# ---------------------------------------------------------------------------

if [[ "$DRY_RUN" == "true" ]]; then
  echo "$payload" | jq .
else
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST \
    -H 'Content-type: application/json' \
    --data "$payload" \
    "$SLACK_WEBHOOK_URL")

  if [[ "$response" == "200" ]]; then
    echo "Successfully posted to Slack"
  else
    echo "Error: Slack webhook returned HTTP ${response}" >&2
    exit 1
  fi
fi
