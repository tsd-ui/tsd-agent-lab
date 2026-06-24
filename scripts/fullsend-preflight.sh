#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
WARN=0
FAIL=0

pass() { printf "${GREEN}[PASS]${NC} %s\n" "$1"; PASS=$((PASS + 1)); }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; WARN=$((WARN + 1)); }
fail() { printf "${RED}[FAIL]${NC} %s\n" "$1"; FAIL=$((FAIL + 1)); }

echo "=== Fullsend Vertex AI Pre-flight Check ==="
echo ""

# 1. Check gcloud ADC can produce an access token
if gcloud auth application-default print-access-token &>/dev/null; then
  pass "gcloud ADC token generation"
else
  fail "gcloud ADC token generation — run: gcloud auth application-default login"
fi

# 2. Check ADC file exists and is reasonably fresh
ADC_FILE="${HOME}/.config/gcloud/application_default_credentials.json"
if [[ -f "$ADC_FILE" ]]; then
  pass "ADC file exists: ${ADC_FILE}"

  AGE_SECONDS=$(( $(date +%s) - $(stat -f %m "$ADC_FILE" 2>/dev/null || stat -c %Y "$ADC_FILE" 2>/dev/null) ))
  AGE_HOURS=$(( AGE_SECONDS / 3600 ))
  if (( AGE_HOURS > 24 )); then
    warn "ADC file is ${AGE_HOURS}h old (>24h) — consider refreshing: gcloud auth application-default login"
  else
    pass "ADC file age: ${AGE_HOURS}h (< 24h)"
  fi

  if python3 -c "import json,sys; d=json.load(open(sys.argv[1])); assert d.get('refresh_token')" "$ADC_FILE" 2>/dev/null; then
    pass "ADC file contains a refresh token"
  else
    fail "ADC file missing refresh_token — re-run: gcloud auth application-default login"
  fi
else
  fail "ADC file not found at ${ADC_FILE} — run: gcloud auth application-default login"
fi

# 3. Check env vars / env file
VERTEX_ENV="/tmp/fullsend-eval/.fullsend/env/vertex.env"
if [[ -f "$VERTEX_ENV" ]]; then
  pass "Vertex env file exists: ${VERTEX_ENV}"

  if grep -q 'CLAUDE_CODE_USE_VERTEX=1' "$VERTEX_ENV"; then
    pass "CLAUDE_CODE_USE_VERTEX=1 is set in vertex.env"
  else
    fail "CLAUDE_CODE_USE_VERTEX=1 missing from vertex.env"
  fi

  if grep -q 'ANTHROPIC_VERTEX_PROJECT_ID=' "$VERTEX_ENV"; then
    PROJECT_ID=$(grep 'ANTHROPIC_VERTEX_PROJECT_ID=' "$VERTEX_ENV" | sed 's/.*=//')
    pass "ANTHROPIC_VERTEX_PROJECT_ID=${PROJECT_ID}"
  else
    fail "ANTHROPIC_VERTEX_PROJECT_ID missing from vertex.env"
  fi

  if grep -q 'ANTHROPIC_VERTEX_REGION=' "$VERTEX_ENV"; then
    REGION=$(grep 'ANTHROPIC_VERTEX_REGION=' "$VERTEX_ENV" | sed 's/.*=//')
    pass "ANTHROPIC_VERTEX_REGION=${REGION}"
  else
    fail "ANTHROPIC_VERTEX_REGION missing from vertex.env"
  fi

  if grep -q '^export ' "$VERTEX_ENV"; then
    pass "vertex.env uses export (required for .env.d sourcing)"
  else
    fail "vertex.env missing 'export' prefix — vars won't be exported to Claude Code process"
  fi
else
  fail "Vertex env file not found: ${VERTEX_ENV}"
fi

# 4. Check local.env
LOCAL_ENV="/tmp/fullsend-eval/local.env"
if [[ -f "$LOCAL_ENV" ]]; then
  if grep -q 'CLAUDE_CODE_USE_VERTEX=1' "$LOCAL_ENV"; then
    pass "CLAUDE_CODE_USE_VERTEX=1 is set in local.env"
  else
    warn "CLAUDE_CODE_USE_VERTEX=1 missing from local.env"
  fi
else
  warn "local.env not found at ${LOCAL_ENV}"
fi

# 5. Check harness config mounts the ADC file
HARNESS_CFG="/tmp/fullsend-eval/.fullsend/harness/codebase-map.yaml"
if [[ -f "$HARNESS_CFG" ]]; then
  if grep -q 'application_default_credentials' "$HARNESS_CFG"; then
    pass "Harness config mounts ADC file"
  else
    fail "Harness config does not mount application_default_credentials.json"
  fi
else
  warn "Harness config not found: ${HARNESS_CFG}"
fi

# Summary
echo ""
echo "=== Summary ==="
printf "${GREEN}%d passed${NC}, ${YELLOW}%d warnings${NC}, ${RED}%d failed${NC}\n" "$PASS" "$WARN" "$FAIL"

if (( FAIL > 0 )); then
  echo ""
  echo "Fix the failures above before running fullsend."
  exit 1
fi

if (( WARN > 0 )); then
  echo ""
  echo "Warnings present — review above. Proceeding should still work."
fi

echo ""
echo "Ready for: cd /tmp/fullsend-eval && fullsend run codebase-map --fullsend-dir .fullsend --env-file local.env --target-repo <repo-path>"
exit 0
