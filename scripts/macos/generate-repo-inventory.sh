#!/bin/bash
#
# generate-repo-inventory.sh
# Reads policies/repo-allowlist.yaml and produces a flat repo inventory.
#
# Usage: ./scripts/macos/generate-repo-inventory.sh [--help]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ALLOWLIST="${REPO_ROOT}/policies/repo-allowlist.yaml"
OUTPUT_DIR="${REPO_ROOT}/policies/generated"
OUTPUT_FILE="${OUTPUT_DIR}/repo-inventory.txt"

usage() {
  cat <<'USAGE'
Usage: generate-repo-inventory.sh [OPTIONS]

Read policies/repo-allowlist.yaml and produce policies/generated/repo-inventory.txt
containing one tab-separated "org/repo\trelationship" record per line, sorted,
with no comments or blank lines. The relationship column is either "maintained"
(team maintains the repo) or "dependency" (upstream repo the team depends on).

Relationship resolution: each organization may declare a default relationship
(default "maintained"). Individual repo entries may be objects with a "name" and
"relationship" to override the org default, or bare strings that inherit it.

For organizations with all repos allowed (repos: ["*"]), the script calls
gh api to enumerate every repository in that org.

Options:
  --help    Show this help message

Prerequisites:
  - gh CLI authenticated with appropriate access
  - ruby (ships with macOS)
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ ! -f "$ALLOWLIST" ]]; then
  echo "Error: allowlist not found at ${ALLOWLIST}" >&2
  exit 1
fi

# Parse the YAML and emit "org/repo\trelationship" lines.
# For orgs with repos: ["*"], emit a marker "ALL:org\trelationship" so we can
# call gh api later, carrying the resolved org-default relationship.
# For orgs with explicit repo lists, emit org/repo directly. Repo entries may be
# bare strings (inherit the org default) or objects with name + relationship.
parsed=$(ruby -ryaml -e '
data = YAML.load_file(ARGV[0])
(data["organizations"] || []).each do |org|
  github_org = org["github_org"]
  org_rel = org["relationship"] || "maintained"
  repos = org["repos"] || []
  if repos.include?("*")
    puts "ALL:#{github_org}\t#{org_rel}"
  else
    repos.each do |r|
      if r.is_a?(Hash)
        name = r["name"]
        rel = r["relationship"] || org_rel
      else
        name = r
        rel = org_rel
      end
      puts "#{github_org}/#{name}\t#{rel}"
    end
  end
end
' "$ALLOWLIST")

repos=""

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if [[ "$line" == ALL:* ]]; then
    # Marker format: "ALL:org\trelationship"
    marker="${line#ALL:}"
    org="${marker%%$'\t'*}"
    relationship="${marker#*$'\t'}"
    echo "Fetching repos for org '${org}' via gh api..." >&2
    fetched=$(gh api "/orgs/${org}/repos" \
      --paginate \
      --jq '.[] | select(.archived == false) | .full_name' 2>&1) || {
      echo "Error: failed to list repos for org '${org}': ${fetched}" >&2
      exit 1
    }
    while IFS= read -r full_name; do
      [[ -z "$full_name" ]] && continue
      repos+="${full_name}"$'\t'"${relationship}"$'\n'
    done <<< "$fetched"
  else
    repos+="${line}"$'\n'
  fi
done <<< "$parsed"

# Sort, deduplicate, drop blank lines
sorted=$(printf '%s' "$repos" | sort -u | grep -v '^$')

mkdir -p "$OUTPUT_DIR"
printf '%s\n' "$sorted" > "$OUTPUT_FILE"

count=$(printf '%s\n' "$sorted" | wc -l | tr -d ' ')
echo "Wrote ${count} repos to ${OUTPUT_FILE}"
