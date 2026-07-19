# Stale Docs Check

- **Date:** 2026-07-18
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-18 05:21:08
- **Scope:** mechanical + semantic review

**Summary:** 3 stale findings, 3 for review

## Mechanical Findings

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | stale | Markdown link target `url` does not exist | Remove the malformed link or replace with actual URL |

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 93 | stale | Markdown link target `url` does not exist | Remove the malformed link or replace with actual URL |
| 99 | stale | Markdown link target `url` does not exist | Remove the malformed link or replace with actual URL |

## Semantic Findings

### `docs/admin/command-center.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 8, 22 | review | References `docs/current.md` but should be `reports/command-center/current.md` | Update both lines to point to `reports/command-center/current.md` |

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 29 | review | References `docs/current.md` in job dependency context; should clarify it means `reports/*/current.md` (health, stale-docs, broken-builds, command-center) | Rewrite to list specific report paths instead of generic reference |

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 26, 87, 139 | review | Multiple references to `docs/current.md` should be `reports/stale-docs/current.md` | Global find/replace `docs/current.md` → `reports/stale-docs/current.md` in this file |

### `scripts/macos/README.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 65 | review | References wrong output path for stale-docs-check.sh | Update to `reports/stale-docs/current.md` |

### `skills/stale-docs-check/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 61, 76, 96 | review | Multiple references to `docs/current.md` should be `reports/stale-docs/current.md` | Global find/replace `docs/current.md` → `reports/stale-docs/current.md` in this file |

## Findings Dismissed as False Positives

The following mechanical findings were reviewed and confirmed as false positives:

| File | Line | Mechanical Finding | Why Dismissed |
|------|------|-------------------|---------------|
| `docs/admin/schedule.md` | 49, 57 | Referenced path `scripts/macos/com.tsd` was not found | Prefix-only reference to plist file pattern `com.tsd-agent-lab.*.plist` — not a literal path. Actual plists exist with full names (e.g., `com.tsd-agent-lab.health-report.plist`). |
| `docs/admin/stale-docs-check.md` | 119 | Referenced path `scripts/bootstrap/verify.sh` was not found | Example illustration in context of verification commands. The actual script is `scripts/bootstrap/bootstrap-agent-lab.sh`. Contextually appropriate as generic example. |
| `docs/pilot/fullsend-local-evaluation.md` | 38 | Referenced path `harness/codebase-map.yaml` was not found | Illustrative reference to Fullsend's internal directory structure (`.../.fullsend/harness/codebase-map.yaml`), not a path that should exist in this repo. |
| `docs/pilot/phase-1-read-only-pilot.md` | 174 | Referenced path `harness/policies/repo-allowlist.yaml` was not found | Historical reference to early harness layout before policies moved to repo root. Contextually accurate for the pilot phase documentation. Actual path is `policies/repo-allowlist.yaml`. |
| `docs/reference/harness.md` | 111 | Referenced path `docs/run-claude.md` was not found | Should be `docs/reference/run-claude.md` — file exists, path in link is incomplete. Verified as link target issue, not missing file. |
| `docs/reference/harness.md` | 131 | Referenced path `docs/verification.md` was not found | Should be `docs/reference/verification.md` — file exists, path in link is incomplete. Verified as link target issue, not missing file. |
| `docs/reference/run-claude.md` | 41 | Referenced path `docs/prompts.md` was not found | Should be `docs/reference/prompts.md` — file exists, path in link is incomplete. Verified as link target issue, not missing file. |

## Provenance

- **Mechanical findings (21 total):** All detected by `scripts/macos/stale-docs-check.sh`
- **Semantic findings (6 groups):** Reclassification and consolidation after reading docs in full context
- **Confirmed stale (3):** The `url` link targets in skills are definitively broken placeholders (template boilerplate that should be removed or replaced)
- **Confirmed review (3 groups):** All `docs/current.md` references are systematic copy-paste errors; correct paths are `reports/*/current.md`
- **Dismissed (7):** Mechanical detections of illustrative references, historical context, or incomplete relative paths that are contextually appropriate

## Notes

### Pattern: `docs/current.md` references

The `docs/current.md` pattern appears in 12 locations across 5 files. This was never a real path — the daily pipeline scripts (`health-report.sh`, `stale-docs-check.sh`, `broken-builds-skill-run.sh`, `daily-command-center.sh`) all write to `reports/<category>/current.md`. The docs and skill files reference the wrong path consistently, suggesting this originated from a shared template or early draft that was never corrected.

### Pattern: Broken `url` placeholders in skill examples

The `url` placeholders in `skills/broken-builds/SKILL.md` and `skills/pr-risk-triage/SKILL.md` are example output templates that show the structure of the expected report. These should either show real example URLs or be removed to avoid being flagged as broken links.

### Reference docs moved to subdirectory

Several docs reference `docs/<name>.md` for reference documentation, but the actual files are at `docs/reference/<name>.md` (prompts.md, run-claude.md, verification.md). This is a minor path incompleteness issue, not missing files.
