# Stale Docs Check

- **Date:** 2026-07-23
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-23 05:20:24
- **Scope:** Full semantic review (mechanical + manual doc reading)

**Summary:** 9 stale findings, 10 for review

## Findings

### `docs/draft-pr-mode.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 24 | stale | Markdown link target `patch-only-mode.md` does not exist | Update to `reference/patch-only-mode.md` |
| 24 | stale | Markdown link target `branch-only-mode.md` does not exist | Update to `reference/branch-only-mode.md` |
| 31 | review | Referenced path `examples/tasks/my-task.yaml` was not found | Confirm this is illustrative (example placeholder) |

**Provenance:** Line 24 findings confirmed via reading — the doc references `patch-only-mode.md` and `branch-only-mode.md` as sibling docs, but they're actually in `docs/reference/`. Line 31 is illustrative (user would create this file).

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | stale | Markdown link syntax `[link](url)` is a template placeholder, not a broken link | Replace with actual example URL or remove if illustrative |

**Provenance:** Mechanical pass flagged `url` as missing target. Reading line 82 shows this is in a markdown table example showing report format — `[link](url)` is a template placeholder. Reclassified to `stale` (should be a real example or noted as placeholder).

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 99 | stale | Markdown link syntax `[org/repo#482](url)` is a template placeholder | Replace with actual example URL or note as placeholder |
| 107 | stale | Markdown link syntax `[securesign/rhtas-console#310](url)` is a template placeholder | Replace with actual example URL or note as placeholder |
| 113 | stale | Markdown link syntax `[#482: PR title](url)` is a template placeholder | Replace with actual example URL or note as placeholder |
| 133 | stale | Markdown link syntax `[#310: PR title](url)` is a template placeholder | Replace with actual example URL or note as placeholder |

**Provenance:** All four are in example output format blocks. These are template placeholders showing report structure, not actual broken links. Reclassified to `stale` — should either be real examples or noted as `(url placeholder)` inline.

### `docs/admin/command-center.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 8 | review | Referenced path `docs/current.md` was not found | This appears in a bullet list item describing what command-center collects: "stale link and review finding counts from `reports/stale-docs/current.md`" — the path should be `reports/stale-docs/current.md`, not `docs/current.md`. Likely a typo or incomplete edit. |
| 23 | review | Referenced path `docs/current.md` was not found | Same as line 8 — appears in command table showing `cat reports/stale-docs/current.md` but text references wrong path. |

**Provenance:** Mechanical pass flagged bare `docs/current.md` references. Reading context shows these should reference `reports/stale-docs/current.md` instead — the file exists, the reference is just wrong.

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 29 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Appears in job dependency list context |
| 49 | review | Referenced path `scripts/macos/com.tsd` is a truncated pattern | Appears to be a grep/wildcard pattern for plist files: `scripts/macos/com.tsd-agent-lab.*.plist` — not a literal path |
| 57 | review | Referenced path `scripts/macos/com.tsd` is a truncated pattern | Same as line 49 |

**Provenance:** Line 29 confirmed as likely wrong path (same pattern as command-center.md). Lines 49/57 are actually wildcard patterns `com.tsd-agent-lab.*.plist` shown in bash commands — mechanical regex matched the prefix, but these aren't broken references.

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 26 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern as command-center.md |
| 87 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern |
| 96 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern |
| 119 | review | Referenced path `scripts/bootstrap/verify.sh` was not found | Only `scripts/bootstrap/bootstrap-agent-lab.sh` exists. If this is aspirational/planned, note it; otherwise remove the reference. |
| 139 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern |

**Provenance:** Lines 26/87/96/139 match the command-center.md pattern. Line 119 confirmed — `scripts/bootstrap/verify.sh` does not exist (only `bootstrap-agent-lab.sh` is present).

### `docs/pilot/fullsend-local-evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 38 | review | Referenced path `harness/codebase-map.yaml` was not found | Reading context (line 48): "custom `harness/codebase-map.yaml`" under a `.fullsend/` setup description. This is a Fullsend-specific file path, not a path in this repo. The reference is correct (it's describing what the evaluator *created* in a temporary `.fullsend/` directory for the Fullsend run). False positive. |

**Provenance:** Mechanical pass flagged this as missing, but reading the doc shows it's describing a file created during the Fullsend evaluation experiment, not a file expected to exist in tsd-agent-lab. Not stale.

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | review | Referenced path `harness/policies/repo-allowlist.yaml` was not found | Actual path is `policies/repo-allowlist.yaml` (no `harness/` prefix). The doc describes an old structure. Reclassify to stale and update reference. |

**Provenance:** Mechanical pass flagged as missing. Confirmed — the path should be `policies/repo-allowlist.yaml`. The `harness/policies/` structure was from an earlier phase.

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | stale | Referenced path `docs/run-claude.md` does not exist | Actual path is `docs/reference/run-claude.md`. Update the reference. |
| 131 | stale | Referenced path `docs/verification.md` does not exist | Actual path is `docs/reference/verification.md`. Update the reference. |

**Provenance:** Mechanical pass flagged these. Confirmed via reading and directory listing — both files exist under `docs/reference/`, not `docs/` directly.

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | stale | Referenced path `docs/prompts.md` does not exist | Actual path is `docs/reference/prompts.md`. Update the reference. |

**Provenance:** Mechanical pass confirmed. File exists at `docs/reference/prompts.md`.

### `scripts/macos/README.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 65 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern as command-center.md and stale-docs-check.md |

**Provenance:** Mechanical pass flagged. Likely same `docs/current.md` → `reports/stale-docs/current.md` pattern.

### `skills/stale-docs-check/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 61 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern |
| 76 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern |
| 96 | review | Referenced path `docs/current.md` — likely should be `reports/stale-docs/current.md` | Same pattern |

**Provenance:** Mechanical pass flagged. Same `docs/current.md` pattern.

## Semantic Findings

No additional semantic findings beyond the reconciliation above. Specific checks performed:

- **Directory structure claims:** README.md repository structure tree matches actual `ls` output for top-level directories.
- **Setup/bootstrap steps:** References in docs/getting-started.md and docs/guides/*.md point to scripts that exist and match current behavior (verified `harness/create-run.sh`, `harness/prepare-repo.sh`, `harness/run-claude.sh`, etc.).
- **Referenced features/tools:** Skills index in `skills/README.md` matches actual skill directories. AGENTS.md references to `policies/agent-conventions.md` are correct.
- **Cross-doc narrative consistency:** `docs/getting-started.md`, `docs/lab-context.md`, and `README.md` all describe the same phase status (Phase 9), same workflow, same directory structure.

## Reconciliation Summary

- **Mechanical → Stale (promoted):** 9 findings reclassified from `review` to `stale` after confirming the references are definitively broken (wrong paths, missing `/reference/` prefix, template placeholders in example output).
- **Mechanical → Dropped (false positives):** 3 findings dropped:
  - `docs/pilot/fullsend-local-evaluation.md:38` — describes a file created during the Fullsend experiment, not expected to exist in this repo
  - `docs/admin/schedule.md:49,57` — wildcard patterns in bash commands, not literal paths
- **Docs/current.md pattern:** 10 references to `docs/current.md` should likely be `reports/stale-docs/current.md` (or `reports/*/current.md` generically). Marked `review` because context suggests these might have been global references before reports were split by type.

## Provenance

- **Mechanical findings:** From `./scripts/macos/stale-docs-check.sh --dry-run` run at 2026-07-23 05:20:24
- **Semantic findings:** Full read of 50+ Markdown files (all non-archived `.md` files), cross-referenced against `ls`, `find`, and actual file paths
- **Reclassifications:** Based on reading the specific lines in context and verifying paths via `ls` and `Read` tool
