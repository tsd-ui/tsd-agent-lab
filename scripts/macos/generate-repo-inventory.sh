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
containing one org/repo per line, sorted, with no comments or blank lines.

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

# Parse the YAML and emit org/repo lines.
# For orgs with repos: ["*"], emit a marker so we can call gh api.
# For orgs with explicit repo lists, emit org/repo directly.
parsed=$(ruby -ryaml -e '
data = YAML.load_file(ARGV[0])
(data["organizations"] || []).each do |org|
  github_org = org["github_org"]
  repos = org["repos"] || []
  if repos.include?("*")
    puts "ALL:#{github_org}"
  else
    repos.each { |r| puts "#{github_org}/#{r}" }
  end
end
' "$ALLOWLIST")

repos=""

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if [[ "$line" == ALL:* ]]; then
    org="${line#ALL:}"
    echo "Fetching repos for org '${org}' via gh api..." >&2
    fetched=$(gh api "/orgs/${org}/repos" \
      --paginate \
      --jq '.[].full_name' 2>&1) || {
      echo "Error: failed to list repos for org '${org}': ${fetched}" >&2
      exit 1
    }
    repos+="${fetched}"$'\n'
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
