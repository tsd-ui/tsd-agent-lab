#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${REPO_ROOT}/harness/lib/common.sh"

require_command jq

INCIDENTS_DIR="${REPO_ROOT}/data/incidents"
INDEX_FILE="${INCIDENTS_DIR}/index.json"
COUNTER_FILE="${INCIDENTS_DIR}/counter"

incident_next_id() {
  local current
  current=$(cat "$COUNTER_FILE")
  local next=$((current + 1))
  echo "$next" > "$COUNTER_FILE"
  printf "INC-%04d" "$next"
}

incident_create() {
  local signature="$1"
  local repo="$2"
  local workflow="$3"
  local run_id="${4:-}"

  local incident_id
  incident_id=$(incident_next_id)

  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  local run_ids_json="[]"
  if [[ -n "$run_id" ]]; then
    run_ids_json="[$run_id]"
  fi

  local new_incident
  new_incident=$(jq -n \
    --arg id "$incident_id" \
    --arg sig "$signature" \
    --arg repo "$repo" \
    --arg workflow "$workflow" \
    --arg status "open" \
    --arg created "$now" \
    --arg updated "$now" \
    --argjson run_ids "$run_ids_json" \
    '{
      incident_id: $id,
      signature: $sig,
      repo: $repo,
      workflow: $workflow,
      status: $status,
      created_at: $created,
      updated_at: $updated,
      run_ids: $run_ids,
      actions: [{
        type: "created",
        timestamp: $created,
        details: "Incident created from build failure"
      }],
      diagnosis: null,
      recurrence_count: 0
    }')

  local tmp
  tmp=$(mktemp)
  jq --argjson incident "$new_incident" '. += [$incident]' "$INDEX_FILE" > "$tmp"
  mv "$tmp" "$INDEX_FILE"

  log_success "Created incident ${incident_id}" >&2
  echo "$incident_id"
}

incident_get() {
  local incident_id="$1"
  jq --arg id "$incident_id" '.[] | select(.incident_id == $id)' "$INDEX_FILE"
}

incident_list() {
  local status_filter=""
  if [[ "${1:-}" == "--status" ]]; then
    status_filter="$2"
  fi

  if [[ -z "$status_filter" ]]; then
    jq '.' "$INDEX_FILE"
  else
    jq --arg status "$status_filter" '[.[] | select(.status == $status)]' "$INDEX_FILE"
  fi
}

incident_update_status() {
  local incident_id="$1"
  local new_status="$2"

  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  local tmp
  tmp=$(mktemp)
  jq --arg id "$incident_id" \
     --arg status "$new_status" \
     --arg updated "$now" \
     --arg action_ts "$now" \
     --arg details "Status changed to ${new_status}" \
     'map(if .incident_id == $id then
        .status = $status |
        .updated_at = $updated |
        .actions += [{type: "status-change", timestamp: $action_ts, details: $details}]
      else . end)' "$INDEX_FILE" > "$tmp"
  mv "$tmp" "$INDEX_FILE"

  log_success "Updated incident ${incident_id} status to ${new_status}"
}

incident_append_action() {
  local incident_id="$1"
  local action_type="$2"
  local details="$3"

  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  local tmp
  tmp=$(mktemp)
  jq --arg id "$incident_id" \
     --arg type "$action_type" \
     --arg ts "$now" \
     --arg details "$details" \
     --arg updated "$now" \
     'map(if .incident_id == $id then
        .updated_at = $updated |
        .actions += [{type: $type, timestamp: $ts, details: $details}]
      else . end)' "$INDEX_FILE" > "$tmp"
  mv "$tmp" "$INDEX_FILE"

  log_success "Added action to incident ${incident_id}"
}

