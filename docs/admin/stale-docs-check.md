# Stale Docs Check

Read-only documentation staleness review for the agent-lab repo. Cross-references claims in every Markdown file against current repo state (file paths, links, directory structure, setup steps) and produces a single categorized report. Never modifies docs.

## What it checks

- **Markdown links** — inline link targets that no longer exist (high confidence — categorized `stale`)
- **Bare path references** — file/script paths mentioned in prose or code spans that no longer resolve (lower confidence — categorized `review`)
- **Non-executable script invocations** — `./scripts/<name>.sh`-style references to files that exist but lost their executable bit
- **Directory structure claims** — trees or listings in docs compared against actual `ls`/`find` output (semantic, skill only)
- **Setup/bootstrap steps** — whether documented commands still match the current scripts (semantic, skill only)
- **Referenced features or tools** — whether a described workflow, tool, or convention still exists (semantic, skill only)

`docs/archive/` is always excluded — those docs are intentionally frozen.

## Manual run

There are two ways to run this, with different depth:

### Mechanical only (fast, deterministic)

```sh
# Print report to stdout without writing a file
./scripts/macos/stale-docs-check.sh --dry-run

# Write report to docs/admin/reports/stale-docs-YYYY-MM-DD.md
./scripts/macos/stale-docs-check.sh
```

Covers link/path existence only. Runs in a few seconds. Useful for a quick check, but under-reports semantic drift (e.g. a setup guide whose steps still point at real files but no longer reflect the current process) and can over-report false positives on loosely-matched bare paths.

### Full review (mechanical + semantic)

Ask Claude Code to follow the skill:

```
Follow the workflow in skills/stale-docs-check/SKILL.md to check the docs for staleness.
```

The skill runs the same script for its mechanical pass, then reads every doc in scope to judge semantic drift, reconciles both into one categorized list, and writes the combined report to the same output path — overwriting the mechanical-only version if one was already written that day.

Running either mode twice on the same day overwrites the previous report for that day (idempotent).

## Output

Reports are written to `docs/admin/reports/stale-docs-YYYY-MM-DD.md`. Each report includes:

- Date, host, user, and generation timestamp
- Summary line: `N stale findings, M for review`
- Findings grouped by file, each with line (if applicable), category, what's wrong, and a suggested fix or question

### Example output

```markdown
# Stale Docs Check

- **Date:** 2026-07-09
- **Host:** agent-lab-mac
- **User:** agent-lab
- **Generated:** 2026-07-09 09:12:04
- **Scope:** mechanical checks only (path/link existence) — no semantic review

**Summary:** 2 stale findings, 1 for review (mechanical pass only)

## Mechanical Findings

### `docs/guides/onboard-a-repo.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 42 | stale | Markdown link target `../setup/legacy-bootstrap.md` does not exist | Update or remove the link |

### `docs/setup/bootstrap-agent-lab.md`

| Line | Category | Finding | Suggested fix / question |
|------|----------|---------|---------------------------|
| 18 | stale | Markdown link target `./old-tool-notes.md` does not exist | Update or remove the link |
| 55 | review | Referenced path `scripts/bootstrap/verify.sh` was not found | Confirm whether this path was renamed, removed, or is illustrative |

## Semantic Findings

Not performed by this script. Run the stale-docs-check skill
(`skills/stale-docs-check/SKILL.md`) for full semantic review layered on
top of these mechanical results.
```

A full skill run replaces the `## Semantic Findings` section with actual findings (or "None found" if none) and may reclassify some mechanical findings after reading the doc in context.

## Categorization

- **`stale`** — confident the reference is broken (e.g. a markdown link target that doesn't exist, or a directory tree that plainly doesn't match `ls`).
- **`review`** — the checker isn't confident enough to call it broken outright: a bare path mention that might be illustrative, a setup step that might just be incomplete rather than wrong, or a doc that might be intentionally describing a planned/aspirational feature. These need a human decision.

The line between the two is subjective by design — the first few runs will likely need threshold tuning based on how much noise `review` findings produce for this repo.

## How to act on findings

1. Read the report at `docs/admin/reports/stale-docs-YYYY-MM-DD.md`.
2. For each `stale` finding, fix the doc directly (update the path/link or remove the stale reference) — the tool never does this for you.
3. For each `review` finding, use judgment: confirm it's actually fine (aspirational, illustrative) and leave it, or treat it as stale and fix it.
4. Do not delete the report after acting on it — reports accumulate under `docs/admin/reports/` like health reports do, giving a history of doc drift over time.

## Rollback

To fully remove this feature:

1. Delete the script and skill:

   ```sh
   rm scripts/macos/stale-docs-check.sh
   rm -rf skills/stale-docs-check/
   ```

2. Remove the `stale-docs-check` row from the Skill Index and Directory Layout in `skills/README.md`.

3. Delete generated reports (only the stale-docs ones, if health reports share the directory):

   ```sh
   rm docs/admin/reports/stale-docs-*.md
   ```

4. Delete this documentation:

   ```sh
   rm docs/admin/stale-docs-check.md
   ```

## Known limitations

- Bare-path detection uses a regex over known top-level directory prefixes (`scripts/`, `docs/`, `skills/`, `harness/`, `policies/`, `protocols/`, `examples/`, `prompts/`, `eval/`, `environments/`, `catalog/`) — a path outside those prefixes won't be checked mechanically (the semantic pass in the skill can still catch it by reading the doc).
- Placeholder detection (`{var}`, `NNNN`, `YYYY-MM-DD`, etc.) is heuristic and may occasionally miss an unusual template pattern, producing a false `review` finding — or, rarely, skip a genuinely broken reference that happens to look like a placeholder.
- The mechanical script alone cannot judge intent (aspirational vs. broken) — that requires the skill's semantic pass.
- Large docs with many references make the semantic pass slower since each doc requires a full read; the mechanical pass alone stays fast regardless of doc count.
