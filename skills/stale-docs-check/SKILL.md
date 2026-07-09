---
aliases: []
tags: []
name: stale-docs-check
description: Review repo documentation for stale references and produce a findings report
fullsend_role: review
---
# Stale Docs Check

## Description

Review all Markdown documentation in the repo, cross-reference its claims against current repo state, and produce a single categorized findings report. This is a read-only skill—it never modifies docs. Where staleness is confident (a referenced file or link is simply gone), findings are marked `stale`. Where the answer requires judgment (a process description that might just be incomplete rather than wrong, an aspirational feature), findings are marked `review` for a human to decide.

## When to Use

- Periodic documentation hygiene checks as the repo evolves
- Before a documentation audit or cleanup pass
- After a significant refactor, to catch docs that fell out of sync
- Onboarding a new contributor who needs to trust the docs are accurate

## When Not to Use

- You already know which specific doc is wrong and just need to fix it (edit it directly instead)
- You need a full codebase assessment (use codebase-map instead)
- The repo has no `docs/admin/reports/` output location configured

## Workflow

### Step 1: Run the mechanical scan

Run the mechanical checker and capture its output:

```sh
./scripts/macos/stale-docs-check.sh --dry-run
```

This deterministically finds broken markdown links, missing referenced paths, and non-executable scripts referenced as invocations. It excludes `docs/archive/` and categorizes each finding as `stale` (markdown link targets — high confidence) or `review` (bare path mentions and executable-bit checks — lower confidence, prone to matching illustrative examples). Treat this output as a starting candidate list, not the final word — you will confirm, reclassify, or dismiss each one in Step 3.

### Step 2: Read every doc in scope

Enumerate all `.md` files in the repo excluding `docs/archive/`. Read each one fully. For each, check claims against current repo state that the mechanical pass cannot judge:

- **Directory structure** — does a described tree (e.g. "```skills/\n  foo/\n  bar/```") match actual `ls`/`find` output for that directory?
- **Setup/bootstrap steps** — do the commands in setup guides match the current scripts in `scripts/` and `harness/`? Look for renamed flags, removed steps, or scripts that now behave differently (read the script, not just its filename).
- **Referenced features or tools** — does the doc describe a workflow, tool, or convention that still exists in the repo (check `AGENTS.md`, `policies/agent-conventions.md`, and the relevant script/skill)?
- **Cross-doc narrative consistency** — does a doc describe a process "significantly differently" from how a sibling doc or the actual repo structure describes it?

Do not re-derive the link/path existence checks from Step 1 — that mechanical pass already covers straightforward existence. Focus your reading on things that require understanding intent and current behavior.

### Step 3: Reconcile mechanical and semantic findings

For each mechanical finding from Step 1:
- Keep it as-is if your reading confirms it's a real, unambiguous break.
- Reclassify `review` → `stale` if you've confirmed with certainty (e.g. you found the path was renamed and can point to the rename).
- Downgrade or drop it if it's a false positive (e.g. a template pattern the mechanical regex didn't recognize, or a deliberately aspirational/future-looking reference — note these explicitly rather than silently dropping them).

Add any new findings surfaced only by semantic reading (Step 2). Every finding — mechanical or semantic — gets exactly one category: `stale` or `review`.

### Step 4: Compose the report

Write a single markdown report to `docs/admin/reports/stale-docs-YYYY-MM-DD.md` (today's date, matching the mechanical script's naming convention). Structure:

- Header: date, host, user, generation timestamp
- Summary line, exactly in the form: `N stale findings, M for review`
- Findings grouped by file (`### \`path/to/file.md\``), each as a table row with: line (if applicable), category, what's wrong, and a suggested fix or question
- A closing note distinguishing which findings came from the mechanical pass vs. semantic review, so a reader can weight confidence accordingly

If a file has zero findings, omit it from the report body — do not pad the report with empty per-file sections. If the repo has zero findings overall, state that plainly.

### Step 5: Do not modify anything

The report is the only artifact this skill produces. Do not edit any `.md` file to "fix" a finding, even an obvious typo — that is out of scope and violates read-only mode.

## Expected Output

A single file `docs/admin/reports/stale-docs-YYYY-MM-DD.md` containing:
- Header metadata and summary line (`N stale findings, M for review`)
- Findings grouped by file, each with line, category, description, and suggested fix/question
- A note on mechanical vs. semantic provenance per finding group

## Safety Constraints

- **Read-only mode.** Do not modify any repository files, including the docs being reviewed. (Safety preamble rule 1)
- Do not run `git push` or create remote branches. (Rule 2)
- Do not create, comment on, or close pull requests. (Rule 3)
- Do not read or reference credentials, tokens, or API keys. (Rule 5)
- Do not use `sudo` or any privilege escalation. (Rule 6)
- Skip `docs/archive/` entirely — those docs are intentionally frozen. (Rule 7, repo convention)
- Never read or reference paths under `/Users/ryordan/Obsidian/WorkVault/` or any other private vault, even if a doc happens to mention one. (Rule 5, repo constraint)
- Run as the `agent-lab` user, not `ryordan`. (Repo constraint)
- Document assumptions — especially any judgment call on stale vs. review. (Rule 9)
- Write the single report file at the path specified above. (Rule 10)

## Verification

- `docs/admin/reports/stale-docs-YYYY-MM-DD.md` exists and is non-empty
- The summary line matches the format `N stale findings, M for review`
- No file outside `docs/admin/reports/` was modified (check `git status`)
- `docs/archive/` produced no findings and was not read for this purpose
- Every finding has a file, category (`stale` or `review`), and a description
- The report contains no paths under `/Users/ryordan/`

## Notes

This skill wraps `scripts/macos/stale-docs-check.sh`, which handles the deterministic path/link existence checks fast and cheaply. The skill adds the semantic layer a shell script can't: judging whether a setup guide still matches reality, whether a directory tree diagram is current, and whether an ambiguous reference should block (stale) or just prompt a question (review). Running the script alone (without this skill) produces a valid but mechanical-only report — useful for a quick check, but it will under-report semantic drift and over-report false positives on loosely-matched bare paths.
