# Stale Docs Check

- **Date:** 2026-07-09
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-09 16:31:43
- **Scope:** mechanical checks only (path/link existence) — no semantic review

**Summary:** 4 stale findings, 11 for review (mechanical pass only)

## Mechanical Findings

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 14 | stale | Markdown link target `../lab-strategy.md` does not exist | Update or remove the link |
| 138 | stale | Markdown link target `../lab-strategy.md` does not exist | Update or remove the link |

### `docs/reference/evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 137 | stale | Markdown link target `../skills/codebase-map/eval.yaml` does not exist | Update or remove the link |

### `docs/setup/SWITCHING-TO-AGENT-LAB.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 152 | stale | Markdown link target `../phases/Phase-1-Quickstart.md` does not exist | Update or remove the link |

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 78 | review | Referenced path `scripts/bootstrap/verify.sh` was not found | Confirm whether this path was renamed, removed, or is illustrative |

### `docs/pilot/fullsend-local-evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 38 | review | Referenced path `harness/codebase-map.yaml` was not found | Confirm whether this path was renamed, removed, or is illustrative |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | review | Referenced path `harness/policies/repo-allowlist.yaml` was not found | Confirm whether this path was renamed, removed, or is illustrative |

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | review | Referenced path `docs/run-claude.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |
| 131 | review | Referenced path `docs/verification.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | review | Referenced path `docs/prompts.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |

### `skills/adr-writer/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 36 | review | Referenced path `docs/adr/README.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |
| 71 | review | Referenced path `docs/adr/README.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |
| 80 | review | Referenced path `docs/adr/README.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |
| 97 | review | Referenced path `docs/adr/README.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |
| 99 | review | Referenced path `docs/adr/README.md` was not found | Confirm whether this path was renamed, removed, or is illustrative |


## Semantic Findings

Not performed by this script. Run the stale-docs-check skill
(`skills/stale-docs-check/SKILL.md`) for full semantic review layered on
top of these mechanical results.
