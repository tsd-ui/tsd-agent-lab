# Onboard a Repo

How to add a repository to the allowlist and run your first agent task against it.

## Before You Start

- You're logged in as `agent-lab` (see [connect-to-lab.md](connect-to-lab.md))
- The repo is **not** production and does not contain: `production`, `prod`, `customer`, `pii` in its name
- You have read access to the repo on GitHub

## Public vs. Private Repos

| Repo type | Notes |
|-----------|-------|
| **Private** | Fully supported now. Requires a lab-scoped GitHub token (not your personal token). |
| **Public** | Local harness works today. Fullsend hosted lane for public repos is pending guardrail completion (~July 2026). |

## Step 1: Add to the Allowlist

Edit `policies/repo-allowlist.yaml` and add an entry:

```yaml
- org: your-org
  repo: your-repo-name
  access: read-write        # or read-only for analysis-only tasks
  notes: "Brief reason for adding"
```

Commit the change and get team review before proceeding.

## Step 2: Create a Task YAML

Copy an example and customize it:

```bash
cp examples/tasks/read-only-codebase-map.yaml examples/tasks/your-task.yaml
```

Edit `your-task.yaml`:

```yaml
task_id: your-task-001
title: "Brief description of what the agent should do"
mode: read-only          # read-only | patch-only | commit-allowed
agent: claude-code
repo_url: https://github.com/your-org/your-repo
base_ref: main           # branch or tag to start from
prompt_file: skills/codebase-map/SKILL.md   # which skill to run

verification_commands:
  - ls worktree/          # basic smoke test
```

See [reference/task-format.md](../reference/task-format.md) for the full YAML schema.

## Step 3: Run a Read-Only First Pass

Start with `read-only` mode — no file changes, zero risk:

```bash
cd ~/workspaces/repos/tsd-agent-lab

TASK=examples/tasks/your-task.yaml
RUN_DIR=$(./harness/create-run.sh "$TASK")
./harness/prepare-repo.sh "$TASK" --run-dir "$RUN_DIR"
./harness/run-claude.sh   "$TASK" --run-dir "$RUN_DIR"
./harness/write-report.sh "$RUN_DIR"

# Review the output
cat "$RUN_DIR/summary.md"
cat "$RUN_DIR/agent-output.md"
```

## Step 4: Review and Decide

- Does the output look reasonable?
- Did the agent respect the `read-only` constraint?
- Any unexpected repository access in the logs?

If the read-only run looks good, you can create a `patch-only` task for the next step. See [run-a-task.md](run-a-task.md) for the full workflow.

## Dry Run Mode

Preview what the harness will do without executing:

```bash
./harness/create-run.sh "$TASK" --dry-run
./harness/prepare-repo.sh "$TASK" --run-dir "$RUN_DIR" --dry-run
```
