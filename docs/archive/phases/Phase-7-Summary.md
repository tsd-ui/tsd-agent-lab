---
aliases: []
tags: []
---
# Phase 7 Summary: Patch-Only Mode

**Status:** Complete

## Deliverables

### Sub-phase 7A: Patch export

| File | Action | Description |
|------|--------|-------------|
| `harness/export-patch.sh` | Created | Export `.patch` file from worktree diff |
| `docs/patch-only-mode.md` | Created | How-to for patch-only mode end-to-end |
| `examples/tasks/pilot-bugfix-patch-only.yaml` | Created | Pilot task template for patch-only mode |
| `harness/write-report.sh` | Modified | Updated patch-only next-steps to reference `export-patch.sh` |

`export-patch.sh` reads `worktree_path` from `run-metadata.json`, runs
`git diff`, and writes `changes.patch` + `changed-files.txt` into the run
directory. Dry-run mode is supported. Exits cleanly if the worktree has no
changes.

### Sub-phase 7B: Branch creation

| File | Action | Description |
|------|--------|-------------|
| `harness/create-local-branch.sh` | Created | Stage changes, create `agent-lab/<task_id>` branch, commit |
| `docs/branch-only-mode.md` | Created | How-to for branch-only mode end-to-end |
| `examples/tasks/pilot-branch-only.yaml` | Created | Pilot task template for branch-only mode |
| `harness/create-run.sh` | Modified | Added `branch-only` to `VALID_MODES` |
| `harness/lib/agent.sh` | Modified | Added `branch-only` → `bugfix-patch-only.md` prompt mapping |
| `harness/write-report.sh` | Modified | Added `branch-only` case to next-steps section |

`create-local-branch.sh` stages all uncommitted changes, creates a branch
named `agent-lab/<task_id>`, and commits with a structured message. Supports
`--force` to overwrite an existing branch and `--dry-run` to preview without
changes. Does NOT push—prints exact manual push command.

## Verification Checklist

- [x] `export-patch.sh`—bash syntax check passes
- [x] `create-local-branch.sh`—bash syntax check passes
- [x] `branch-only` accepted by `create-run.sh` (`VALID_MODES` updated)
- [x] `branch-only` maps to `bugfix-patch-only.md` in `agent.sh`
- [x] `write-report.sh` patch-only next-steps reference `export-patch.sh`
- [x] `write-report.sh` branch-only case added
- [x] Pilot task YAMLs follow existing schema with placeholders
- [x] Both scripts follow harness conventions (`set -euo pipefail`, `lib/common.sh`, `lib/agent.sh`, `print_banner`, `die`, colored logging)
- [x] README.md Phase 7 checkbox marked complete, current phase updated to Phase 8

## Architecture Decisions

- **branch-only shares bugfix-patch-only.md prompt:** The agent workflow is
  identical between patch-only and branch-only—only post-run handling differs.
  No new prompt needed; the distinction is captured by the harness scripts.

- **No auto-push:** `create-local-branch.sh` stops at a local commit and
  prints the push command. Pushing is always a deliberate human action,
  consistent with the lab's human-in-the-loop principle.

- **Commit message includes run metadata:** The commit message embeds run_id,
  mode, and task_id for traceability without requiring separate tooling.

- **Dry-run on both scripts:** Both post-run tools support `--dry-run` so
  operators can preview outputs before committing to file changes.

## Next Steps

- **Phase 8:** Draft PR mode—after branching, open a draft PR via `gh pr create`
  as a harness step, keeping the human as the final reviewer before merge.
