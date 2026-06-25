---
aliases: []
tags: []
---
# Phase 1 Read-Only Pilot Guide

This guide walks through running the lab's first real pilot task: generating a codebase map against a real repository using the harness and skills built in Phases 0-5. Everything stays read-only.

## How to Choose a Repo

Pick a repository that:

- **Low risk**—not production-critical; a failed or noisy run has no consequences
- **Private or internal**—avoids public-repo trigger concerns (see [lab-strategy.md](../lab-strategy.md))
- **Well-structured**—has a README, clear directory layout, and standard build tooling so the agent has something meaningful to map
- **Moderate size**—large enough to exercise the skill (50+ files) but not so large that the agent times out
- **Familiar to the team**—you can judge the output's accuracy because you already know the codebase

Avoid: monorepos with hundreds of packages, repos with sensitive data, repos you've never seen before (you can't evaluate correctness).

## What Permissions Are Needed

- **Read-only clone access** to the target repository
- **Scoped PAT** for private repos—use `repo:read` scope only, stored outside this repository
- **No write permissions**—the harness creates a detached worktree; no branches, commits, or pushes occur

If cloning requires authentication, export the PAT as an environment variable or configure git credential helpers. Never store tokens in task YAML files or commit them to this repository.

## How to Run the Harness

### 1. Copy and configure the task file

```bash
cp examples/tasks/pilot-read-only-codebase-map.yaml my-pilot-task.yaml
```

Edit `my-pilot-task.yaml` and replace the placeholders:

| Placeholder | Replace with | Example |
|------------|-------------|---------|
| `<REPO_URL>` | Git clone URL | `https://github.com/my-org/my-app.git` |
| `<BASE_REF>` | Branch or tag to map | `main` |
| `<WORKING_DIRECTORY>` | Subdirectory (or remove the field for root) | `src/` |

### 2. Create a run

```bash
RUN_DIR=$(./harness/create-run.sh my-pilot-task.yaml)
echo "Run directory: $RUN_DIR"
```

Add `--dry-run` to preview without creating anything.

### 3. Prepare the repository

```bash
./harness/prepare-repo.sh my-pilot-task.yaml --run-dir "$RUN_DIR"
```

This clones the repo (or reuses an existing clone) and creates a detached worktree in the run directory.

### 4. Run the agent

```bash
./harness/run-claude.sh my-pilot-task.yaml --run-dir "$RUN_DIR"
```

Claude Code runs inside the worktree with the safety preamble prepended to the codebase-map prompt. Output lands in `$RUN_DIR/agent-output.md`.

### 5. Verify the run

```bash
./harness/verify-run.sh my-pilot-task.yaml --run-dir "$RUN_DIR"
```

Checks that `agent-output.md` exists and contains expected section headings.

### 6. Generate the report

```bash
./harness/write-report.sh "$RUN_DIR"
```

Produces `$RUN_DIR/summary.md`. See [docs/reference/harness.md](../reference/harness.md) for details on each script.

### Dry-run option

Every harness script accepts `--dry-run`. Run the full sequence with dry-run first to verify paths and configuration:

```bash
RUN_DIR=$(./harness/create-run.sh my-pilot-task.yaml --dry-run)
./harness/prepare-repo.sh my-pilot-task.yaml --run-dir "$RUN_DIR" --dry-run
./harness/run-claude.sh my-pilot-task.yaml --run-dir "$RUN_DIR" --dry-run
```

## What Output to Expect

### Agent output

`agent-output.md` should contain six sections matching the [codebase-map skill](../../skills/codebase-map/SKILL.md):

1. Directory structure with descriptions
2. Architecture overview
3. Build and test commands
4. Key dependencies
5. Risk areas
6. Recommended first tasks

### Run report

`$RUN_DIR/summary.md` contains the structured run report with run metadata, agent output excerpt, changed files (should be empty for read-only), and verification results.

### Verification

The pilot task's verification commands check:
- `agent-output.md` exists
- Expected section headings (`## Architecture`, `## Risk`, `## Build`) are present

## How to Judge Useful Work

Use this checklist to evaluate whether the output is genuinely useful:

- [ ] **Correct language/framework identification**—did the agent correctly identify the primary language, framework, and toolchain?
- [ ] **Accurate build commands**—are the build/test/lint commands correct and runnable?
- [ ] **Genuine risk areas**—are the flagged risks real concerns, not generic boilerplate?
- [ ] **Actionable recommendations**—are the suggested next tasks specific to this repo, not generic advice?
- [ ] **Useful for onboarding**—would a new team member find this document helpful for getting oriented?
- [ ] **Factually accurate**—spot-check 3-5 specific claims (file paths, dependency names, entry points) against the actual repo

For structured scoring, use the [evaluation rubric](evaluation-rubric.md) and [pilot result template](../../templates/reports/pilot-result-template.md).

## What Not to Do Yet

- **No patch or commit modes**—stick to `read-only` for the pilot
- **No Fullsend enrolment**—do not run `fullsend admin install` against the pilot repo
- **No pushing**—the harness never pushes, but double-check that no manual pushes occur
- **No PRs**—do not create pull requests from pilot output
- **No public repos with triggers**—if using a public repo, run locally only with `--no-post-script` and minimum token permissions (see [lab-strategy.md](../lab-strategy.md))

## Checklist for Sharing Results

Before sharing pilot results with the team:

- [x] Placeholders replaced—no `<REPO_URL>`, `<BASE_REF>`, or `<WORKING_DIRECTORY>` remain in the task file
- [ ] Harness completed—all five steps (create-run, prepare-repo, run-claude, verify-run, write-report) succeeded
- [ ] Output sections present—`agent-output.md` contains all six expected sections
- [ ] Verification passed—`verification.log` shows all checks passing
- [ ] Team review done—at least one other team member has reviewed the output for accuracy
- [ ] Lessons captured—any surprises, prompt adjustments, or process improvements are documented
- [ ] Result template filled—[pilot-result-template.md](../../templates/reports/pilot-result-template.md) completed with ratings and observations

---

## Outcome

Validating all of the above on 2026-06-23

### Steps 1, 2, and 3

```
tsd-agent-lab % RUN_DIR=$(./harness/create-run.sh my-pilot-task.yaml)
echo "Run directory: $RUN_DIR"
✓ /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454 (created)
✓ Run directory created: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454
Run directory: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454

% ./harness/prepare-repo.sh my-pilot-task.yaml --run-dir "$RUN_DIR"

╔════════════════════════════════════════════════════════════╗
║ Prepare Repository                                          ║
╚════════════════════════════════════════════════════════════╝

Step 1: Check allowlist
○ No repo allowlist found at /Users/ryordan/Obsidian/tsd-agent-lab/harness/policies/repo-allowlist.yaml (skipping check)

Step 2: Clone repository
✓ /Users/ryordan/workspaces/repos (exists)
✓ Clone exists and remote matches: /Users/ryordan/workspaces/repos/rhtas-console-ui

Step 3: Fetch base ref
ℹ Fetching origin/main in /Users/ryordan/workspaces/repos/rhtas-console-ui
From https://github.com/securesign/rhtas-console-ui
 * branch            main       -> FETCH_HEAD
✓ Fetched: origin/main

Step 4: Create worktree
ℹ Creating worktree at /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/worktree (detached at origin/main)
Preparing worktree (detached HEAD 0126631)
HEAD is now at 0126631 Fix: Commitlint config (#292)
✓ Worktree created: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/worktree

Step 5: Update run metadata
✓ Updated run-metadata.json

✓ Repository prepared for run

Next steps:
  1. cd /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/worktree
  2. Run your agent or analysis
  3. Generate a report: ./harness/write-report.sh /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454
```

### Step 4 (`harness/run-claude.sh`)

```
tsd-agent-lab % ./harness/run-claude.sh my-pilot-task.yaml --run-dir "$RUN_DIR"

╔════════════════════════════════════════════════════════════╗
║ Run Claude                                                  ║
╚════════════════════════════════════════════════════════════╝

Step 1: Verify agent is claude-code
✓ Agent: claude-code

Step 2: Resolve worktree
✓ Worktree: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/worktree

Step 3: Resolve prompt
✓ Prompt file: /Users/ryordan/Obsidian/tsd-agent-lab/prompts/claude/read-only-codebase-map.md

Step 4: Compose prompt
✓ Composed prompt: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/composed-prompt.md

Step 5: Run Claude
ℹ Running Claude in: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/worktree
ℹ Output: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/agent-output.md
⏱  Elapsed: 2m01s%
```

Don't ctrl+c—this looks like it's working. The timer is ticking, which means Claude is running. A codebase map of the `rhtas-console-ui` repo (4500+ objects) will take several minutes as Claude explores directories and reads files. Give it 5-10 minutes. If the timer stops advancing or it goes past ~15 minutes, then something's wrong.

### Step 6

```
tsd-agent-lab % ./harness/write-report.sh "$RUN_DIR"

✓ Report written: /Users/ryordan/workspaces/runs/pilot-read-only-codebase-map-2026-06-23-131454/summary.md
```
