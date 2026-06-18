# Harness

The TSD Agent Lab harness provides scaffolding for running agent tasks safely. It manages task specifications, run directories, repository isolation via git worktrees, and run reporting.

The harness intentionally does NOT run agents, enforce policies, or push code. It creates the infrastructure for those capabilities.

## Scripts

### `harness/create-run.sh`

Creates a timestamped run directory from a task file.

```bash
# Create a run
RUN_DIR=$(./harness/create-run.sh examples/tasks/read-only-codebase-map.yaml)

# Preview without creating
./harness/create-run.sh examples/tasks/read-only-codebase-map.yaml --dry-run
```

**What it does:**

1. Validates the task file has all required fields (`task_id`, `title`, `mode`, `repo_url`)
2. Validates `mode` is one of: `read-only`, `patch-only`, `commit-allowed`, `review-only`
3. Generates a run ID: `${task_id}-YYYY-MM-DD-HHMMSS`
4. Creates `~/workspaces/runs/${run_id}/` with placeholder files:
   - `task.yaml` — copy of the task specification
   - `agent-output.md` — agent output goes here
   - `verification.log` — verification command results
   - `summary.md` — generated report
   - `changed-files.txt` — list of modified files
   - `run-metadata.json` — machine-readable run state

**Exit codes:** 0 on success, 1 on validation error, 2 if task file not found.

### `harness/prepare-repo.sh`

Clones the task's repository and creates an isolated git worktree in the run directory.

```bash
# Clone and create worktree
./harness/prepare-repo.sh examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR"

# Preview without executing
./harness/prepare-repo.sh examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR" --dry-run
```

**What it does:**

1. Checks the repository against `policies/repo-allowlist.yaml` (soft check — warns but does not block)
2. Clones to `~/workspaces/repos/${repo_name}/` (reuses existing clone if remote URL matches)
3. Fetches `origin/${base_ref}` (defaults to `main`)
4. Creates a detached worktree at `${run_dir}/worktree/`
5. Updates `run-metadata.json` with repo/worktree info

**Safety model:**

- Detached HEAD — no branch exists to push
- The reference clone is never modified (only fetched)
- The script never pushes or creates remote branches
- The worktree is fully isolated from the reference clone

### `harness/write-report.sh`

Generates a markdown report from a run directory.

```bash
./harness/write-report.sh "$RUN_DIR"
```

Reads whatever exists in the run directory and assembles a report in `summary.md`. If `~/workspaces/reports/` exists, copies the report there too.

**Sections:** Run Info, Repository, Agent Output, Changed Files, Verification Results, Directory Contents.

## Libraries

### `harness/lib/common.sh`

Shared utilities sourced by all harness scripts. Provides:

- **Logging:** `log_info`, `log_success`, `log_warn`, `log_error`, `log_step`, `die`
- **YAML reading:** `read_yaml_field` (yq with grep/sed fallback), `read_yaml_field_required`
- **Run management:** `generate_run_id`, `is_dry_run`, `ensure_directory`
- **Tool checks:** `require_command`, `check_command`
- **Workspace paths:** `TSD_RUNS_DIR`, `TSD_REPOS_DIR`, `TSD_REPORTS_DIR` (env-overridable)

### `harness/lib/git.sh`

Git utility functions sourced by `prepare-repo.sh`. Provides:

- `git_clone_if_needed` — clone if target doesn't exist; verify remote URL if it does
- `git_fetch_ref` — fetch a specific ref from origin
- `git_create_worktree` — create a detached worktree
- `git_remove_worktree` — cleanup utility
- `git_is_repo` / `git_verify_remote` — validation helpers
- `check_repo_allowlist` — soft check against `policies/repo-allowlist.yaml`

## Directory Layout

```
~/workspaces/
├── repos/                         # Persistent reference clones
│   └── demo-app/                  # Reused across runs
├── runs/                          # Timestamped run directories
│   └── read-only-codebase-map-2026-06-18-143022/
│       ├── task.yaml
│       ├── run-metadata.json
│       ├── agent-output.md
│       ├── changed-files.txt
│       ├── verification.log
│       ├── summary.md
│       └── worktree/              # Detached git worktree
└── reports/                       # Copies of run reports
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TSD_RUNS_DIR` | `~/workspaces/runs` | Run directory location |
| `TSD_REPOS_DIR` | `~/workspaces/repos` | Reference clone location |
| `TSD_REPORTS_DIR` | `~/workspaces/reports` | Report copy location |
| `DRY_RUN` | unset | Set to `1` or `true` for dry-run mode |

## Typical Workflow

```bash
# 1. Create a run from a task spec
RUN_DIR=$(./harness/create-run.sh examples/tasks/read-only-codebase-map.yaml)

# 2. Clone repo and create worktree
./harness/prepare-repo.sh examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR"

# 3. (Future) Run the agent in the worktree
# cd "$RUN_DIR/worktree" && claude ...

# 4. Generate a report
./harness/write-report.sh "$RUN_DIR"
```
