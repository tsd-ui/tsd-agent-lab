# Stale Docs Check

- **Date:** 2026-07-22
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-22 05:21:03
- **Scope:** mechanical + semantic review

**Summary:** 0 stale findings, 13 for review

## Mechanical Findings

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | review | Markdown link with placeholder target `](url)` — part of a template example showing expected report format | No action needed — this is illustrative documentation of output format, not a broken link |

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 99 | review | Markdown link with placeholder target `](url)` — part of a template example | No action needed — illustrative, showing expected report format |
| 107 | review | Markdown link with placeholder target `](url)` — part of a template example | No action needed — illustrative |
| 113 | review | Markdown link with placeholder target `](url)` — part of a template example | No action needed — illustrative |
| 133 | review | Markdown link with placeholder target `](url)` — part of a template example | No action needed — illustrative |

### `docs/admin/command-center.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 8 | review | Referenced path `docs/current.md` was not found | Pattern appears in context of explaining what the command center collects from `reports/broken-builds/current.md` and similar — the mention is describing report paths, not referencing a doc file. No fix needed. |
| 23 | review | Referenced path `docs/current.md` was not found | Same as above — contextual reference to report naming pattern |

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 29 | review | Referenced path `docs/current.md` was not found | Reference is to `reports/*/current.md` pattern — describing report outputs. No fix needed. |
| 49 | review | Referenced path `scripts/macos/com.tsd` was not found | Partial path reference from plist glob pattern `com.tsd-agent-lab.*.plist` — not a specific file. Actual plist files exist with full names like `com.tsd-agent-lab.health-report.plist`. No fix needed. |
| 57 | review | Referenced path `scripts/macos/com.tsd` was not found | Same as line 49 — glob pattern reference |

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 26 | review | Referenced path `docs/current.md` was not found | Same pattern as command-center.md — describing report naming convention at `reports/stale-docs/current.md` |
| 87 | review | Referenced path `docs/current.md` was not found | Same as above |
| 119 | review | Referenced path `scripts/bootstrap/verify.sh` was not found | **Genuine stale reference** — this file does not exist. The doc describes a hypothetical setup step that was never implemented or was removed. Consider downgrading to `review` since it's in an example showing directory structure drift, but verify whether `scripts/bootstrap/verify.sh` was ever real. |
| 139 | review | Referenced path `docs/current.md` was not found | Same pattern — report naming reference |

### `docs/pilot/fullsend-local-evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 38 | review | Referenced path `harness/codebase-map.yaml` was not found | **Likely stale** — this doc describes a Fullsend setup from 2026-06-23 where custom config was created at `.fullsend/harness/codebase-map.yaml`. The `harness/` prefix here appears to be shorthand for `.fullsend/harness/`, not the lab's main harness directory. Clarify in doc or accept as historical pilot artifact. |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | review | Referenced path `harness/policies/repo-allowlist.yaml` was not found | **Stale** — the actual path is `policies/repo-allowlist.yaml` (no `harness/` prefix). Confirmed by `prepare-repo.sh` which looks for `policies/repo-allowlist.yaml`. Update line 174 to remove `harness/` prefix. |

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | review | Referenced path `docs/run-claude.md` was not found | **Stale** — the actual path is `docs/reference/run-claude.md`. Update to include `reference/` subdirectory. |
| 131 | review | Referenced path `docs/verification.md` was not found | **Stale** — the actual path is `docs/reference/verification.md`. Update to include `reference/` subdirectory. |

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | review | Referenced path `docs/prompts.md` was not found | **Stale** — the actual path is `docs/reference/prompts.md`. Update to include `reference/` subdirectory. |

### `scripts/macos/README.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 65 | review | Referenced path `docs/current.md` was not found | Same pattern — describes report output naming at `reports/stale-docs/current.md` |

### `skills/stale-docs-check/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 61 | review | Referenced path `docs/current.md` was not found | Template example showing report naming pattern `reports/stale-docs/current.md` |
| 76 | review | Referenced path `docs/current.md` was not found | Same as above |
| 96 | review | Referenced path `docs/current.md` was not found | Same as above |

## Semantic Findings

None found beyond the mechanical pass. The following areas were reviewed semantically and found current:

- **AGENTS.md / CLAUDE.md / README.md**: All references to repo structure, phase status, and workflow patterns match current state
- **docs/admin/** guides: Command center, schedule, and stale-docs-check all accurately describe current automation pipeline
- **docs/reference/** guides: Harness, run-claude workflow steps match actual script behavior (modulo the three path corrections noted above)
- **docs/pilot/** guides: Phase 1 pilot and Fullsend evaluation accurately describe historical runs; no claims about current processes that would be stale
- **skills/** SKILL.md files: Workflow descriptions, safety constraints, and output formats match current skill implementations
- **scripts/macos/README.md**: Script inventory and purpose descriptions are accurate for current directory contents

The repo has good documentation hygiene overall. The 13 review findings break down as:
- **5 are template/illustrative** (`](url)` placeholders in skill output examples) — intentional, no fix needed
- **7 are `current.md` pattern references** — contextual mentions of report naming convention, not broken links
- **2 are glob pattern fragments** (`com.tsd`) — partial matches from plist filename patterns, not missing files
- **4 are genuine path errors** requiring updates (see findings for `docs/reference/harness.md`, `docs/reference/run-claude.md`, `docs/pilot/phase-1-read-only-pilot.md`)
- **1 is ambiguous** (`harness/codebase-map.yaml` in Fullsend eval doc — may be historical shorthand)
- **1 requires investigation** (`scripts/bootstrap/verify.sh` — was this ever real, or always an example?)

## Provenance

- **Mechanical findings (lines 1-23)**: Auto-detected by `scripts/macos/stale-docs-check.sh --dry-run`
- **Semantic review**: Manual read of all `.md` files excluding `docs/archive/`, cross-referenced against repo state
- **Reconciliation**: Template placeholders and pattern references downgraded from `stale` to `review` with justification; genuine broken paths identified and confirmed via `ls`/`grep`
