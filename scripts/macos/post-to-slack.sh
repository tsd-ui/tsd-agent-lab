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

date_val=$(jq -r '.date' "$JSON_FILE")
status=$(jq -r '.status' "$JSON_FILE")
ci_failures=$(jq -r '.ci.failures' "$JSON_FILE")
ci_repos=$(jq -r '.ci.repos_affected' "$JSON_FILE")
docs_findings=$(jq -r '.docs.findings' "$JSON_FILE")
docs_critical=$(jq -r '.docs.critical' "$JSON_FILE")
health_status=$(jq -r '.health.status' "$JSON_FILE")
prs_reviewed=$(jq -r '.prs.reviewed' "$JSON_FILE")
prs_open=$(jq -r '.prs.open' "$JSON_FILE")

case "$status" in
  green) status_emoji=":large_green_circle:" ;;
  yellow) status_emoji=":large_yellow_circle:" ;;
  red) status_emoji=":red_circle:" ;;
  *) status_emoji=":white_circle:" ;;
esac

case "$health_status" in
  ok) health_emoji=":white_check_mark:" ;;
  *) health_emoji=":warning:" ;;
esac

# Build action items text
action_items=$(jq -r '.action_items[]' "$JSON_FILE" 2>/dev/null || true)
action_text=""
if [[ -n "$action_items" ]]; then
  while IFS= read -r item; do
    action_text+="• ${item}\n"
  done <<< "$action_items"
else
  action_text="No issues detected. System is healthy. :tada:"
fi

# Build next steps text
next_steps=$(jq -r '.next_steps[]' "$JSON_FILE" 2>/dev/null || true)
next_steps_text=""
if [[ -n "$next_steps" ]]; then
  while IFS= read -r step; do
    cmd="${step#*: }"
    label="${step%%: *}"
    escaped_cmd=$(printf '%s' "$cmd" | sed 's/\\/\\\\/g; s/"/\\"/g')
    escaped_label=$(printf '%s' "$label" | sed 's/\\/\\\\/g; s/"/\\"/g')
    next_steps_text+="*${escaped_label}:*\\n\`${escaped_cmd}\`\\n"
  done <<< "$next_steps"
else
  next_steps_text="No specific next steps."
fi

# Build top CI failures text
ci_text=""
if [[ "$ci_failures" -gt 0 ]]; then
  top_failures=$(jq -r '.ci.top_failures[]' "$JSON_FILE" 2>/dev/null || true)
  if [[ -n "$top_failures" ]]; then
    while IFS= read -r f; do
      ci_text+="• ${f}\n"
    done <<< "$top_failures"
  fi
fi

# Health warnings text
health_warnings=$(jq -r '.health.warnings[]' "$JSON_FILE" 2>/dev/null || true)
health_warn_text=""
if [[ -n "$health_warnings" ]]; then
  while IFS= read -r w; do
    health_warn_text+="• ${w}\n"
  done <<< "$health_warnings"
fi

# ---------------------------------------------------------------------------
# Build Slack Block Kit payload
# ---------------------------------------------------------------------------

# Escape for JSON string embedding
json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g' | tr '\n' ' '
}

payload=$(cat <<ENDPAYLOAD
{
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "${status_emoji} Daily Command Center — ${date_val}",
        "emoji": true
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*CI Failures*\n${ci_failures} across ${ci_repos} repo(s)"
        },
        {
          "type": "mrkdwn",
          "text": "*Stale Docs*\n${docs_findings} finding(s), ${docs_critical} stale link(s)"
        },
        {
          "type": "mrkdwn",
          "text": "*System Health*\n${health_emoji} ${health_status}"
        },
        {
          "type": "mrkdwn",
          "text": "*PR Activity*\n${prs_reviewed} reviewed, ${prs_open} open"
        }
      ]
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Action Items*\n${action_text}"
      }
    },
    { "type": "divider" },
    {
      "type": "section",
      "text": { "type": "mrkdwn", "text": "*Next Steps*\n${next_steps_text}" }
    }$(if [[ -n "$ci_text" ]]; then cat <<CIBLOCK
,
    {
      "type": "divider"
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Top CI Failures*\n${ci_text}"
      }
    }
CIBLOCK
fi)$(if [[ -n "$health_warn_text" ]]; then cat <<HWBLOCK
,
    {
      "type": "divider"
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Health Warnings*\n${health_warn_text}"
      }
    }
HWBLOCK
fi),
    {
      "type": "context",
      "elements": [
        {
          "type": "mrkdwn",
          "text": "Generated by tsd-agent-lab command center | $(date '+%Y-%m-%d %H:%M:%S')"
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
