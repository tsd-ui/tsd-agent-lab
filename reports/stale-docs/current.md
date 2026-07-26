# Stale Docs Check

- **Date:** 2026-07-26
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-26 05:21:10
- **Scope:** full review (mechanical + semantic)

**Summary:** 5 stale findings, 4 for review

## Mechanical Findings

### `docs/draft-pr-mode.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 24 | review | Markdown link targets `patch-only-mode.md` and `branch-only-mode.md` resolve correctly to `docs/reference/` — false positive | No action needed (mechanical pass cannot check relative links across directories) |

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | review | Link `[link](url)` is a template placeholder, not a broken link | No action needed (template by design) |

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 99 | review | Link `[org/repo#482](url)` is a template placeholder | No action needed (template by design) |
| 107 | review | Link `[securesign/rhtas-console#310](url)` is a template placeholder | No action needed (template by design) |
| 113 | review | Multiple `(url)` placeholders are template examples | No action needed (template by design) |
| 133 | review | Link `(url)` is a template placeholder | No action needed (template by design) |

### `docs/admin/command-center.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 8 | stale | Referenced path `docs/current.md` — should be `reports/stale-docs/current.md` | Update to correct report path |
| 23 | stale | Same issue: `docs/current.md` should be `reports/stale-docs/current.md` | Update reference |

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 29 | stale | Pattern `docs/current.md` is wrong — should be `reports/<type>/current.md` | Update to correct report path pattern |
| 49 | review | Glob `scripts/macos/com.tsd*.plist` won't expand in `cp` command — command will fail | Use explicit loop or `find` instead of glob in documentation |
| 57 | review | Same glob issue in `launchctl load` command | Fix command example |

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 26 | stale | Pattern `docs/current.md` should be `reports/stale-docs/current.md` | Update reference |
| 87 | stale | Same — `docs/current.md` is wrong | Update to `reports/stale-docs/current.md` |
| 119 | stale | Referenced path `scripts/bootstrap/verify.sh` does not exist | Remove or update to correct script path |
| 139 | stale | Same `docs/current.md` pattern error | Update reference |

### `docs/draft-pr-mode.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 31 | review | Path `examples/tasks/my-task.yaml` is illustrative — not a real file | No action needed (example syntax) |

### `docs/pilot/fullsend-local-evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 38 | review | Path `harness/codebase-map.yaml` was specific to the fullsend setup attempt, which was blocked per line 36 | Context is clear — no action needed |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | stale | Path `/Users/ryordan/Obsidian/tsd-agent-lab/harness/policies/repo-allowlist.yaml` is wrong — actual path is `policies/repo-allowlist.yaml` at repo root, not under `harness/` | Update to correct path |

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | review | Link `docs/run-claude.md` should be `run-claude.md` (same directory) | Update to relative link or verify target exists |
| 131 | review | Link `docs/verification.md` should be `verification.md` (same directory) | Update to relative link or verify target exists |

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | review | Link `docs/prompts.md` should likely be `prompts.md` (same directory) or verify it resolves correctly | Verify link target |

### `scripts/macos/README.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 65 | stale | Pattern `docs/current.md` should be `reports/stale-docs/current.md` | Update reference |

### `skills/stale-docs-check/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 61 | stale | Pattern `docs/current.md` should be `reports/stale-docs/current.md` | Update reference |
| 76 | review | Same — verify this is also meant to reference reports/ | Update if stale |
| 96 | review | Same pattern | Update if stale |

## Semantic Findings

### `docs/getting-started.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 59 | review | References checking `policies/repo-allowlist.yaml` (line 59) — path is correct, no issue | No action needed |
| 66-83 | review | Directory tree diagram claims no `automations/`, `bin/`, `collectors/`, `data/`, `schemas/`, or `tests/` directories, but all exist in current repo state | Update tree to match `ls -1d */` output or note it's a simplified view |

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 49-61 | review | Commands use `com.tsd-agent-lab.*.plist` glob syntax, which won't expand in `cp`/`launchctl` commands as shown — these need explicit iteration | Rewrite as loop or explicit file list |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | stale | Path shown in example output is `/Users/ryordan/Obsidian/tsd-agent-lab/harness/policies/repo-allowlist.yaml` but actual location is `policies/repo-allowlist.yaml` at repo root — confirms the path claim in the doc is wrong | Update to `policies/repo-allowlist.yaml` |

## Notes

- **Provenance:** Mechanical findings from `stale-docs-check.sh` (link/path existence regex) were reconciled with semantic review (full doc reads). 
- **False positives:** All `(url)` placeholders in skill templates (`skills/broken-builds/SKILL.md`, `skills/pr-risk-triage/SKILL.md`) flagged by mechanical pass are confirmed as intentional template syntax — not broken links.
- **High-confidence stale:** The pattern `docs/current.md` appears in 8 locations and is consistently wrong — correct pattern is `reports/<report-type>/current.md`. This accounts for the majority of stale findings.
- **Path migration:** `policies/repo-allowlist.yaml` moved from `harness/policies/` to repo root `policies/` — one stale reference remains in pilot documentation.
- **Missing script:** `scripts/bootstrap/verify.sh` referenced in `docs/admin/stale-docs-check.md` does not exist in current repo.
