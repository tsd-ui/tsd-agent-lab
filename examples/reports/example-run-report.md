# Run Report: read-only-codebase-map-2026-06-18-143022

_Generated: 2026-06-18T14:35:00Z_

## Run Info

| Field | Value |
|-------|-------|
| Run ID | `read-only-codebase-map-2026-06-18-143022` |
| Task ID | `read-only-codebase-map` |
| Title | Generate a codebase structure map |
| Mode | `read-only` |
| Status | `completed` |
| Created | 2026-06-18T14:30:22Z |

## Repository

| Field | Value |
|-------|-------|
| URL | https://github.com/example-org-1/demo-app.git |
| Worktree | `~/workspaces/runs/read-only-codebase-map-2026-06-18-143022/worktree` |
| Base ref | `main` |

## Agent Output

```
# Codebase Map: demo-app

## Structure

- `src/` — Application source code
  - `api/` — REST API routes
  - `models/` — Database models
  - `utils/` — Shared utilities
- `tests/` — Test suite
- `docs/` — Documentation
- `package.json` — Node.js project configuration

## Entry Points

- `src/index.js` — Main application entry point
- `src/api/router.js` — API route registration

## Key Dependencies

- express (HTTP framework)
- pg (PostgreSQL client)
- jest (testing)
```

## Changed Files

_No changed files recorded._

## Verification Results

```
✓ agent-output.md exists and is non-empty
```

## Directory Contents

```
total 32
drwxr-xr-x  9 agent-lab  staff  288 Jun 18 14:35 .
drwxr-xr-x  5 agent-lab  staff  160 Jun 18 14:30 ..
-rw-r--r--  1 agent-lab  staff  412 Jun 18 14:33 agent-output.md
-rw-r--r--  1 agent-lab  staff    0 Jun 18 14:30 changed-files.txt
-rw-r--r--  1 agent-lab  staff  256 Jun 18 14:30 run-metadata.json
-rw-r--r--  1 agent-lab  staff  891 Jun 18 14:35 summary.md
-rw-r--r--  1 agent-lab  staff  380 Jun 18 14:30 task.yaml
-rw-r--r--  1 agent-lab  staff   48 Jun 18 14:34 verification.log
drwxr-xr-x  3 agent-lab  staff   96 Jun 18 14:31 worktree
```
