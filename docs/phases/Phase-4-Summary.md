# Phase 4 Summary: Runner Mode

**Status:** Complete

## Deliverables

### Sub-phase 4A: Prompt File System

| File | Description |
|------|-------------|
| `prompts/common/safety-preamble.md` | Universal safety rules prepended to every agent prompt |
| `prompts/claude/read-only-codebase-map.md` | Read-only exploration prompt |
| `prompts/claude/bugfix-patch-only.md` | Patch-only bugfix prompt |
| `prompts/claude/review-only.md` | Review-only code review prompt |
| `docs/prompts.md` | Prompt system documentation |

### Sub-phase 4B: Claude Runner Script

| File | Description |
|------|-------------|
| `harness/lib/agent.sh` | Agent invocation library (resolve_prompt_file, compose_prompt, resolve_worktree, run_claude) |
| `harness/run-claude.sh` | Main runner script — composes prompt and invokes `claude -p` |
| `docs/run-claude.md` | Runner documentation |

**Updated files:**
- `harness/lib/common.sh` — added `read_yaml_array` function
- `docs/harness.md` — added run-claude.sh and verify-run.sh to Scripts, agent.sh and verify.sh to Libraries, updated Typical Workflow

### Sub-phase 4C: Verification Step

| File | Description |
|------|-------------|
| `harness/lib/verify.sh` | Verification library (check_command_allowed, run_verification_command, run_verification_suite) |
| `harness/verify-run.sh` | Verification runner — reads commands from task, runs in worktree |
| `docs/verification.md` | Verification documentation |

**Updated files:**
- `harness/write-report.sh` — enhanced report with Agent field, Verification Summary, Known Issues, Next Steps sections
- `examples/tasks/bugfix-patch-only.yaml` — added `prompt_file` reference
- `examples/tasks/read-only-codebase-map.yaml` — added `prompt_file` reference
- `examples/tasks/review-only.yaml` — added `prompt_file` reference

## Verification

- `bash -n` syntax check passed on all new `.sh` files
- `shellcheck` run on all scripts (if available)
- `run-claude.sh --dry-run` tested with example tasks
- `verify-run.sh --dry-run` tested with bugfix task
- `write-report.sh` produces enhanced report format

## Architecture Decisions

- **Prompt composition over templating:** Prompts are plain markdown concatenated by the runner. No template variables or substitution engine. This keeps prompts readable and auditable.
- **`claude -p` via stdin:** The composed prompt is piped via stdin rather than passed as a CLI argument, avoiding shell escaping issues and length limits.
- **Soft policy checks:** `check_command_allowed` warns but does not block in Phase 4. Hard enforcement is deferred to a future phase.
- **Fail-fast verification:** Verification stops on the first failed command. Later commands may depend on earlier ones, and continuing after failure would produce misleading results.

## Next Steps

- **Phase 5:** Skills and workflow experiments — test the runner with real repositories, experiment with Claude Code skills, and compare approaches.
