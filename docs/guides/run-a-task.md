# Run a Task

End-to-end walkthrough of running an agent task through the harness.

## What Is a "Run"?

A run is a timestamped, isolated directory under `~/workspaces/runs/` created for one task execution. Each run contains:

- `task.yaml` — copy of the task spec
- `agent-output.md` — raw agent output
- `verification.log` — output of verification commands
- `summary.md` — generated markdown report
- `changed-files.txt` — list of modified files (if any)
- `run-metadata.json` — machine-readable run state
- `worktree/` — detached git worktree where the agent ran

The worktree is isolated from the reference clone — the agent can't push or create remote branches.

## Full Pipeline

```bash
TASK=examples/tasks/read-only-codebase-map.yaml

# 1. Create the run directory and validate the task spec
RUN_DIR=$(./harness/create-run.sh "$TASK")

# 2. Clone the repo (reuses existing clone) and create a detached worktree
./harness/prepare-repo.sh "$TASK" --run-dir "$RUN_DIR"

# 3. Run the agent inside the worktree
./harness/run-claude.sh "$TASK" --run-dir "$RUN_DIR"

# 4. Run verification commands defined in the task
./harness/verify-run.sh "$TASK" --run-dir "$RUN_DIR"

# 5. Generate a markdown report
./harness/write-report.sh "$RUN_DIR"
```

## Inspecting Results

```bash
# Human-readable summary
cat "$RUN_DIR/summary.md"

# Raw agent output
cat "$RUN_DIR/agent-output.md"

# What files changed (patch-only and above)
cat "$RUN_DIR/changed-files.txt"
git -C "$RUN_DIR/worktree" diff

# Verification results
cat "$RUN_DIR/verification.log"
```

## Exporting Patches

For `patch-only` mode, export the agent's changes as a patch file:

```bash
git -C "$RUN_DIR/worktree" diff > "$RUN_DIR/agent.patch"
```

Review the patch carefully before applying it anywhere.

## Creating a Branch and PR

For `commit-allowed` or `branch-only` mode, the agent commits to a local branch in the worktree. To push and open a PR:

```bash
# Push the branch (requires human decision)
git -C "$RUN_DIR/worktree" push origin HEAD:agent/your-description

# Open a PR via gh CLI
gh pr create --title "agent: your description" --body "$(cat $RUN_DIR/summary.md)" --draft
```

Always create PRs as **draft** first. See [review-agent-output.md](review-agent-output.md) for the full review checklist.

## Dry Run Mode

Preview without executing:

```bash
./harness/create-run.sh "$TASK" --dry-run
./harness/prepare-repo.sh "$TASK" --run-dir "$RUN_DIR" --dry-run
./harness/run-claude.sh   "$TASK" --run-dir "$RUN_DIR" --dry-run
```

## Reference

- Full harness script docs: [reference/harness.md](../reference/harness.md)
- Task YAML format: [reference/task-format.md](../reference/task-format.md)
- Patch-only constraints: [reference/patch-only-mode.md](../reference/patch-only-mode.md)
