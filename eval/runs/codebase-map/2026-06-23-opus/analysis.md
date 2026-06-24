---
agent: Claude Code
model: claude-opus-4-6
date: 2026-06-23T15:45:00Z
---

## Recommendation

**PASS — the codebase-map skill is production-ready.** All 5 deterministic judges pass at 100%, and the LLM quality judge scores 5.0/5 across all cases. Cost is within budget ($0.53/case average). No action needed beyond the two config fixes applied during this run (see Root Causes).

## Summary

| Judge | Result |
|-------|--------|
| budget_check | 100% pass ($2.66 total < $3.00 budget) |
| output_file_exists | 100% pass (3.7–6.5K chars) |
| sections_present | 100% pass (all 6 sections in every case) |
| read_only_compliance | 100% pass |
| output_quality (LLM) | 5.0/5 mean |

**Run metrics:** 5 cases, 26 turns total, 302s wall-clock, $2.66 total cost.

## Failure Patterns

No failures in the final scoring run. Two issues were resolved during execution:

1. **Write permission denied (attempt 1)** — the headless Claude Code instance couldn't write `agent-output.md` because `permissions.allow` was empty. Fixed by adding Read, Write, Bash, Edit to the allow list.

2. **Agent mapped eval harness instead of test repo (attempt 1)** — test case directories only had `input.yaml` and `annotations.yaml` in the workspace. The actual mock repo files (README.md, pyproject.toml, src/, etc.) weren't being copied in. Fixed by adding `dataset.workspace.files` to eval.yaml.

## Root Causes

1. **Missing permissions** — the eval.yaml was generated with empty `permissions.allow`. For skills that produce file output, Write (and Read/Bash for exploration) must be explicitly allowed in headless mode.

2. **Missing workspace file mapping** — the codebase-map skill operates on the working directory, so test case repo files must be present in the workspace. The `dataset.workspace.files` config lists which files from each case directory should be copied into the workspace root.

3. **LLM judge import failure** — the `anthropic` module isn't importable when score.py runs under system Python because the `_bootstrap.py` symlink resolution doesn't use `os.path.realpath()`. Workaround: run score.py directly with the venv Python.

## Cost Attribution

- **Total cost:** $2.66 across 5 cases
- **Cost per case:** $0.53 average (range: $0.39–$0.62)
- **Cost per turn:** $0.10
- **Cache hit rate:** 69.1%
- **Effective $/Mtok:** $2.63

The skill is efficient — most cost comes from cache reads, and the 69% cache hit rate keeps effective pricing well below list. The edge case (case-003, minimal repo) was cheapest ($0.62 with more turns) because there was less content to read.
