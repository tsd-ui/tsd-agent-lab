#!/bin/bash
#
# collect.sh — Konflux build collector (stub)
#
# Outputs a valid JSON bundle with an empty repos array. A real
# implementation would need:
#
#   1. API access to the Konflux build system
#      - Authentication via a service account or kubeconfig with
#        permissions to query PipelineRun / TaskRun resources.
#      - The Konflux API endpoint (or direct Kubernetes API if running
#        in-cluster) for the target workspace/tenant.
#
#   2. Log retrieval before ephemeral log expiry
#      - Konflux build logs are stored in Tekton TaskRun pods whose
#        backing storage is garbage-collected after a retention window
#        (often 24–48 hours). The collector must pull logs within that
#        window and persist them locally or in the JSON bundle.
#      - For each failed PipelineRun, fetch logs from every failed
#        TaskRun step (e.g., build, test, deploy).
#
#   3. Mapping Konflux build concepts to the shared schema
#      - PipelineRun → repo + workflow_run in the shared schema.
#      - Component name → repo identifier.
#      - TaskRun step failures → individual job/step failure entries.
#      - Snapshot / IntegrationTestScenario results → test outcome
#        fields.
#
#   4. Preserving bounded logs/metadata when available
#      - Truncate or tail logs to a configurable maximum (e.g., last
#        200 lines per step) to keep bundle size manageable.
#      - Include structured metadata: PipelineRun UID, start/end
#        timestamps, git revision, component, application, and
#        namespace.
#      - Attach any available error-summary annotations from Tekton
#        results.
#
# Usage: collectors/konflux/collect.sh [--help]
#
set -euo pipefail

# shellcheck disable=SC2034  # conventional; will be used when this stub is implemented
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'USAGE'
Usage: collect.sh [OPTIONS]

Konflux build collector (stub). Outputs a valid JSON bundle with an
empty repos array. See source comments for what a real implementation
would need.

Options:
  --help   Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help) usage; exit 0 ;;
    *) echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

cat <<EOF
{
  "schema_version": "1",
  "collector": "konflux",
  "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "repos": []
}
EOF

exit 0
