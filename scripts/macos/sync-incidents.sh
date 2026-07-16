#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${REPO_ROOT}/bin/lib/incidents.sh"

DRY_RUN=false
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    DRY_RUN=true
  fi
done

if [[ "$DRY_RUN" == "true" ]]; then
  log_warn "DRY RUN MODE - no changes will be written"
fi

LATEST_DATA=$(ls -t "${REPO_ROOT}"/broken-builds-data-*.json 2>/dev/null | head -1)

if [[ -z "$LATEST_DATA" ]]; then
  log_error "No broken-builds data files found"
  exit 1
fi

log_info "Using data file: ${LATEST_DATA}"

CURRENT_SIGNATURES=$(jq -r '.repos[].failures[].signature' "$LATEST_DATA" | sort -u)

NEW_COUNT=0
UPDATED_COUNT=0
RESOLVED_COUNT=0

while IFS= read -r signature; do
  [[ -z "$signature" ]] && continue

  REPO=$(echo "$signature" | cut -d':' -f1)
  FAILURE_DATA=$(jq -c --arg sig "$signature" \
    '[.repos[].failures[] | select(.signature == $sig)] | .[0]' \
    "$LATEST_DATA")
  WORKFLOW=$(echo "$FAILURE_DATA" | jq -r '.workflow')
  RUN_ID=$(echo "$FAILURE_DATA" | jq -r '.run_id')

  EXISTING=$(jq --arg sig "$signature" '[.[] | select(.signature == $sig)] | .[0] // null' "$INDEX_FILE")

  if [[ "$EXISTING" == "null" ]]; then
    log_info "New incident: ${signature}"
    if [[ "$DRY_RUN" == "false" ]]; then
      incident_create "$signature" "$REPO" "$WORKFLOW" "$RUN_ID" >/dev/null
    fi
    NEW_COUNT=$((NEW_COUNT + 1))
  else
    INCIDENT_ID=$(echo "$EXISTING" | jq -r '.incident_id')
    STATUS=$(echo "$EXISTING" | jq -r '.status')

    if [[ "$STATUS" == "resolved" ]]; then
      log_info "Reopening incident: ${INCIDENT_ID}"
      if [[ "$DRY_RUN" == "false" ]]; then
        incident_update_status "$INCIDENT_ID" "open"
        NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        TMP=$(mktemp)
        jq --arg id "$INCIDENT_ID" \
           --argjson run_id "$RUN_ID" \
           --arg now "$NOW" \
           'map(if .incident_id == $id then
              .run_ids = ((.run_ids + [$run_id]) | unique) |
              .recurrence_count += 1 |
              .updated_at = $now
            else . end)' "$INDEX_FILE" > "$TMP"
        mv "$TMP" "$INDEX_FILE"
      fi
      UPDATED_COUNT=$((UPDATED_COUNT + 1))
    elif [[ "$STATUS" == "open" || "$STATUS" == "investigating" ]]; then
      log_info "Updating incident: ${INCIDENT_ID}"
      if [[ "$DRY_RUN" == "false" ]]; then
        NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        TMP=$(mktemp)
        jq --arg id "$INCIDENT_ID" \
           --argjson run_id "$RUN_ID" \
           --arg now "$NOW" \
           'map(if .incident_id == $id then
              .run_ids = ((.run_ids + [$run_id]) | unique) |
              .recurrence_count += 1 |
              .updated_at = $now
            else . end)' "$INDEX_FILE" > "$TMP"
        mv "$TMP" "$INDEX_FILE"
      fi
      UPDATED_COUNT=$((UPDATED_COUNT + 1))
    fi
  fi
done <<< "$CURRENT_SIGNATURES"

OPEN_INCIDENTS=$(jq -r '.[] | select(.status == "open" or .status == "investigating") | .incident_id + " " + .signature' "$INDEX_FILE")

while IFS= read -r line; do
  [[ -z "$line" ]] && continue

  INCIDENT_ID=$(echo "$line" | awk '{print $1}')
  SIGNATURE=$(echo "$line" | cut -d' ' -f2-)

  if ! echo "$CURRENT_SIGNATURES" | grep -qF "$SIGNATURE"; then
    log_info "Resolving incident: ${INCIDENT_ID}"
    if [[ "$DRY_RUN" == "false" ]]; then
      incident_update_status "$INCIDENT_ID" "resolved"
    fi
    RESOLVED_COUNT=$((RESOLVED_COUNT + 1))
  fi
done <<< "$OPEN_INCIDENTS"

log_success "Sync complete: ${NEW_COUNT} new, ${UPDATED_COUNT} updated, ${RESOLVED_COUNT} resolved"

