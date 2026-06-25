# Task Format

Task specifications define what an agent should do, which repository to work on, and what permission level it operates at.

## File Format

Tasks are YAML files validated against `schemas/task.schema.json`.

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `task_id` | string | Unique kebab-case identifier (e.g., `bugfix-null-check`) |
| `title` | string | Human-readable description |
| `mode` | enum | Permission level (see below) |
| `repo_url` | string | Git remote URL for the target repository |

## Modes

| Mode | File Changes | Commits | Pushes |
|------|-------------|---------|--------|
| `read-only` | No | No | No |
| `review-only` | No | No | No |
| `patch-only` | Yes | No | No |
| `commit-allowed` | Yes | Yes | No |

No mode permits pushing to a remote. That is a future capability gated by additional safety checks.

## Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `base_ref` | string | Git ref for the worktree (default: `main`) |
| `working_directory` | string | Subdirectory within the repo |
| `agent` | enum | `claude-code`, `codex-cli`, or `manual` |
| `prompt_file` | string | Path to prompt file, relative to the task file |
| `allowed_commands` | list | Commands the agent may run |
| `denied_commands` | list | Commands the agent must never run |
| `verification_commands` | list | Commands to verify the result |
| `max_runtime_minutes` | integer | Wall-clock timeout |
| `expected_outputs` | list | Files expected after the run |
| `notes` | string | Free-form notes |

## Examples

See `examples/tasks/` for sample task files:

- `read-only-codebase-map.yaml` — read-only analysis
- `bugfix-patch-only.yaml` — patch-only bugfix
- `review-only.yaml` — structured code review
