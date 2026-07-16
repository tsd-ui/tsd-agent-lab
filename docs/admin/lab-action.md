# Lab Action CLI

## What It Does

A single entry point for incident investigation, PR review, and draft fixes. It composes harness scripts into pipelines — each command generates a task YAML, runs Claude against the target repo, and produces a structured report.

All commands are human-triggered and read-only or patch-only. Nothing merges or pushes automatically.

## Prerequisites

- `gh` — GitHub CLI, authenticated (`gh auth status`)
- `claude` — Claude Code CLI on PATH
- `jq` — JSON processor
- `git` — with credentials for target repos (SSH key or credential helper)

## Commands

### review-pr

Review a pull request. Fetches the PR diff and metadata via `gh`, embeds them in the prompt, and runs Claude against the base branch for codebase context.

```bash
# By reference
bin/lab-action review-pr securesign/rhtas-console-ui#45

# By URL
bin/lab-action review-pr https://github.com/securesign/rhtas-console-ui/pull/45

# Dry run (shows generated task YAML and prompt, no execution)
bin/lab-action review-pr securesign/rhtas-console-ui#45 --dry-run
```

Works on any public or accessible repo — no allowlist or incident required.

| Detail | Value |
|--------|-------|
| Mode | `review-only` |
| Pipeline | create-run → prepare-repo → run-claude → write-report |
| Timeout | 10 minutes |
| Edits allowed | No |

### investigate

Read-only analysis of a CI failure tracked as an incident.

```bash
bin/lab-action investigate INC-0001
```

Sets the incident status to `investigating` and appends an action record when complete.

| Detail | Value |
|--------|-------|
| Mode | `read-only` |
| Pipeline | create-run → prepare-repo → run-claude → write-report |
| Timeout | 10 minutes |
| Edits allowed | No |

### draft-fix

Create a patch for an incident. Uses the bugfix prompt and exports a diff.

```bash
bin/lab-action draft-fix INC-0001
```

On completion, prints a ready-to-run `gh pr create --draft` command. The human copy-pastes it — nothing is pushed automatically.

| Detail | Value |
|--------|-------|
| Mode | `patch-only` |
| Pipeline | create-run → prepare-repo → run-claude → verify-run → export-patch → write-report |
| Timeout | 15 minutes |
| Edits allowed | Yes (patch only) |

### status

Show details for a single incident, or a summary of all incidents.

```bash
# Single incident
bin/lab-action status INC-0001

# All incidents (same as `list`)
bin/lab-action status
```

### list

List incidents with optional status filter.

```bash
# All incidents
bin/lab-action list

# Only open incidents
bin/lab-action list --status open
```

## Output

Each pipeline run creates a directory under `~/workspaces/runs/<run-id>/` containing:

| File | Contents |
|------|----------|
| `agent-output.md` | Claude's raw output (review findings, investigation, or fix description) |
| `summary.md` | Structured report assembled by write-report.sh |
| `run-metadata.json` | Timestamps, status, exit codes, worktree path |
| `task.yaml` | Copy of the generated task specification |
| `composed-prompt.md` | The full prompt sent to Claude (safety preamble + task prompt) |
| `changes.patch` | Diff of agent's changes (draft-fix only) |

## Dry Run

All commands support `--dry-run` anywhere in the argument list:

```bash
bin/lab-action --dry-run review-pr owner/repo#123
bin/lab-action investigate INC-0001 --dry-run
```

Dry run shows the generated task YAML and prompt preview without cloning repos, running Claude, or mutating incident state.

## How It Works

1. **Task generation** (`bin/lib/task-gen.sh`) — builds a task YAML and a prompt file in `/tmp/`. For `review-pr`, the prompt includes the PR diff fetched via `gh pr diff`. For `investigate` and `draft-fix`, the prompt includes incident context prepended to the static prompt template.
2. **Pipeline** — calls harness scripts in sequence: `create-run.sh` → `prepare-repo.sh` → `run-claude.sh` → `write-report.sh` (plus `verify-run.sh` and `export-patch.sh` for patch-only mode).
3. **Incident updates** — `investigate` and `draft-fix` append action records to `data/incidents/index.json` after the pipeline completes.

## Troubleshooting

**"Failed to fetch PR"** — check `gh auth status` and verify you have access to the repo. For private repos, `gh` needs a token with `repo` scope.

**Timeout** — Claude has a wall-clock timeout (10 or 15 minutes depending on command). If it hits the limit, the report is still written with whatever output was produced. Check `run-metadata.json` for `agent_exit_code: 124` (timeout).

**Repo not in allowlist** — the allowlist check is advisory (warns but does not block). Any accessible repo works.
