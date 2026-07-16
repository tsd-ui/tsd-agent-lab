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

# Write report to reports/stale-docs/current.md
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

## Schedule via launchd

Two plists are provided in `scripts/macos/`, neither **auto-loaded**:

- `com.tsd-agent-lab.stale-docs-check.plist` — mechanical pass only, daily at 05:15. Pure shell, no LLM involved.
- `com.tsd-agent-lab.stale-docs-check-full.plist` — full mechanical + semantic pass via `scripts/macos/stale-docs-check-skill-run.sh`, daily at 05:20 (staggered 5 minutes after the mechanical job so its report write doesn't race). This wrapper runs `claude -p --dangerously-skip-permissions` since a launchd job has no TTY to approve tool calls — see the warning in that script's header and in [Unattended semantic runs](#unattended-semantic-runs) below before enabling it.

See [schedule.md](schedule.md) for the full pipeline schedule and timezone context.

To enable either:

```sh
cp scripts/macos/com.tsd-agent-lab.stale-docs-check.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check.plist

cp scripts/macos/com.tsd-agent-lab.stale-docs-check-full.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check-full.plist
```

To disable:

```sh
launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check.plist
rm ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check.plist

launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check-full.plist
rm ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check-full.plist
```

On this lab machine, `~/Library/LaunchAgents/` is owned by `root` and not writable by `agent-lab` (`drwxr-xr-x root:staff`), so the `agent-lab` user cannot self-install these plists — the `cp` above needs to be run by an operator with write access (or the directory's ownership adjusted once, out of band). The `agent-lab` user must also be logged in for either job to fire — a `launchctl list | grep tsd-agent-lab` check confirms whether they're active.

### Unattended semantic runs

The full-pass job disables all permission checks (`--dangerously-skip-permissions`). That means if a doc's content ever tried to manipulate the agent's behavior (see `docs/architecture/threat-model.md`, MT4: Prompt Injection in Logs), there is no human approval gate to catch a resulting tool call before it executes. Mitigations in place:

- `--disallowedTools "Edit,NotebookEdit"` — the job can never modify an existing tracked file, only write the report.
- `--max-budget-usd 2` and a 30-minute timeout cap the worst case.
- The skill's own instructions are still read-only by design (Safety Constraints in `skills/stale-docs-check/SKILL.md`).

This is a real, accepted change in trust posture for an unattended job, not a fully closed risk — if that tradeoff stops being acceptable, disable `com.tsd-agent-lab.stale-docs-check-full.plist` and keep only the mechanical job scheduled; run the semantic pass interactively instead (see [Full review](#full-review-mechanical--semantic) above).

## Output

Reports are written to `reports/stale-docs/current.md`. Each report includes:

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

1. Read the report at `reports/stale-docs/current.md`.
2. For each `stale` finding, fix the doc directly (update the path/link or remove the stale reference) — the tool never does this for you.
3. For each `review` finding, use judgment: confirm it's actually fine (aspirational, illustrative) and leave it, or treat it as stale and fix it.
4. Do not delete the report after acting on it — reports accumulate under `reports/` like health reports do, giving a history of doc drift over time.

## Rollback

To fully remove this feature:

1. Unload the plists, if scheduled:

   ```sh
   launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check.plist
   rm ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check.plist
   launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check-full.plist
   rm ~/Library/LaunchAgents/com.tsd-agent-lab.stale-docs-check-full.plist
   ```

2. Delete the scripts, plist sources, and skill:

   ```sh
   rm scripts/macos/stale-docs-check.sh
   rm scripts/macos/stale-docs-check-skill-run.sh
   rm scripts/macos/com.tsd-agent-lab.stale-docs-check.plist
   rm scripts/macos/com.tsd-agent-lab.stale-docs-check-full.plist
   rm -rf skills/stale-docs-check/
   ```

3. Remove the `stale-docs-check` row from the Skill Index and Directory Layout in `skills/README.md`.

4. Delete generated reports (only the stale-docs ones, if health reports share the directory):

   ```sh
   rm -rf reports/stale-docs/
   ```

5. Delete this documentation:

   ```sh
   rm docs/admin/stale-docs-check.md
   ```

## Known limitations

- Bare-path detection uses a regex over known top-level directory prefixes (`scripts/`, `docs/`, `skills/`, `harness/`, `policies/`, `protocols/`, `examples/`, `prompts/`, `eval/`, `environments/`, `catalog/`) — a path outside those prefixes won't be checked mechanically (the semantic pass in the skill can still catch it by reading the doc).
- Placeholder detection (`{var}`, `NNNN`, `YYYY-MM-DD`, etc.) is heuristic and may occasionally miss an unusual template pattern, producing a false `review` finding — or, rarely, skip a genuinely broken reference that happens to look like a placeholder.
- The mechanical script alone cannot judge intent (aspirational vs. broken) — that requires the skill's semantic pass.
- Large docs with many references make the semantic pass slower since each doc requires a full read; the mechanical pass alone stays fast regardless of doc count.
