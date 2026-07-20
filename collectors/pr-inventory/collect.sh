#!/bin/bash
set -euo pipefail

# ── Resource limit constants ────────────────────────────────────────────────
MAX_PRS_PER_REPO=20
DIFF_THRESHOLD_LINES=2000
MAX_DIFF_BYTES=65536       # 64 KB per PR diff
MAX_BUNDLE_SIZE_BYTES=4194304  # 4 MB total
TIMEOUT_PER_REPO=90

# ── Path resolution ────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# ── CLI flags ───────────────────────────────────────────────────────────────
DRY_RUN=false
INCLUDE_DRAFTS=false

usage() {
    cat <<'USAGE'
Usage: collect.sh [OPTIONS]

PR inventory collector. Queries open PRs for allowlisted repos via gh CLI
and produces a structured JSON bundle for risk triage.

Options:
  --dry-run             Print JSON to stdout instead of writing to file
  --include-drafts      Include draft PRs (excluded by default)
  --max-prs N           Override MAX_PRS_PER_REPO (default: 20)
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
        --dry-run)       DRY_RUN=true; shift ;;
        --include-drafts) INCLUDE_DRAFTS=true; shift ;;
        --max-prs)
            if [[ -z "${2:-}" || "$2" == --* ]]; then
                echo >&2 "ERROR: --max-prs requires a numeric argument"; exit 1
            fi
            MAX_PRS_PER_REPO="$2"; shift 2 ;;
        --help)          usage; exit 0 ;;
        *)               echo >&2 "Unknown option: $1"; usage >&2; exit 1 ;;
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
    echo >&2 "[pr-inventory] $*"
}

days_between() {
    local then_epoch now_epoch
    now_epoch=$(date +%s)
    then_epoch=$(date -jf "%Y-%m-%dT%H:%M:%SZ" "$1" +%s 2>/dev/null || \
                 date -d "$1" +%s 2>/dev/null || echo "$now_epoch")
    echo $(( (now_epoch - then_epoch) / 86400 ))
}

aggregate_check_status() {
    local rollup="$1"
    local len
    len=$(echo "$rollup" | jq 'length')
    if [[ "$len" -eq 0 ]]; then
        echo "unknown"
        return
    fi
    if echo "$rollup" | jq -e '[.[] | select(.conclusion == "failure" or .status == "FAILURE")] | length > 0' >/dev/null 2>&1; then
        echo "failure"
        return
    fi
    if echo "$rollup" | jq -e '[.[] | select(.status == "PENDING" or .status == "QUEUED" or .conclusion == null or .conclusion == "")] | length > 0' >/dev/null 2>&1; then
        echo "pending"
        return
    fi
    echo "success"
}

# ── Collect PRs for a single repo ──────────────────────────────────────────
collect_repo() {
    local repo="$1"
    local relationship="${2:-maintained}"
    log "Processing $repo ..."

    local gh_fields="number,title,url,author,createdAt,updatedAt,isDraft,labels,baseRefName,headRefName,additions,deletions,changedFiles,statusCheckRollup,reviewDecision,reviews,commits,files"

    local prs_json
    prs_json=$(gh pr list --repo "$repo" --state open --limit "$MAX_PRS_PER_REPO" \
        --json "$gh_fields" 2>/dev/null) || {
        echo "{}" | jq --arg repo "$repo" --arg rel "$relationship" --arg err "Failed to list PRs" \
            '{repo: $repo, relationship: $rel, collection_status: "error", collection_error: $err, prs: []}'
        return
    }

    local pr_count
    pr_count=$(echo "$prs_json" | jq 'length')

    if [[ "$pr_count" -eq 0 ]]; then
        echo "{}" | jq --arg repo "$repo" --arg rel "$relationship" \
            '{repo: $repo, relationship: $rel, collection_status: "ok", prs: []}'
        return
    fi

    local prs_result="[]"
    local pr_index=0
    while [[ $pr_index -lt $pr_count ]]; do
        local pr_data
        pr_data=$(echo "$prs_json" | jq ".[$pr_index]")

        local is_draft
        is_draft=$(echo "$pr_data" | jq -r '.isDraft')
        if [[ "$INCLUDE_DRAFTS" != "true" && "$is_draft" == "true" ]]; then
            pr_index=$((pr_index + 1))
            continue
        fi

        local number title url author created_at updated_at base_branch head_branch
        local additions deletions changed_files_count
        number=$(echo "$pr_data" | jq -r '.number')
        title=$(echo "$pr_data" | jq -r '.title')
        url=$(echo "$pr_data" | jq -r '.url')
        author=$(echo "$pr_data" | jq -r '.author.login')
        created_at=$(echo "$pr_data" | jq -r '.createdAt')
        updated_at=$(echo "$pr_data" | jq -r '.updatedAt')
        base_branch=$(echo "$pr_data" | jq -r '.baseRefName')
        head_branch=$(echo "$pr_data" | jq -r '.headRefName')
        additions=$(echo "$pr_data" | jq -r '.additions // 0')
        deletions=$(echo "$pr_data" | jq -r '.deletions // 0')
        changed_files_count=$(echo "$pr_data" | jq -r '.changedFiles // 0')

        log "  PR #${number}: ${title}"

        # Labels
        local labels_json
        labels_json=$(echo "$pr_data" | jq '[.labels[]?.name // empty]')

        # Changed file paths
        local files_json
        files_json=$(echo "$pr_data" | jq '[.files[]?.path // empty]')
        if [[ "$(echo "$files_json" | jq 'length')" -eq 0 ]]; then
            files_json=$(gh pr view "$number" --repo "$repo" --json files --jq '[.files[].path]' 2>/dev/null || echo "[]")
        fi

        # Diff excerpt (conditional on size)
        local total_lines=$((additions + deletions))
        local diff_excerpt="null"
        if [[ "$total_lines" -le "$DIFF_THRESHOLD_LINES" ]]; then
            local raw_diff
            raw_diff=$(gh pr diff "$number" --repo "$repo" 2>/dev/null || true)
            if [[ -n "$raw_diff" ]]; then
                if [[ ${#raw_diff} -gt $MAX_DIFF_BYTES ]]; then
                    raw_diff="${raw_diff:0:$MAX_DIFF_BYTES}"
                fi
                diff_excerpt=$(echo "$raw_diff" | jq -Rs .)
            fi
        fi

        # Check/CI status
        local rollup
        rollup=$(echo "$pr_data" | jq '[.statusCheckRollup // [] | .[] | {name: .name, status: .status, conclusion: .conclusion}]')
        local agg_status
        agg_status=$(aggregate_check_status "$rollup")

        # Review state
        local review_decision
        review_decision=$(echo "$pr_data" | jq -r '.reviewDecision // empty')
        [[ -z "$review_decision" || "$review_decision" == "null" ]] && review_decision="null"
        local reviews_json
        reviews_json=$(echo "$pr_data" | jq '[.reviews // [] | .[] | {author: .author.login, state: .state, submitted_at: .submittedAt}]')

        # Review threads (comment count via API)
        local threads_total=0 threads_unresolved=0
        local comments_json
        comments_json=$(gh api "repos/${repo}/pulls/${number}/comments" --paginate 2>/dev/null || echo "[]")
        threads_total=$(echo "$comments_json" | jq 'length')
        threads_unresolved=$(echo "$comments_json" | jq '[.[] | select(.in_reply_to_id == null)] | length' 2>/dev/null || echo "0")

        # Force-push events (best-effort)
        local force_push_count=0
        local timeline_json
        timeline_json=$(gh api "repos/${repo}/issues/${number}/timeline" --paginate 2>/dev/null || echo "[]")
        if [[ "$timeline_json" != "[]" ]]; then
            force_push_count=$(echo "$timeline_json" | jq '[.[] | select(.event == "head_ref_force_pushed")] | length' 2>/dev/null || echo "0")
        fi

        # Commit count
        local commit_count
        commit_count=$(echo "$pr_data" | jq '.commits | length // 0')

        # Staleness
        local days_open days_since_update
        days_open=$(days_between "$created_at")
        days_since_update=$(days_between "$updated_at")

        # Assemble PR object
        local pr_obj
        pr_obj=$(jq -n \
            --argjson number "$number" \
            --arg title "$title" \
            --arg url "$url" \
            --arg author "$author" \
            --arg created_at "$created_at" \
            --arg updated_at "$updated_at" \
            --argjson is_draft "$is_draft" \
            --argjson labels "$labels_json" \
            --arg base_branch "$base_branch" \
            --arg head_branch "$head_branch" \
            --argjson additions "$additions" \
            --argjson deletions "$deletions" \
            --argjson changed_files_count "$changed_files_count" \
            --argjson changed_files "$files_json" \
            --arg agg_status "$agg_status" \
            --argjson check_details "$rollup" \
            --arg review_decision "$review_decision" \
            --argjson reviews "$reviews_json" \
            --argjson threads_total "$threads_total" \
            --argjson threads_unresolved "$threads_unresolved" \
            --argjson commit_count "$commit_count" \
            --argjson force_push_count "$force_push_count" \
            --argjson days_open "$days_open" \
            --argjson days_since_update "$days_since_update" \
            '{
                number: $number,
                title: $title,
                url: $url,
                author: $author,
                created_at: $created_at,
                updated_at: $updated_at,
                is_draft: $is_draft,
                labels: $labels,
                base_branch: $base_branch,
                head_branch: $head_branch,
                diff_stats: {
                    additions: $additions,
                    deletions: $deletions,
                    changed_files: $changed_files_count
                },
                changed_files: $changed_files,
                diff_excerpt: null,
                checks: {
                    status: $agg_status,
                    details: $check_details
                },
                review_state: {
                    decision: (if $review_decision == "null" then null else $review_decision end),
                    reviews: $reviews
                },
                review_threads: {
                    total: $threads_total,
                    unresolved: $threads_unresolved
                },
                commit_count: $commit_count,
                force_push_count: $force_push_count,
                staleness: {
                    days_open: $days_open,
                    days_since_update: $days_since_update
                }
            }')

        # Splice in diff_excerpt (may be null or a JSON string)
        if [[ "$diff_excerpt" != "null" ]]; then
            pr_obj=$(echo "$pr_obj" | jq --argjson diff "$diff_excerpt" '.diff_excerpt = $diff')
        fi

        prs_result=$(echo "$prs_result" | jq --argjson pr "$pr_obj" '. + [$pr]')
        pr_index=$((pr_index + 1))
    done

    echo "{}" | jq \
        --arg repo "$repo" \
        --arg rel "$relationship" \
        --argjson prs "$prs_result" \
        '{repo: $repo, relationship: $rel, collection_status: "ok", prs: $prs}'
}

# ── Main ────────────────────────────────────────────────────────────────────

generated_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
repos_array="[]"

while IFS=$'\t' read -r repo relationship; do
    [[ -z "$repo" || "$repo" == \#* ]] && continue
    repo=$(echo "$repo" | xargs)
    [[ -z "$repo" ]] && continue
    # Default relationship when absent (backward compat with old inventory files)
    relationship=$(echo "${relationship:-}" | xargs)
    [[ -z "$relationship" ]] && relationship="maintained"

    log "── Collecting: $repo ($relationship) ──"

    repo_json=""
    if [[ -n "$TIMEOUT_CMD" ]]; then
        repo_json=$($TIMEOUT_CMD "$TIMEOUT_PER_REPO" bash -c "$(declare -f collect_repo log days_between aggregate_check_status); \
            REPO_ROOT='$REPO_ROOT' \
            MAX_PRS_PER_REPO=$MAX_PRS_PER_REPO \
            DIFF_THRESHOLD_LINES=$DIFF_THRESHOLD_LINES \
            MAX_DIFF_BYTES=$MAX_DIFF_BYTES \
            INCLUDE_DRAFTS=$INCLUDE_DRAFTS \
            collect_repo '$repo'") || {
            exit_code=$?
            if [[ $exit_code -eq 124 ]]; then
                log "  TIMEOUT after ${TIMEOUT_PER_REPO}s for $repo"
                repo_json=$(echo "{}" | jq \
                    --arg repo "$repo" \
                    --arg err "Collection timed out after ${TIMEOUT_PER_REPO}s" \
                    '{repo: $repo, collection_status: "timeout", collection_error: $err, prs: []}')
            else
                log "  ERROR collecting $repo (exit code $exit_code)"
                repo_json=$(echo "{}" | jq \
                    --arg repo "$repo" \
                    --arg err "Collection failed with exit code $exit_code" \
                    '{repo: $repo, collection_status: "error", collection_error: $err, prs: []}')
            fi
        }
    else
        repo_json=$(collect_repo "$repo") || {
            log "  ERROR collecting $repo"
            repo_json=$(echo "{}" | jq \
                --arg repo "$repo" \
                --arg err "Collection failed" \
                '{repo: $repo, collection_status: "error", collection_error: $err, prs: []}')
        }
    fi

    repos_array=$(echo "$repos_array" | jq --argjson repo_data "$repo_json" '. + [$repo_data]')

done < "$REPO_INVENTORY"

# Assemble final bundle
bundle=$(jq -n \
    --arg generated_at "$generated_at" \
    --argjson include_drafts "$INCLUDE_DRAFTS" \
    --argjson max_prs "$MAX_PRS_PER_REPO" \
    --argjson diff_threshold "$DIFF_THRESHOLD_LINES" \
    --argjson repos "$repos_array" \
    '{
        schema_version: "1",
        generated_at: $generated_at,
        collector: "pr-inventory",
        config: {
            include_drafts: $include_drafts,
            max_prs_per_repo: $max_prs,
            diff_threshold_lines: $diff_threshold
        },
        repos: $repos
    }')

# Check bundle size and truncate diffs if needed
bundle_size=${#bundle}
if [[ $bundle_size -gt $MAX_BUNDLE_SIZE_BYTES ]]; then
    log "WARNING: Bundle size ($bundle_size bytes) exceeds limit ($MAX_BUNDLE_SIZE_BYTES bytes). Dropping diff excerpts from largest PRs."

    bundle=$(echo "$bundle" | jq '
        .warning = "Diff excerpts dropped from some PRs to fit within bundle size limit" |
        .repos |= [.[] |
            .prs |= (sort_by(-(.diff_excerpt // "" | length)) |
                [to_entries[] |
                    if .key < 3 then .value
                    else .value | .diff_excerpt = null
                    end
                ]
            )
        ]
    ')

    new_size=${#bundle}
    if [[ $new_size -gt $MAX_BUNDLE_SIZE_BYTES ]]; then
        bundle=$(echo "$bundle" | jq '
            .repos |= [.[] | .prs |= [.[] | .diff_excerpt = null]]
        ')
    fi

    log "Bundle trimmed from ${bundle_size} to ${#bundle} bytes."
fi

# Output
if [[ "$DRY_RUN" == "true" ]]; then
    echo "$bundle"
else
    today=$(date -u +"%Y-%m-%d")
    output_file="$REPO_ROOT/pr-inventory-data-${today}.json"
    echo "$bundle" > "$output_file"
    log "Bundle written to $output_file"
    log "Size: $(wc -c < "$output_file" | xargs) bytes"
fi
