---
aliases: []
tags: []
---
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

## Phase 7: Patch-only mode—Implementation Plan

### Context

Phase 7 extends the harness from read-only analysis into file-modification territory. The harness already validates `patch-only` as a valid mode, routes it to `prompts/claude/bugfix-patch-only.md`, and generates mode-aware report sections. What's missing are the **post-run tools**: exporting a `.patch` file from the worktree diff, and creating a named local branch for the changes. These are the first harness scripts that act on agent output rather than preparing input.

Two sub-phases:
- **7A**: `export-patch.sh`—generate a `.patch` file from the worktree diff
- **7B**: `create-local-branch.sh`—create a named branch from worktree changes (no push)

---

### 7A: Patch export

#### New files

**`harness/export-patch.sh`**—main script
- Input: `<run-dir>` (positional), `--dry-run` (flag)
- Validates run-dir exists, has `run-metadata.json`, mode is `patch-only` or `commit-allowed`
- Resolves worktree path via `resolve_worktree()` from `lib/agent.sh`
- Runs `git diff` in worktree to check for changes; exits cleanly if none
- Generates `${RUN_DIR}/changes.patch` via `git diff > changes.patch`
- Generates `${RUN_DIR}/changed-files.txt` via `git diff --name-only`
- Logs `git diff --stat` output
- Prints manual apply instructions: `cd <target> && git apply changes.patch`
- Follows existing conventions: `set -euo pipefail`, source `lib/common.sh` + `lib/agent.sh`, `usage()`, `die()`, `print_banner`, colored logging
- Dry-run prints what would be generated without writing files

**`docs/patch-only-mode.md`**—documentation
- What patch-only mode means (agent may edit files, harness captures diff, human applies)
- How to run: `./harness/export-patch.sh <run-dir>`
- How to apply: `git apply`, `git apply --check` (dry-run), `git apply --stat`
- Failure modes: no changes, worktree missing, conflicts on apply
- When to use patch-only vs. branch-only vs. commit-allowed

**`examples/tasks/pilot-bugfix-patch-only.yaml`**—pilot task template
- Follows existing schema (task_id, title, mode, repo_url, base_ref, agent, etc.)
- Mode: `patch-only`
- Includes placeholders like the existing pilot task
- Verification commands include `git diff --stat` and file existence checks
- Expected outputs: `changed-files.txt`

**`prompts/claude/bugfix-patch-only.md`**—already exists, no changes needed. The current prompt correctly instructs the agent to edit files, run tests, write `changed-files.txt`, and not commit/push.

#### Modified files

**`harness/write-report.sh`**—update the `patch-only` next-steps section (lines 140-143) to reference `export-patch.sh`:

```
- Export a patch: `./harness/export-patch.sh <run-dir>`
- Review the diff: `cd <worktree> && git diff`
- Apply the patch: `cd <target-repo> && git apply <run-dir>/changes.patch`
```

---

### 7B: Branch creation

#### New files

**`harness/create-local-branch.sh`**—main script
- Input: `<run-dir>` (positional), `--force` (flag), `--dry-run` (flag)
- Validates run-dir, mode is `patch-only`, `commit-allowed`, or a new `branch-only` mode
- Resolves worktree path
- Generates branch name from task metadata: `agent-lab/${task_id}` (e.g. `agent-lab/bugfix-null-check`)
- Checks if branch already exists; refuses to overwrite without `--force`
- Creates branch in worktree: `git checkout -b <branch-name>`
- Stages and commits all changes with a descriptive message
- Does NOT push—prints exact manual commands: `cd <worktree> && git push -u origin <branch>`
- Dry-run prints what would happen

**`docs/branch-only-mode.md`**—documentation
- What branch-only mode means (harness creates local branch, no push, no PR)
- How to run: `./harness/create-local-branch.sh <run-dir>`
- How to push manually
- Force flag behavior
- When to use branch-only vs. patch-only

**`examples/tasks/pilot-branch-only.yaml`**—pilot task template
- Mode: `branch-only` (new mode value)
- Follows existing schema with placeholders
- Verification commands

#### Modified files

**`harness/create-run.sh`**—add `branch-only` to `VALID_MODES` (line 32):

```
VALID_MODES="read-only patch-only branch-only commit-allowed review-only"
```

**`harness/lib/agent.sh`**—add `branch-only` to the prompt derivation switch (line 28 area), mapping it to `bugfix-patch-only.md` (same prompt—the agent workflow is the same, only post-run handling differs)

**`harness/write-report.sh`**—add `branch-only` case to next-steps (after the `patch-only` case):

```
branch-only)
  echo "- Create a local branch: \`./harness/create-local-branch.sh ${RUN_DIR}\`"
  echo "- Review commits: \`cd ${worktree_path} && git log --oneline\`"
  echo "- Push when ready: \`cd ${worktree_path} && git push -u origin <branch>\`"
  ;;
```

---

### Verification

1. **Shellcheck** all new scripts: `shellcheck harness/export-patch.sh harness/create-local-branch.sh`
2. **Dry-run test** for export-patch: `./harness/export-patch.sh <any-existing-run-dir> --dry-run`
3. **Dry-run test** for create-local-branch: `./harness/create-local-branch.sh <any-existing-run-dir> --dry-run`
4. **Mode validation**: confirm `branch-only` is accepted by `create-run.sh` and rejected modes still fail
5. **YAML validation**: confirm pilot task files parse correctly with `yq` or grep-based reader
6. **Phase completion**: create `docs/phases/Phase-7-Summary.md`, update README.md checkbox and current phase line

### File summary

| Action | File                                                                        |
| ------ | --------------------------------------------------------------------------- |
| Create | `harness/export-patch.sh`                                                   |
| Create | `harness/create-local-branch.sh`                                            |
| Create | `docs/patch-only-mode.md`                                                   |
| Create | `docs/branch-only-mode.md`                                                  |
| Create | `examples/tasks/pilot-bugfix-patch-only.yaml`                               |
| Create | `examples/tasks/pilot-branch-only.yaml`                                     |
| Modify | `harness/create-run.sh`—add `branch-only` to VALID_MODES                    |
| Modify | `harness/lib/agent.sh`—add `branch-only` prompt derivation                  |
| Modify | `harness/write-report.sh`—update next-steps for patch-only, add branch-only |

## Outcome

⏺ Phase 7 is complete. Here's what was implemented:

7A—Patch export:
- `harness/export-patch.sh`—runs git diff in the worktree, writes `changes.patch` + `changed-files.txt`, supports `--dry-run`, exits cleanly if no changes
- `docs/patch-only-mode.md`—end-to-end how-to including apply instructions and failure modes
- `examples/tasks/pilot-bugfix-patch-only.yaml`—pi[]()lot task template
- `harness/write-report.sh`—patch-only next-steps now reference export-patch.sh

7B—Branch creation:
- `harness/create-local-branch.sh`—stages changes, creates `agent-lab/<task_id>` branch, commits with run metadata, prints push command (no auto-push), supports `--force` and `--dry-run`
- `docs/branch-only-mode.md`—end-to-end how-to including push and PR instructions
- `examples/tasks/pilot-branch-only.yaml`—pilot task template
- `harness/create-run.sh`—branch-only added to `VALID_MODES`
- `harness/lib/agent.sh`—branch-only maps to `bugfix-patch-only.md`
- `harness/write-report.sh`—branch-only case added to next-steps

Phase completion:
- `docs/phases/Phase-7-Summary.md`—verification checklist + architecture decisions
- `README.md`—Phase 7 checked off, current phase updated to Phase 8
