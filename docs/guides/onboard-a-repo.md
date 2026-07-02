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

Edit `policies/repo-allowlist.yaml`. There are two sections to update:

**a) Add to the `organizations` list** (if the org isn't already listed):

```yaml
organizations:
  - name: "Your Org Display Name"
    github_org: "your-org"
    repos:
      - "your-repo-name"
    access: "read-write"        # or "read-only" for analysis-only tasks
    notes: "Brief reason for adding"
```

If the org already exists, just append your repo to its `repos` list.

**b) Add to the `repositories` list** (flat entries used for grep matching):

```yaml
repositories:
  - "https://github.com/your-org/your-repo-name"
  - "your-org/your-repo-name"
  - "your-repo-name"
```

Commit the change and get team review before proceeding.

## Step 2: Create a Task YAML

Check `examples/tasks/` for an existing task that targets your repo — one may already exist. For example, `rhtas-console-ui-codebase-map.yaml` is ready to use for that repo.

To create a new task, copy an example and customize it:

```bash
cp examples/tasks/read-only-codebase-map.yaml examples/tasks/your-task.yaml
```

Edit `your-task.yaml`:

```yaml
task_id: your-task-001
title: "Brief description of what the agent should do"
mode: read-only          # read-only | review-only | patch-only | branch-only | commit-allowed
agent: claude-code
repo_url: https://github.com/your-org/your-repo
base_ref: main           # branch or tag to start from
prompt_file: prompts/claude/read-only-codebase-map.md   # prompt for the agent

verification_commands:
  - "test -f agent-output.md"
```

See [reference/task-format.md](../reference/task-format.md) for the full YAML schema.

## Step 3: Run a Read-Only First Pass

Start with `read-only` mode — no file changes, zero risk:

```bash
cd ~/tsd-agent-lab

TASK=examples/tasks/your-task.yaml
RUN_DIR=$(./harness/create-run.sh "$TASK")
./harness/prepare-repo.sh "$TASK" --run-dir "$RUN_DIR"
./harness/run-claude.sh   "$TASK" --run-dir "$RUN_DIR"
./harness/verify-run.sh   "$TASK" --run-dir "$RUN_DIR"
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
