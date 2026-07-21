# Stale Docs Check

- **Date:** 2026-07-21
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-21 13:25:14
- **Scope:** full mechanical + semantic review

**Summary:** 5 stale findings, 9 for review

## Mechanical Findings

### `skills/broken-builds/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 82 | stale | Markdown link target `url` does not exist — placeholder in example output format | Replace `[link](url)` with actual URL pattern like `[link](https://github.com/org/repo/actions/runs/123456)` or use a variable placeholder like `[link]({run_url})` |

### `skills/pr-risk-triage/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 99 | stale | Markdown link target `url` does not exist — placeholder in example output format | Replace `(url)` with actual URL pattern or variable placeholder like `({pr_url})` |
| 107 | stale | Markdown link target `url` does not exist — placeholder in example output format | Same as above |
| 113 | stale | Markdown link target `url` does not exist — placeholder in example output format | Same as above |
| 133 | stale | Markdown link target `url` does not exist — placeholder in example output format | Same as above |

### `docs/admin/schedule.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 49 | review | Referenced path `scripts/macos/com.tsd` was not found — pattern match may be too aggressive | The actual plist files follow the pattern `com.tsd-agent-lab.*.plist`, not just `com.tsd`. This is likely a false positive from the mechanical scan's regex. The line reads "A plist is provided at `scripts/macos/com.tsd-agent-lab.command-center.plist`..." which is correct. No action needed. |
| 57 | review | Referenced path `scripts/macos/com.tsd` was not found — same false positive as line 49 | Same as above — no action needed |

## Semantic Findings

### `docs/admin/command-center.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 8, 22 | review | Referenced path `docs/current.md` was not found | The doc references `docs/current.md` in two places but this file doesn't exist. Based on context, these appear to be example/placeholder references in suggested commands showing generic report viewing patterns. If these are meant to be real paths, they should point to actual report files like `reports/command-center/current.md` or similar. If they're illustrative examples, consider clarifying with a comment or using a more obviously generic placeholder. |

### `docs/admin/stale-docs-check.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 26, 87, 61, 76, 96, 139 | review | Referenced path `docs/current.md` was not found (6 occurrences) | Multiple references to an example file path `docs/current.md` in the context of explaining the mechanical script's output format. These appear to be illustrative examples showing what stale-docs findings would look like, not references to an actual file that should exist. The references occur in: example command output (line 26), example findings table (lines 61, 76, 96), and in the "How to act on findings" section (line 139). These are template examples and should remain as-is. |
| 119 | review | Referenced path `scripts/bootstrap/verify.sh` was not found | The example shows a stale-docs finding for `scripts/bootstrap/verify.sh` which doesn't exist in the current repo. This is part of an example findings table showing what output would look like. The actual `scripts/bootstrap/` directory only contains `bootstrap-agent-lab.sh`. If this was meant to be a real example from a past scan, it's now outdated. If it's illustrative, it's fine as-is. |

### `docs/pilot/fullsend-local-evaluation.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 38 | review | Referenced path `harness/codebase-map.yaml` was not found | The doc describes a Fullsend local setup attempt and mentions creating `.fullsend/` config with custom `harness/codebase-map.yaml`. This refers to a Fullsend-internal structure (`.fullsend/harness/`), not this repo's `harness/` directory. The full context shows this was part of an attempted Fullsend setup that failed. The reference is correct as a description of what *would have been* created in the Fullsend directory structure. No fix needed — this is historical documentation of a setup attempt. |

### `docs/pilot/phase-1-read-only-pilot.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 174 | review | Referenced path `harness/policies/repo-allowlist.yaml` was not found | The doc shows output from a harness run that checked for a repo allowlist at this path. The actual file is at `policies/repo-allowlist.yaml` (not under `harness/`). Either: (a) the harness script was updated to look in `policies/` and the example output is outdated, or (b) the script still checks the old path and finds nothing. Since this is historical pilot documentation (from 2026-06-23) capturing actual output, it's accurate to the time. If desired, add a footnote that the allowlist path has since moved. |

### `docs/reference/harness.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 111 | review | Referenced path `docs/run-claude.md` was not found | The doc says "See [docs/run-claude.md](run-claude.md) for full documentation." The actual file is at `docs/reference/run-claude.md`. The relative link `run-claude.md` works correctly from `docs/reference/harness.md` since they're in the same directory. The displayed path `docs/run-claude.md` in the text is just for reader orientation and is slightly imprecise (missing `/reference/`). Low priority — the link works, only the descriptive text is approximate. |
| 131 | review | Referenced path `docs/verification.md` was not found | Same pattern as line 111 — the doc references `docs/verification.md` but the actual file is `docs/reference/verification.md`. The relative link `verification.md` works from the same directory. Only the descriptive path text is imprecise. |

### `docs/reference/run-claude.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 41 | review | Referenced path `docs/prompts.md` was not found | The doc says "See [docs/prompts.md](prompts.md) for the full prompt system documentation." The actual file is at `docs/reference/prompts.md`. The relative link `prompts.md` works since both files are in `docs/reference/`. Only the displayed path is imprecise (missing `/reference/`). |

### `scripts/macos/README.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 65 | review | Referenced path `docs/current.md` was not found | Part of example output showing what the stale-docs-check script produces. This is illustrative, showing a hypothetical stale-docs finding. The actual reports write to `reports/stale-docs/current.md`. This is fine as an example. |

### `skills/stale-docs-check/SKILL.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 61, 76, 96 | review | Referenced path `docs/current.md` was not found (3 occurrences in skill doc) | Similar to the findings in `docs/admin/stale-docs-check.md` — these are illustrative examples showing what the report format looks like. They appear in the skill's own documentation explaining its output structure. These are template examples and should remain as-is. |

## Provenance Notes

- **Mechanical findings** (5 stale in SKILL.md files, 2 review in schedule.md): Detected by `stale-docs-check.sh` automated regex scan
- **Semantic findings** (9 review findings across multiple files): Identified by full-file reading and cross-referencing against actual repo state

## Summary

**5 stale findings** — All are markdown link placeholders `(url)` in SKILL.md example output formats. These should use variable-style placeholders like `({run_url})` or `{pr_url}` instead of the bare word `url` to make it clear they're templates, not broken links.

**9 for review** — Most are either:
1. False positives from the mechanical regex (the `com.tsd` pattern matches on partial paths)
2. Illustrative example paths in documentation that don't need to exist (`docs/current.md` in examples)
3. Historical references that were accurate at the time of writing (pilot output from June 2026)
4. Minor display-path imprecisions where the link works but the descriptive text is slightly off (`docs/run-claude.md` vs `docs/reference/run-claude.md`)

No directory structure diagrams were found to be out of sync. No setup/bootstrap steps were found to be stale. No referenced features were found to be missing.
