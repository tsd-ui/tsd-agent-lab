# Phase 7—Patch-only mode

Only after the read-only pilot is useful.

## Prompt 7A—Add patch-only workflow

```markdown
Implement a patch-only workflow for the local agent lab.

Patch-only means:
- The agent may modify files in the isolated worktree.
- The agent may run verification commands.
- The harness may generate a patch file.
- The harness must not push.
- The harness must not create a PR.
- The human reviews the patch manually.

Create or update:
- `harness/export-patch.sh`
- `docs/patch-only-mode.md`
- `examples/tasks/pilot-bugfix-patch-only.yaml`
- `prompts/codex/bugfix-patch-only.md`

Requirements:
- Export a `.patch` file into the run directory.
- Include changed files list.
- Include `git diff --stat`.
- Include instructions for applying the patch manually.
- Make failure modes clear.
- Include dry-run support where practical.
```

## Prompt 7B—Add branch-only mode, but no PR yet

```markdown
Add branch-only mode to the local agent lab.

Branch-only means:
- The harness may create a local branch in the isolated worktree.
- The harness must not push unless explicitly invoked with a separate command.
- The harness must not create a PR.
- The branch name should be generated from task_id and title.

Create or update:
- `harness/create-local-branch.sh`
- `docs/branch-only-mode.md`
- `examples/tasks/pilot-branch-only.yaml`

Requirements:
- Validate that the task mode is `branch-only`.
- Create a local branch if one does not already exist.
- Refuse to overwrite existing branches unless a force flag is provided.
- Do not push.
- Print exact manual commands the human could run next.
```
