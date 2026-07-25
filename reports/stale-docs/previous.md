# Stale Docs Check

- **Date:** 2026-07-24
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-24 05:20:21
- **Scope:** mechanical checks + semantic review (full pass)

**Summary:** 7 stale findings, 3 for review

## Findings

### `docs/admin/command-center.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 8 | stale | References `docs/current.md` which doesn't exist; appears to be a template placeholder pattern from automation outputs | Replace with actual path pattern (e.g., `reports/command-center/current.md`) or remove |
| 23 | stale | References `docs/current.md` which doesn't exist (same pattern as line 8) | Replace with actual path pattern or remove |

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 29 | stale | References `docs/current.md` which doesn't exist | Replace with actual path pattern or remove |

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 26 | stale | References `docs/current.md` which doesn't exist | Replace with actual path pattern (`reports/stale-docs/current.md`) |
| 87 | stale | References `docs/current.md` which doesn't exist | Replace with actual path pattern or remove |
| 139 | stale | References `docs/current.md` which doesn't exist | Replace with actual path pattern or remove |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | stale | References `harness/policies/repo-allowlist.yaml` but actual location is `policies/repo-allowlist.yaml` (no `harness/` prefix) | Update path to `policies/repo-allowlist.yaml` |

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | review | References `docs/run-claude.md` but actual file is at `docs/reference/run-claude.md` | Update link to include `reference/` subdirectory: `[run-claude.md](run-claude.md)` or `../reference/run-claude.md` depending on context |
| 131 | review | References `docs/verification.md` but actual file is at `docs/reference/verification.md` | Update link to include `reference/` subdirectory: `[verification.md](verification.md)` or `../reference/verification.md` |

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | review | References `docs/prompts.md` but actual file is at `docs/reference/prompts.md` | Update link to include `reference/` subdirectory: `[prompts.md](prompts.md)` |

### `scripts/macos/README.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 65 | stale | References `docs/current.md` which doesn't exist | Replace with actual path pattern or remove |

## Mechanical Findings — False Positives (Resolved via Semantic Review)

The following items were flagged by the mechanical pass but confirmed valid during semantic review:

### `docs/draft-pr-mode.md`

- Line 24: Markdown links to `patch-only-mode.md` and `branch-only-mode.md` **exist** at `docs/reference/` — relative links resolved correctly
- Line 31: Reference to `examples/tasks/my-task.yaml` is an **intentional placeholder** in example command

### `skills/broken-builds/SKILL.md`

- Line 82: Markdown link `(url)` is a **template pattern** in Expected Output section, not a broken link

### `skills/pr-risk-triage/SKILL.md`

- Lines 99, 107, 113, 133: Markdown link placeholders `(url)` are **template patterns** in Expected Output section

### `docs/admin/schedule.md`

- Lines 49, 57: References to `scripts/macos/com.tsd` are **illustrative truncations** — actual files use full names like `com.tsd-agent-lab.health-report.plist`

### `docs/pilot/fullsend-local-evaluation.md`

- Line 38: Reference to `harness/codebase-map.yaml` describes a **Fullsend-specific setup artifact** created for comparison experiment (`.fullsend/harness/codebase-map.yaml`), not a claim about harness repo structure

### `docs/admin/stale-docs-check.md`

- Line 119: Reference to `scripts/bootstrap/verify.sh` appears in an **illustrative example** showing types of findings the tool might discover, not a claim about a real script

### `skills/stale-docs-check/SKILL.md`

- Lines 61, 76, 96: References to `docs/current.md` in Expected Output section are **template/example syntax** showing report format, not file existence claims

## Summary by Category

### Stale (7 findings requiring fixes)

**Pattern: `docs/current.md` references (5 occurrences)**
Multiple docs reference `docs/current.md` which doesn't exist. This appears to be a copy-paste template artifact — the convention is `reports/*/current.md`, not `docs/current.md`.
- `docs/admin/command-center.md` (lines 8, 23)
- `docs/admin/schedule.md` (line 29)
- `docs/admin/stale-docs-check.md` (lines 26, 87, 139)
- `scripts/macos/README.md` (line 65)

**Path structure changes (1 occurrence)**
- `docs/pilot/phase-1-read-only-pilot.md` line 174: References `harness/policies/repo-allowlist.yaml` but actual location is `policies/repo-allowlist.yaml`

### Review (3 findings requiring human judgment)

**Docs reorganization** — Files moved from `docs/` to `docs/reference/` subdirectory:
- `docs/reference/harness.md` lines 111, 131: References to `docs/run-claude.md` and `docs/verification.md`
- `docs/reference/run-claude.md` line 41: Reference to `docs/prompts.md`

These may be intentional relative links that work from their current location, or may need updating to reflect the new structure.

## Mechanical vs. Semantic Provenance

**Mechanical pass findings:** 26 total
- 7 flagged as `stale` (markdown link targets)
- 19 flagged as `review` (bare path mentions)

**After semantic review:**
- **Confirmed stale:** 7 (high confidence — files definitely don't exist or paths are wrong)
- **For review:** 3 (medium confidence — files exist but path references may be outdated or intentionally relative)
- **False positives:** 16 (template syntax, placeholder patterns, valid relative links, illustrative examples)

The mechanical pass correctly identified structural issues but over-reported on documentation conventions. The semantic layer was essential for distinguishing:
- Real staleness (missing files, wrong paths) from template/example syntax
- Absolute path errors from working relative references
- Repo structure claims from external artifact descriptions
