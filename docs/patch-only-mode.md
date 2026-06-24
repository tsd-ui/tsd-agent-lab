# Patch-Only Mode

## What it means

In `patch-only` mode the agent may read and edit files, run tests, and inspect
the repository — but it must not commit or push. The harness runs the agent in
an isolated git worktree. When the run completes, `export-patch.sh` captures
the uncommitted diff as a portable `.patch` file for human review and manual
application.

This gives you the agent's proposed changes without any irreversible git
history. You decide when (and whether) to apply them.

## When to use patch-only

| Use patch-only when… | Use branch-only when… |
|----------------------|-----------------------|
| You want to review a raw diff before committing | You want a ready-to-push local branch |
| The change is exploratory or uncertain | The change is ready for a PR draft |
| You plan to cherry-pick hunks manually | You want a clean commit message and history |
| You prefer applying via `git apply` | You prefer `git push` and a PR |

See [branch-only-mode.md](branch-only-mode.md) for the branch-creation
workflow.

## Running a patch-only task

```bash
# 1. Create a run directory from your task file
run_dir=$(./harness/create-run.sh examples/tasks/pilot-bugfix-patch-only.yaml)

# 2. Clone the repo and create the worktree
./harness/prepare-repo.sh "$run_dir"

# 3. Run the agent
./harness/run-claude.sh "$run_dir"

# 4. (Optional) Verify outputs
./harness/verify-run.sh "$run_dir"

# 5. Export the patch
./harness/export-patch.sh "$run_dir"
```

This produces two files in the run directory:

| File | Contents |
|------|----------|
| `changes.patch` | Full unified diff, suitable for `git apply` |
| `changed-files.txt` | One path per line — files the agent modified |

## Applying the patch

```bash
# Check the target repo for conflicts first (no changes made)
cd /path/to/target-repo
git apply --check /path/to/run-dir/changes.patch

# Apply
git apply /path/to/run-dir/changes.patch

# See only the stats without applying
git apply --stat /path/to/run-dir/changes.patch
```

After applying, review the diff, run your tests, then commit and push manually:

```bash
git add -p
git commit -m "fix: null-check in user validation"
git push -u origin fix/null-check
```

## Failure modes

**No changes found.** `export-patch.sh` exits cleanly with a warning. Possible
causes: the agent made no edits, or it committed changes (check `git log` in
the worktree). If changes were committed, use `git format-patch` against the
base ref instead:

```bash
cd <worktree>
git format-patch origin/main --stdout > changes.patch
```

**Worktree missing.** `run-metadata.json` contains `worktree_path`. If that
directory no longer exists (e.g., manually cleaned up), the export will fail.
Re-run `prepare-repo.sh` to recreate the worktree, or restore the directory.

**Conflicts on apply.** `git apply --check` will report conflicting hunks
before touching your working tree. Resolve by applying manually with
`git apply --reject` and editing the `.rej` files.
