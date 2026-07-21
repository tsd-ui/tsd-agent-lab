# Stale Docs Check

- **Date:** 2026-07-21
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-21 05:20:47
- **Scope:** full review (mechanical + semantic)

**Summary:** 6 stale findings, 3 for review

## Mechanical Findings

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | stale | Markdown link target `url` does not exist in template example | Replace `[link](url)` with actual URL placeholder like `[link](https://github.com/org/repo/actions/runs/123)` or `[link](#)` |

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 99 | stale | Markdown link target `url` does not exist in template example | Replace `[org/repo#482](url)` with placeholder like `[org/repo#482](https://github.com/org/repo/pull/482)` |
| 107 | stale | Markdown link target `url` does not exist in template example | Replace `[securesign/rhtas-console#310](url)` with placeholder like `[securesign/rhtas-console#310](https://github.com/securesign/rhtas-console/pull/310)` |
| 113 | stale | Markdown link target `url` does not exist in template example | Replace `[#482: PR title](url)` with placeholder URL |
| 133 | stale | Markdown link target `url` does not exist in template example | Replace `[#310: PR title](url)` with placeholder URL |

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | stale | Referenced path `docs/run-claude.md` was not found | Update to `docs/reference/run-claude.md` |
| 131 | stale | Referenced path `docs/verification.md` was not found | Update to `docs/reference/verification.md` |

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | review | Referenced path `docs/prompts.md` was not found | Update to `docs/reference/prompts.md` |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | review | Referenced path `harness/policies/repo-allowlist.yaml` in 2026-06-23 output example | This is a historical snapshot. Actual current location is `policies/repo-allowlist.yaml`. Consider adding a note: `> **Note:** This output shows the structure as of 2026-06-23; the allowlist is now at policies/repo-allowlist.yaml.` |

## Semantic Findings

### Template placeholder URLs in SKILL.md files

**Files affected:** `skills/broken-builds/SKILL.md`, `skills/pr-risk-triage/SKILL.md`

**Finding:** Both skills include example report output with markdown links using `url` as the target (e.g., `[link](url)`, `[org/repo#482](url)`). While these are template examples, not actual broken links, they render as malformed in markdown previewers and could confuse users copying the template.

**Category:** stale (5 occurrences confirmed)

**Suggested fix:** Replace `url` placeholders with either:
- Commented examples: `[link](https://github.com/org/repo/actions/runs/123)` with a note that values are illustrative
- Fragment-only placeholders: `[link](#)` to avoid implying a real URL
- Variable-style placeholders: `[link](${RUN_URL})` to clarify they're template variables

### Missing `docs/reference/` prefix in cross-references

**Files affected:** `docs/reference/harness.md` (2 occurrences), `docs/reference/run-claude.md` (1 occurrence)

**Finding:** Three cross-references omit the `reference/` subdirectory prefix:
- harness.md:111 — references `docs/run-claude.md` instead of `docs/reference/run-claude.md`
- harness.md:131 — references `docs/verification.md` instead of `docs/reference/verification.md`
- run-claude.md:41 — references `docs/prompts.md` instead of `docs/reference/prompts.md`

All three target files exist at the correct paths under `docs/reference/`. The references are stale from when these files may have been at the top level.

**Category:** stale (3 occurrences confirmed)

**Suggested fix:** Update all three to include the `reference/` subdirectory:
- `docs/reference/run-claude.md`
- `docs/reference/verification.md`
- `docs/reference/prompts.md`

### Historical path reference in pilot doc

**File:** `docs/pilot/phase-1-read-only-pilot.md:174`

**Finding:** References `harness/policies/repo-allowlist.yaml` in quoted 2026-06-23 output example. Actual current location is `policies/repo-allowlist.yaml`. This is a historical snapshot — the output shown is what the script printed at that time, when the structure was different.

**Category:** review

**Suggested fix:** Either:
1. Add a note: `> **Note:** This output shows the structure as of 2026-06-23; the allowlist is now at policies/repo-allowlist.yaml.`
2. Accept as historical and leave unchanged (the doc is explicitly a timestamped pilot guide).

### False positives dismissed (no action needed)

The mechanical scan flagged 15 instances that were confirmed correct upon semantic review:

**False positives: `current.md` partial-string matches (13 occurrences)**
- Multiple docs in `docs/admin/`, `scripts/macos/`, and `skills/` correctly reference `reports/stale-docs/current.md` or `reports/*/current.md`
- The scanner's regex matched the substring `current.md` without requiring a full path match
- All references verified correct

**Illustrative example flagged as stale (1 occurrence)**
- `docs/admin/stale-docs-check.md:119` — references `scripts/bootstrap/verify.sh` inside a quoted example demonstrating what a stale-docs report looks like
- This is illustrative content, not an actual broken reference
- No action needed

**Historical reference, correctly described (1 occurrence)**
- `docs/pilot/fullsend-local-evaluation.md:38` — references `harness/codebase-map.yaml` in the context of a `.fullsend/` setup created during the 2026-06-23 evaluation
- This is a historical description of a transient setup, accurately documented
- No action needed

## Summary by Category

**Stale (confident):** 6 findings
1-5. Template `url` placeholders in `skills/broken-builds/SKILL.md` and `skills/pr-risk-triage/SKILL.md` (5 total)
6. Missing `docs/reference/` prefix in cross-references (3 occurrences counted as 1 pattern)

**Review (needs judgment):** 3 findings
1. `docs/reference/run-claude.md:41` — missing `reference/` prefix (could be stale or review; included here for consistency with mechanical scan's original category)
2. `docs/pilot/phase-1-read-only-pilot.md:174` — historical path in timestamped output example
3. Whether to update historical pilot output vs. add context notes

## Recommendations

### High priority (fix now)
1. Update 3 cross-references in `docs/reference/` to include the `reference/` subdirectory prefix
2. Replace 5 `url` placeholders in SKILL.md templates with actual example URLs or fragment placeholders

### Medium priority (consider for clarity)
3. Add a historical note to `docs/pilot/phase-1-read-only-pilot.md:174` clarifying the allowlist moved from `harness/policies/` to `policies/`

### No action needed
4. All 13 `current.md` matches are correct references to `reports/*/current.md`
5. `stale-docs-check.md:119` is an illustrative example, not a stale reference
6. Fullsend eval doc correctly describes historical setup
7. `com.tsd` partial prefix matches are false positives (actual files are `com.tsd-agent-lab.*.plist`)

## Provenance

- **Mechanical findings:** stale-docs-check.sh script (path/link existence checks)
- **Semantic findings:** Full repo read covering directory structure, setup steps, cross-doc consistency
- **Reconciliation:** Dismissed 15 false positives, confirmed 6 stale references (5 template URLs + 3 missing path prefixes), identified 3 review items
