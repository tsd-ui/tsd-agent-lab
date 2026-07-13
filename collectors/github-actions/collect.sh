#!/bin/bash
set -euo pipefail

# ── Resource limit constants ────────────────────────────────────────────────
MAX_FAILED_RUNS_PER_REPO=5
MAX_JOBS_PER_RUN=10
MAX_LOG_BYTES=8192
MAX_BUNDLE_SIZE_BYTES=2097152  # 2 MB
# shellcheck disable=SC2034  # consumed by the skill runner, not this script
MAX_AGENT_INVOCATIONS=10
TIMEOUT_PER_REPO=60

# ── Path resolution ────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# ── CLI flags ───────────────────────────────────────────────────────────────
DRY_RUN=false

usage() {
    cat <<'USAGE'
Usage: collect.sh [OPTIONS]

GitHub Actions CI failure collector. Queries recent failed workflow runs on the
default branch for allowlisted repos and produces a structured JSON bundle.

Options:
  --dry-run             Print JSON to stdout instead of writing to file
  --force-rediagnose    Accepted for forwarding to the skill layer (no-op here)
  --help                Show this help message

Prerequisites:
  - gh CLI authenticated
  - jq available
  - policies/generated/repo-inventory.txt must exist
    (run generate-repo-inventory.sh first)
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)      DRY_RUN=true; shift ;;
        --force-rediagnose) shift ;;  # accepted for forwarding; no-op in collector
        --help)         usage; exit 0 ;;
        *)              echo >&2 "Unknown option: $1"; usage >&2; exit 1 ;;
    esac
done

# ── Preflight checks ───────────────────────────────────────────────────────
REPO_INVENTORY="$REPO_ROOT/policies/generated/repo-inventory.txt"
if [[ ! -f "$REPO_INVENTORY" ]]; then
    echo >&2 "ERROR: $REPO_INVENTORY not found."
    echo >&2 "Run generate-repo-inventory.sh first to create the repo inventory."
    exit 1
fi

for cmd in gh jq; do
    if ! command -v "$cmd" &>/dev/null; then
        echo >&2 "ERROR: Required command '$cmd' not found."
        exit 1
    fi
done

# Determine timeout command (GNU coreutils on macOS ships as gtimeout)
TIMEOUT_CMD=""
if command -v timeout &>/dev/null; then
    TIMEOUT_CMD="timeout"
elif command -v gtimeout &>/dev/null; then
    TIMEOUT_CMD="gtimeout"
else
    echo >&2 "WARNING: Neither 'timeout' nor 'gtimeout' found. Per-repo timeout enforcement disabled."
fi

# ── Helper functions ────────────────────────────────────────────────────────

log() {
    echo >&2 "[collect.sh] $*"
}

# Normalize an error line for dedup signatures.
#   - Strip ISO-8601-style timestamps (e.g. 2024-01-15T10:30:00.000Z)
#   - Strip PID-like numbers (standalone numeric tokens)
#   - Strip hex addresses (0x...)
#   - Collapse whitespace
normalize_error_line() {
    local line="$1"
    echo "$line" \
        | sed -E 's/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?Z?//g' \
        | sed -E 's/\b[0-9]+\b//g' \
        | sed -E 's/0x[0-9a-fA-F]+//g' \
        | sed -E 's/[[:space:]]+/ /g' \
        | sed -E 's/^ //;s/ $//'
}

# Look for prior occurrences of a signature in recent broken-builds reports.
# Populates global variables: RECURRENCE_COUNT, RECURRENCE_FIRST_SEEN
check_recurrence() {
    local signature="$1"
    RECURRENCE_COUNT=0
    RECURRENCE_FIRST_SEEN=""

    local reports_dir="$REPO_ROOT/docs/admin/reports"
    if [[ ! -d "$reports_dir" ]]; then
        return
    fi

    local cutoff_epoch
    cutoff_epoch=$(date -v-7d +%s 2>/dev/null || date -d "7 days ago" +%s 2>/dev/null || echo "0")

    local earliest_seen=""
    local count=0

    while IFS= read -r report_file; do
        # Extract date from filename pattern broken-builds-YYYY-MM-DD
        local basename
        basename="$(basename "$report_file")"
        local date_part
        date_part="$(echo "$basename" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)" || true
        if [[ -z "$date_part" ]]; then
            continue
        fi

        local file_epoch
        file_epoch=$(date -jf "%Y-%m-%d" "$date_part" +%s 2>/dev/null || date -d "$date_part" +%s 2>/dev/null || echo "0")
        if [[ "$file_epoch" -lt "$cutoff_epoch" ]]; then
            continue
        fi

        if grep -qF "$signature" "$report_file" 2>/dev/null; then
            count=$((count + 1))
            if [[ -z "$earliest_seen" || "$date_part" < "$earliest_seen" ]]; then
                earliest_seen="$date_part"
            fi
        fi
    done < <(find "$reports_dir" -name "broken-builds*" -type f 2>/dev/null)

    RECURRENCE_COUNT=$count
    if [[ -n "$earliest_seen" ]]; then
        RECURRENCE_FIRST_SEEN="${earliest_seen}T00:00:00Z"
    fi
}

# Collect failures for a single repo. Outputs a JSON object for the repo.
collect_repo() {
    local repo="$1"
    log "Processing $repo ..."

    # Get default branch
    local default_branch
    default_branch=$(gh api "repos/${repo}" --jq '.default_branch' 2>/dev/null) || {
        echo "{}" | jq --arg repo "$repo" --arg err "Failed to query repo API" \
            '{repo: $repo, default_branch: "unknown", collection_status: "error", collection_error: $err, failures: []}'
        return
    }

    # List recent failed runs
    local runs_json
    runs_json=$(gh run list --repo "$repo" --branch "$default_branch" \
        --status failure --limit "$MAX_FAILED_RUNS_PER_REPO" \
        --json databaseId,url,workflowName,headSha,startedAt,name 2>/dev/null) || {
        echo "{}" | jq --arg repo "$repo" --arg branch "$default_branch" --arg err "Failed to list workflow runs" \
            '{repo: $repo, default_branch: $branch, collection_status: "error", collection_error: $err, failures: []}'
        return
    }

    local run_count
    run_count=$(echo "$runs_json" | jq 'length')
    if [[ "$run_count" -eq 0 ]]; then
        echo "{}" | jq --arg repo "$repo" --arg branch "$default_branch" \
            '{repo: $repo, default_branch: $branch, collection_status: "ok", failures: []}'
        return
    fi

    # Process each failed run
    local failures_json="[]"
    local run_index=0
    while [[ $run_index -lt $run_count && $run_index -lt $MAX_FAILED_RUNS_PER_REPO ]]; do
        local run_id run_url workflow head_sha started_at
        run_id=$(echo "$runs_json" | jq -r ".[$run_index].databaseId")
        run_url=$(echo "$runs_json" | jq -r ".[$run_index].url")
        workflow=$(echo "$runs_json" | jq -r ".[$run_index].workflowName")
        head_sha=$(echo "$runs_json" | jq -r ".[$run_index].headSha")
        started_at=$(echo "$runs_json" | jq -r ".[$run_index].startedAt")

        log "  Run $run_id ($workflow) ..."

        # Get failed logs via gh run view --log-failed (best effort, per run)
        local run_failed_log=""
        run_failed_log=$(gh run view "$run_id" --repo "$repo" --log-failed 2>/dev/null) || true

        # Get failed jobs for this run
        local jobs_json
        jobs_json=$(gh api "repos/${repo}/actions/runs/${run_id}/jobs" \
            --jq '[.jobs[] | select(.conclusion == "failure")]' 2>/dev/null) || {
            log "    WARNING: Failed to get jobs for run $run_id"
            run_index=$((run_index + 1))
            continue
        }

        local job_count
        job_count=$(echo "$jobs_json" | jq 'length')

        local failed_jobs_json="[]"
        local first_signature=""
        local job_index=0
        while [[ $job_index -lt $job_count && $job_index -lt $MAX_JOBS_PER_RUN ]]; do
            local job_name job_id
            job_name=$(echo "$jobs_json" | jq -r ".[$job_index].name")
            job_id=$(echo "$jobs_json" | jq -r ".[$job_index].id")

            log "    Job: $job_name (id=$job_id)"

            # Extract failed steps
            local steps_json
            steps_json=$(echo "$jobs_json" | jq -c "[.[$job_index].steps[] | select(.conclusion == \"failure\")]")

            local step_count
            step_count=$(echo "$steps_json" | jq 'length')

            local failed_steps_json="[]"
            local step_index=0
            while [[ $step_index -lt $step_count ]]; do
                local step_name
                step_name=$(echo "$steps_json" | jq -r ".[$step_index].name")

                log "      Step: $step_name"

                # Get log excerpt for this step
                local log_excerpt=""
                local log_truncated=false

                # Strategy 1: extract from --log-failed output (grep for job/step headers)
                if [[ -n "$run_failed_log" ]]; then
                    # gh run view --log-failed output has lines like: "job_name<TAB>step_name<TAB>log line"
                    log_excerpt=$(echo "$run_failed_log" \
                        | grep -F "$job_name" \
                        | grep -F "$step_name" \
                        | head -200 \
                        | cut -f3- \
                        2>/dev/null) || true
                fi

                # Strategy 2: fall back to gh api for individual job logs
                if [[ -z "$log_excerpt" ]]; then
                    log_excerpt=$(gh api "repos/${repo}/actions/jobs/${job_id}/logs" 2>/dev/null) || true
                fi

                # Truncate to MAX_LOG_BYTES
                if [[ ${#log_excerpt} -gt $MAX_LOG_BYTES ]]; then
                    log_excerpt="${log_excerpt: -$MAX_LOG_BYTES}"
                    log_truncated=true
                fi

                # Build signature
                local last_error_line
                last_error_line=$(echo "$log_excerpt" | grep -v '^[[:space:]]*$' | tail -1) || true
                local normalized
                normalized=$(normalize_error_line "$last_error_line")
                local signature="${repo}::${workflow}::${job_name}::${step_name}::${normalized}"

                if [[ -z "$first_signature" ]]; then
                    first_signature="$signature"
                fi

                failed_steps_json=$(echo "$failed_steps_json" | jq \
                    --arg step_name "$step_name" \
                    --arg log_excerpt "$log_excerpt" \
                    --argjson log_truncated "$log_truncated" \
                    '. + [{step_name: $step_name, log_excerpt: $log_excerpt, log_truncated: $log_truncated}]')

                step_index=$((step_index + 1))
            done

            failed_jobs_json=$(echo "$failed_jobs_json" | jq \
                --arg job_name "$job_name" \
                --argjson failed_steps "$failed_steps_json" \
                '. + [{job_name: $job_name, failed_steps: $failed_steps}]')

            job_index=$((job_index + 1))
        done

        # Use the first signature for recurrence check
        if [[ -z "$first_signature" ]]; then
            first_signature="${repo}::${workflow}::::unknown"
        fi

        check_recurrence "$first_signature"

        local recurrence_json
        if [[ $RECURRENCE_COUNT -gt 0 && -n "$RECURRENCE_FIRST_SEEN" ]]; then
            recurrence_json=$(jq -n \
                --argjson count "$RECURRENCE_COUNT" \
                --arg first_seen "$RECURRENCE_FIRST_SEEN" \
                '{count: $count, first_seen: $first_seen}')
        else
            recurrence_json='{"count": 0, "first_seen": null}'
        fi

        failures_json=$(echo "$failures_json" | jq \
            --argjson run_id "$run_id" \
            --arg run_url "$run_url" \
            --arg workflow "$workflow" \
            --arg head_sha "$head_sha" \
            --arg started_at "$started_at" \
            --arg signature "$first_signature" \
            --argjson recurrence "$recurrence_json" \
            --argjson failed_jobs "$failed_jobs_json" \
            '. + [{
                run_id: $run_id,
                run_url: $run_url,
                workflow: $workflow,
                head_sha: $head_sha,
                started_at: $started_at,
                signature: $signature,
                recurrence: $recurrence,
                failed_jobs: $failed_jobs
            }]')

        run_index=$((run_index + 1))
    done

    echo "{}" | jq \
        --arg repo "$repo" \
        --arg branch "$default_branch" \
        --argjson failures "$failures_json" \
        '{repo: $repo, default_branch: $branch, collection_status: "ok", failures: $failures}'
}

# ── Main ────────────────────────────────────────────────────────────────────

generated_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
repos_array="[]"

while IFS= read -r repo; do
    # Skip blank lines and comments
    [[ -z "$repo" || "$repo" == \#* ]] && continue
    repo=$(echo "$repo" | xargs)  # trim whitespace
    [[ -z "$repo" ]] && continue

    log "── Collecting: $repo ──"

    repo_json=""
    if [[ -n "$TIMEOUT_CMD" ]]; then
        repo_json=$($TIMEOUT_CMD "$TIMEOUT_PER_REPO" bash -c "$(declare -f collect_repo normalize_error_line check_recurrence log); \
            REPO_ROOT='$REPO_ROOT' \
            MAX_FAILED_RUNS_PER_REPO=$MAX_FAILED_RUNS_PER_REPO \
            MAX_JOBS_PER_RUN=$MAX_JOBS_PER_RUN \
            MAX_LOG_BYTES=$MAX_LOG_BYTES \
            RECURRENCE_COUNT=0 \
            RECURRENCE_FIRST_SEEN='' \
            collect_repo '$repo'") || {
            exit_code=$?
            if [[ $exit_code -eq 124 ]]; then
                log "  TIMEOUT after ${TIMEOUT_PER_REPO}s for $repo"
                repo_json=$(echo "{}" | jq \
                    --arg repo "$repo" \
                    --arg err "Collection timed out after ${TIMEOUT_PER_REPO}s" \
                    '{repo: $repo, default_branch: "unknown", collection_status: "timeout", collection_error: $err, failures: []}')
            else
                log "  ERROR collecting $repo (exit code $exit_code)"
                repo_json=$(echo "{}" | jq \
                    --arg repo "$repo" \
                    --arg err "Collection failed with exit code $exit_code" \
                    '{repo: $repo, default_branch: "unknown", collection_status: "error", collection_error: $err, failures: []}')
            fi
        }
    else
        repo_json=$(collect_repo "$repo") || {
            log "  ERROR collecting $repo"
            repo_json=$(echo "{}" | jq \
                --arg repo "$repo" \
                --arg err "Collection failed" \
                '{repo: $repo, default_branch: "unknown", collection_status: "error", collection_error: $err, failures: []}')
        }
    fi

    repos_array=$(echo "$repos_array" | jq --argjson repo_data "$repo_json" '. + [$repo_data]')

done < "$REPO_INVENTORY"

# Assemble final bundle
bundle=$(jq -n \
    --arg generated_at "$generated_at" \
    --argjson repos "$repos_array" \
    '{
        schema_version: "1",
        generated_at: $generated_at,
        collector: "github-actions",
        repos: $repos
    }')

# Check bundle size and truncate logs if needed
bundle_size=${#bundle}
if [[ $bundle_size -gt $MAX_BUNDLE_SIZE_BYTES ]]; then
    log "WARNING: Bundle size ($bundle_size bytes) exceeds limit ($MAX_BUNDLE_SIZE_BYTES bytes). Truncating log excerpts."

    # Calculate the ratio we need to shrink by
    ratio=$(echo "scale=2; $MAX_BUNDLE_SIZE_BYTES / $bundle_size" | bc 2>/dev/null || echo "0.50")

    # Truncate all log_excerpt fields proportionally
    max_excerpt_bytes=$(echo "$MAX_LOG_BYTES * $ratio" | bc 2>/dev/null | cut -d. -f1 || echo "4096")
    [[ $max_excerpt_bytes -lt 512 ]] && max_excerpt_bytes=512

    bundle=$(echo "$bundle" | jq --argjson max_bytes "$max_excerpt_bytes" '
        .warning = "Log excerpts truncated to fit within bundle size limit" |
        .repos |= [.[] |
            .failures |= [.[] |
                .failed_jobs |= [.[] |
                    .failed_steps |= [.[] |
                        if (.log_excerpt | length) > $max_bytes then
                            .log_excerpt = (.log_excerpt | .[-$max_bytes:]) |
                            .log_truncated = true
                        else
                            .
                        end
                    ]
                ]
            ]
        ]
    ')

    log "Log excerpts truncated to ~${max_excerpt_bytes} bytes each."
fi

# Output
if [[ "$DRY_RUN" == "true" ]]; then
    echo "$bundle"
else
    today=$(date -u +"%Y-%m-%d")
    output_file="$REPO_ROOT/broken-builds-data-${today}.json"
    echo "$bundle" > "$output_file"
    log "Bundle written to $output_file"
    log "Size: $(wc -c < "$output_file" | xargs) bytes"
fi
