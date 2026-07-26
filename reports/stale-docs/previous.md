# Stale Docs Check

- **Date:** 2026-07-25
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-25 05:20:30
- **Scope:** full review (mechanical + semantic)

**Summary:** 7 stale findings, 16 for review

## Mechanical Findings

### `docs/draft-pr-mode.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 24 | review | Markdown link targets `patch-only-mode.md` and `branch-only-mode.md` exist but in `docs/reference/`, not same directory | Update links to `reference/patch-only-mode.md` and `reference/branch-only-mode.md` |

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | stale | Markdown link target `url` does not exist | Update or remove the link (appears to be placeholder text in table header) |

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 99 | stale | Markdown link target `url` does not exist | Update or remove the link (appears to be placeholder text in table row) |
| 107 | stale | Markdown link target `url` does not exist | Update or remove the link (appears to be placeholder text in table row) |
| 113 | stale | Markdown link target `url` does not exist | Update or remove the link (appears to be placeholder text in table row) |
| 133 | stale | Markdown link target `url` does not exist | Update or remove the link (appears to be placeholder text in table row) |

### `docs/admin/command-center.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 8 | review | Referenced path `docs/current.md` is a pattern, not a literal path — refers to `reports/*/current.md` files | This is intentional shorthand; no fix needed, but could clarify in context |
| 23 | review | Referenced path `docs/current.md` is a pattern | Same as line 8 |

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 29 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage as above |
| 49 | review | Referenced path `scripts/macos/com.tsd` is a prefix pattern matching multiple plist files | This is a glob pattern, not a literal path; intentional |
| 57 | review | Referenced path `scripts/macos/com.tsd` is a prefix pattern | Same as line 49 |

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 26 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage |
| 87 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage |
| 119 | stale | Referenced path `scripts/bootstrap/verify.sh` does not exist — only `scripts/bootstrap/bootstrap-agent-lab.sh` exists in that directory | Remove reference or clarify that verification is built into bootstrap-agent-lab.sh |
| 139 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage |

### `docs/draft-pr-mode.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 31 | review | Referenced path `examples/tasks/my-task.yaml` is illustrative placeholder | This is example syntax showing pattern, not a literal path to check |

### `docs/pilot/fullsend-local-evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 38 | stale | Referenced path `harness/codebase-map.yaml` does not exist in the tsd-agent-lab repo — this was created in `.fullsend/` as part of the Fullsend setup, not as a harness file | Clarify this refers to the Fullsend-specific `.fullsend/harness/codebase-map.yaml`, not a tsd-agent-lab harness file |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | review | Referenced path `harness/policies/repo-allowlist.yaml` — actual path is `policies/repo-allowlist.yaml` (no `harness/` prefix) | Update to `policies/repo-allowlist.yaml` or confirm if this was moved during a refactor |

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | review | Referenced path `docs/run-claude.md` — actual path is `docs/reference/run-claude.md` | Update to `reference/run-claude.md` or use relative link `run-claude.md` |
| 131 | review | Referenced path `docs/verification.md` — actual path is `docs/reference/verification.md` | Update to `reference/verification.md` or use relative link `verification.md` |

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | review | Referenced path `docs/prompts.md` — actual path is `docs/reference/prompts.md` | Update to `reference/prompts.md` or use relative link `prompts.md` |

### `scripts/macos/README.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 65 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage |

### `skills/stale-docs-check/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 61 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage |
| 76 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage |
| 96 | review | Referenced path `docs/current.md` is a pattern | Same pattern usage |

## Semantic Findings

No additional semantic drift findings beyond those identified mechanically. The repository's documentation generally matches current structure and processes with the following notes:

- **Directory structure claims**: All documented directory trees in `docs/getting-started.md`, `skills/README.md`, and `scripts/macos/README.md` match actual `ls` output
- **Setup/bootstrap steps**: Scripts referenced in setup guides (`scripts/bootstrap/bootstrap-agent-lab.sh`, `harness/*.sh`) exist and match documented usage
- **Referenced features**: Skills, modes, and workflows described across documentation match actual implementation in `skills/`, `harness/`, and `policies/`
- **Cross-doc consistency**: Mode descriptions (`read-only`, `patch-only`, `branch-only`, `draft-pr`) are consistent across `docs/draft-pr-mode.md`, `docs/reference/*.md`, and task examples

## Provenance Notes

- **Mechanical findings** (7 stale, 16 review): Generated by `scripts/macos/stale-docs-check.sh` and validated/reclassified during semantic review
- **Reclassifications**:
  - `docs/draft-pr-mode.md` line 24: reclassified from `stale` to `review` — links exist but relative path is incorrect
  - `docs/admin/stale-docs-check.md` line 119: reclassified from `review` to `stale` — confirmed `scripts/bootstrap/verify.sh` does not exist
  - `docs/pilot/fullsend-local-evaluation.md` line 38: reclassified from `review` to `stale` — clarified this is Fullsend-specific path, not a harness file
  - All `docs/current.md` references: kept as `review` — this is intentional shorthand pattern, not a mistake
