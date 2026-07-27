# Stale Docs Check

- **Date:** 2026-07-27
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-27 05:20:23
- **Scope:** mechanical checks + semantic review

**Summary:** 2 stale findings, 3 for review

## Findings

### `docs/draft-pr-mode.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 24 | review | Links to `patch-only-mode.md` and `branch-only-mode.md` are relative but files exist in `docs/reference/` | Update relative paths to `reference/patch-only-mode.md` and `reference/branch-only-mode.md` |

**Provenance:** Mechanical pass flagged these as missing, but semantic review found both files exist at `docs/reference/patch-only-mode.md` and `docs/reference/branch-only-mode.md`. The links use relative paths that don't account for the subdirectory structure.

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 119 | review | References `scripts/bootstrap/verify.sh` which does not exist | Confirm whether this was renamed, removed, or is illustrative. Only `scripts/bootstrap/bootstrap-agent-lab.sh` exists in that directory. |

**Provenance:** Mechanical pass flagged as missing path. Semantic review confirmed only `bootstrap-agent-lab.sh` exists in `scripts/bootstrap/`, no `verify.sh` script.

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | stale | Markdown link placeholder `[link](url)` in template section | Replace with actual URL pattern or mark as template placeholder more clearly (e.g., `[link](https://github.com/org/repo/actions/runs/RUN_ID)`) |

**Provenance:** Mechanical pass correctly identified this as a broken link. Semantic review confirms this is template documentation showing expected output format, but the literal `url` should be a pattern rather than a placeholder that triggers link checkers.

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 99, 107, 113, 133 | stale | Four markdown link placeholders `[...](url)` in template sections | Replace with actual URL patterns or mark as template placeholders more clearly (e.g., `[org/repo#482](https://github.com/org/repo/pull/482)`) |

**Provenance:** Mechanical pass correctly identified these as broken links. Semantic review confirms these are in template documentation showing expected output format, but the literal `url` placeholders trigger link checkers.

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111, 131 | review | References `docs/run-claude.md` and `docs/verification.md` which exist in `docs/reference/` subdirectory | Update relative paths to `run-claude.md` and `verification.md` (same directory) or remove `docs/` prefix |

**Provenance:** Mechanical pass flagged as missing paths. Semantic review confirmed both files exist at `docs/reference/run-claude.md` and `docs/reference/verification.md`. The links incorrectly include `docs/` prefix when they're already in the same `docs/reference/` directory.

## Notes

### Mechanical vs Semantic Findings

- **Mechanical findings (from `stale-docs-check.sh --dry-run`):** 7 stale, 19 for review
- **Semantic review findings (full doc read):** Reduced to 2 stale, 3 for review after reconciliation

Most mechanical findings were false positives:
- References to `docs/current.md` (flagged 9 times) are illustrative examples in documentation showing report naming conventions, not actual broken links
- References to `harness/codebase-map.yaml` and `harness/policies/repo-allowlist.yaml` in pilot docs describe paths that were tried during Fullsend evaluation but intentionally don't exist (those paths are Fullsend-specific, not part of this repo's structure)
- Path mentions like `examples/tasks/my-task.yaml` and `scripts/macos/com.tsd` (incomplete filename in schedule doc) are generic examples in how-to documentation, not references to specific files that should exist
- References to `docs/prompts.md` in `docs/reference/run-claude.md` — the file exists at `docs/reference/prompts.md`, not `docs/prompts.md`. However, this is in the same directory so the link works correctly as a relative reference.

### Cross-Doc Consistency Check

All setup guides, architecture docs, and skill documentation were read and cross-referenced:
- Directory structure diagrams in `docs/getting-started.md` and `README.md` match actual repo structure
- Setup steps in `docs/setup/bootstrap-agent-lab.md` reference scripts that exist and are current
- Skill workflow descriptions in `skills/README.md` accurately describe the repo's skill structure
- Repository layout in `README.md` matches `ls` output for all documented directories
- No narrative inconsistencies found between sibling docs

### Assumptions

- Template placeholders (literal `url` in skill output examples) categorized as `stale` because they would break if someone attempted to use the template output as-is, even though they're intentionally illustrative
- Relative path errors in `docs/draft-pr-mode.md` and `docs/reference/harness.md` categorized as `review` rather than `stale` because the files exist and the intent is clear—these are path construction issues, not missing content
- The reference to `scripts/bootstrap/verify.sh` in `docs/admin/stale-docs-check.md` categorized as `review` because it's unclear whether this describes a planned script, a removed script, or an error
