---
aliases: []
tags: []
---
# Phase 3 Completion: Local Harness v0

**Status**: ✅ Complete
**Date**: 2026-06-18

## Summary

Phase 3 built the first code-heavy infrastructure for the TSD Agent Lab: a task specification format, run directory management, and safe repository cloning via git worktrees. This provides the scaffolding for future phases to add agent orchestration, policy enforcement, and automated workflows.

The harness intentionally does NOT run agents, enforce policies, or push code. It creates the infrastructure for those capabilities.

## Deliverables

### Phase 3A—Task Spec Format

1. **schemas/task.schema.json**
   - JSON Schema (draft-07) for task specifications
   - Required fields: `task_id`, `title`, `mode`, `repo_url`
   - Mode enum: `read-only`, `patch-only`, `commit-allowed`, `review-only`
   - Optional fields for agent config, commands, verification, timeouts
   - `additionalProperties: false` for strict validation

2. **examples/tasks/read-only-codebase-map.yaml**
   - Example read-only analysis task

3. **examples/tasks/bugfix-patch-only.yaml**
   - Example patch-only bugfix task with command allow/deny lists

4. **examples/tasks/review-only.yaml**
   - Example read-only code review task

5. **docs/task-format.md**
   - Task format documentation with field reference and mode matrix

### Phase 3B—Run Directory and Report Generator

1. **harness/lib/common.sh**
   - Shared utilities sourced by all harness scripts
   - Logging: `log_info`, `log_success`, `log_warn`, `log_error`, `log_step`, `die`
   - YAML reading: dual-path reader (yq if available, grep/sed fallback)
   - Run management: `generate_run_id`, `is_dry_run`, `ensure_directory`
   - Workspace paths: `TSD_RUNS_DIR`, `TSD_REPOS_DIR`, `TSD_REPORTS_DIR` (env-overridable)
   - Source guard for safe re-sourcing

2. **harness/create-run.sh** (executable)
   - Validates task file and required fields
   - Validates mode against allowed values
   - Generates timestamped run ID: `${task_id}-YYYY-MM-DD-HHMMSS`
   - Creates run directory with placeholder files
   - Supports `--dry-run` flag
   - Exit code 2 for missing task file

3. **harness/write-report.sh** (executable)
   - Generates markdown report from run directory contents
   - Sections: Run Info, Repository, Agent Output, Changed Files, Verification, Directory Contents
   - Copies report to `~/workspaces/reports/` if directory exists

4. **examples/reports/example-run-report.md**
   - Example of a completed run report

### Phase 3C—Safe Clone/Worktree Support

1. **harness/lib/git.sh**
   - `git_clone_if_needed`—clone if target doesn't exist, verify remote URL if it does
   - `git_fetch_ref`—fetch a specific ref from origin
   - `git_create_worktree` / `git_remove_worktree`—detached worktree management
   - `git_is_repo` / `git_verify_remote`—validation helpers
   - `check_repo_allowlist`—soft check against `policies/repo-allowlist.yaml`

2. **harness/prepare-repo.sh** (executable)
   - Safe clone + worktree creation for a run
   - Checks repo allowlist (warns but does not block)
   - Reuses existing reference clones
   - Creates detached worktree (no branch to push)
   - Updates `run-metadata.json` with repo/worktree info
   - Supports `--dry-run` flag

### Documentation

1. **docs/harness.md**
   - Complete harness documentation covering all scripts, libraries, directory layout, environment variables, and typical workflow

2. **README.md** (updated)
   - Repository structure updated to reflect new directories
   - Phase 3 marked complete, current phase advanced to Phase 4

## Safety Model

- **Detached HEAD**: worktrees have no branch, so there's nothing to push
- **Reference clone isolation**: the persistent clone is only fetched, never modified
- **No push/no remote branch creation**: scripts never push or create remote branches
- **Soft allowlist**: warns about unlisted repos but does not block (the allowlist file may not exist yet)
- **Dry-run support**: all scripts support `--dry-run` to preview without side effects

## Verification

All scripts passed:

- **`bash -n`** syntax check on all 5 shell files
- **Smoke tests**:
  - `create-run.sh`—creates run directory with correct structure
  - `create-run.sh --dry-run`—prints plan without creating anything
  - `create-run.sh /nonexistent.yaml`—exits with code 2
  - `create-run.sh` with invalid mode—exits with code 1 and clear error
  - `create-run.sh` with missing fields—exits with code 1 and clear error
  - `write-report.sh`—generates correct markdown report
  - `prepare-repo.sh --dry-run`—prints plan without executing
  - Idempotency—second `create-run.sh` call produces different run directory

Note: `shellcheck` was not available on the test machine. Running it when available is recommended.

## Workspace Layout

```
~/workspaces/
├── repos/                           # Persistent reference clones (reused across runs)
│   └── demo-app/
├── runs/                            # Timestamped run directories
│   └── read-only-codebase-map-2026-06-18-143022/
│       ├── task.yaml                # Copy of the task spec
│       ├── run-metadata.json        # Machine-readable run state
│       ├── agent-output.md          # Agent output
│       ├── changed-files.txt        # Modified files list
│       ├── verification.log         # Verification results
│       ├── summary.md               # Generated report
│       └── worktree/                # Detached git worktree
└── reports/                         # Copies of run reports
```

## Files Changed

```
harness/
├── lib/
│   ├── common.sh                    (new)
│   └── git.sh                       (new)
├── create-run.sh                    (new, executable)
├── write-report.sh                  (new, executable)
└── prepare-repo.sh                  (new, executable)

schemas/
└── task.schema.json                 (new)

examples/
├── tasks/
│   ├── read-only-codebase-map.yaml  (new)
│   ├── bugfix-patch-only.yaml       (new)
│   └── review-only.yaml            (new)
└── reports/
    └── example-run-report.md        (new)

docs/
├── harness.md                       (new)
├── task-format.md                   (new)
└── phases/
    └── Phase-3-Summary.md           (new, this file)

README.md                            (updated)
```

## Next Steps: Phase 4

Proceed to **Phase 4: Runner mode**

This will involve:
- Adding agent execution to the harness (running Claude Code or other agents within a worktree)
- Policy enforcement during runs
- Timeout and resource limit support
- Structured output capture

## Notes

- All scripts follow the style established in `scripts/bootstrap/bootstrap-agent-lab.sh` (ANSI colors, status marks, `set -euo pipefail`)
- YAML reading uses `yq` when available but falls back to `grep`/`sed` for top-level scalars—no hard dependency on `yq`
- The harness is designed to be extended incrementally—each script is self-contained and can be run independently
- Phase summaries are stored under `docs/phases/` with the naming convention `Phase-N-Summary.md`
