# Stale Docs Check

- **Date:** 2026-07-28
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-28 05:20:42
- **Scope:** full semantic review (mechanical + semantic)

**Summary:** 2 stale findings, 2 for review

## Findings

### `docs/draft-pr-mode.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 24 | stale | Markdown link target `patch-only-mode.md` does not exist | Update to `../reference/patch-only-mode.md` |
| 24 | stale | Markdown link target `branch-only-mode.md` does not exist | Update to `../reference/branch-only-mode.md` |

### `docs/pilot/fullsend-local-evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 38 | review | Referenced path `harness/codebase-map.yaml` was not found | Confirm whether this was created in the blocked Fullsend setup or is aspirational — `.fullsend/` exists but `harness/codebase-map.yaml` does not |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | review | Referenced path `harness/policies/repo-allowlist.yaml` was not found | The file is actually at `policies/repo-allowlist.yaml` (top-level, not under `harness/`) — confirm whether this is a typo or refers to a planned alternate location |

## Provenance Notes

- **Mechanical findings reclassified or confirmed:**
  - `skills/broken-builds/SKILL.md` line 82 `[link](url)` — **false positive**, dismissed. This is a template placeholder showing the expected output format, not a broken link.
  - `skills/pr-risk-triage/SKILL.md` lines 99, 107, 113, 133 `(url)` — **false positive**, dismissed. These are all template placeholders in example tables, not broken links.
  - `docs/admin/command-center.md`, `docs/admin/schedule.md`, `docs/admin/stale-docs-check.md`, `scripts/macos/README.md`, `skills/stale-docs-check/SKILL.md` references to `docs/current.md` — **false positive**, dismissed. These references are illustrative examples ("`reports/stale-docs/current.md`" or "`reports/broken-builds/current.md`"), not literal `docs/current.md` paths. The mechanical regex matched `docs/current.md` fragments, but reading in context confirms they're describing the report output pattern, not referencing a missing file.
  - `docs/admin/schedule.md` lines 49, 57 `scripts/macos/com.tsd` — **false positive**, dismissed. These are glob patterns (`scripts/macos/com.tsd-agent-lab.*.plist`) shown in command examples, not literal paths.
  - `docs/draft-pr-mode.md` line 31 `examples/tasks/my-task.yaml` — **false positive**, dismissed. This is a placeholder name in a command example, not a reference to a specific required file.
  - `docs/admin/stale-docs-check.md` line 119 `scripts/bootstrap/verify.sh` — **false positive**, dismissed. Reading the doc in context, this is a hypothetical example of the kind of path that might appear in a stale-docs finding (a setup guide referencing a renamed script), not a claim that `verify.sh` itself exists or should exist.
  - `docs/reference/harness.md` line 111 `docs/run-claude.md` — **false positive**, dismissed. The doc is at `docs/reference/run-claude.md` and the link correctly points there as `[docs/run-claude.md](run-claude.md)` (relative path from `docs/reference/harness.md`). Mechanical pass misinterpreted the link text.
  - `docs/reference/harness.md` line 131 `docs/verification.md` — **false positive**, dismissed. Same as above — the doc is at `docs/reference/verification.md` and the link is correct.
  - `docs/reference/run-claude.md` line 41 `docs/prompts.md` — **false positive**, dismissed. The doc is at `docs/reference/prompts.md` and the link correctly points there as `[docs/prompts.md](prompts.md)` (relative path from `docs/reference/run-claude.md`).
  - `docs/draft-pr-mode.md` lines 24 — **confirmed stale**. The referenced files `patch-only-mode.md` and `branch-only-mode.md` exist at `docs/reference/patch-only-mode.md` and `docs/reference/branch-only-mode.md`, but the relative links from `docs/draft-pr-mode.md` are missing the `reference/` directory component.

- **Semantic findings (not surfaced by mechanical pass):**
  - None — the mechanical pass with post-reading reconciliation found all significant issues.

## Summary by Category

- **Stale (2):** Broken relative links in `docs/draft-pr-mode.md` — fix by updating to correct relative paths.
- **Review (2):** Ambiguous path references in pilot docs — need human judgment on whether these are aspirational/historical or genuine errors.

All other mechanical findings (24 candidates) were false positives from the regex-based bare-path detection. The mechanical script flagged:
- Template placeholders (`(url)`, `{var}`, `YYYY-MM-DD`) that look like paths
- Illustrative examples in prose describing report output patterns
- Glob patterns in command examples
- Relative markdown links where the link text differs from the target path

Reading each doc in context confirmed these are not genuine staleness issues.
