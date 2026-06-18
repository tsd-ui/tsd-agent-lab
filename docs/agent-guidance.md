# Agent Guidance

Expanded guidance for AI coding agents working in this repository.

## How to Work in This Repo

### Start With Context

Before making changes, read the relevant docs:

1. `CLAUDE.md` at the repo root for conventions and safety rules.
2. `docs/safety-model.md` for the full security model.
3. `docs/operator-rules.md` for operational guidelines.
4. The phase prompt for whatever phase you are implementing (under `docs/phases/`).

### Incremental Approach

Follow this order for any task:

1. **Read** -- Understand existing code, docs, and conventions.
2. **Plan** -- Outline what you intend to change and why.
3. **Patch** -- Make small, reviewable changes.
4. **Verify** -- Run tests, shellcheck, or manual smoke tests.
5. **Document** -- Update docs alongside code changes.

Do not skip straight to editing. If the task is non-trivial, write a plan first.

### Scripts and Automation

- Write scripts in shell, Node, or Python. Keep dependencies minimal.
- Prefer `set -euo pipefail` in shell scripts.
- Include a `--dry-run` flag for scripts that modify state.
- Make scripts idempotent where possible.
- Add usage comments or `--help` output.

### What Agents Should Not Do

- Push to remote branches without explicit human request.
- Store credentials, tokens, or secrets anywhere in the repo.
- Install system packages or use `sudo`.
- Modify files outside this repository.
- Create automated merge or deploy workflows.
- Run long-lived background processes.

### Handling Uncertainty

If you are unsure about:

- **Scope**: Ask before expanding beyond the stated task.
- **Safety**: Default to the more cautious option.
- **Conventions**: Check existing files for patterns before inventing new ones.
- **Dependencies**: Ask before adding new packages or tools.

## File Conventions

| Type | Location | Format |
|------|----------|--------|
| Documentation | `docs/` | Markdown |
| Phase prompts | `docs/phases/` | Markdown |
| Setup guides | `docs/setup/` | Markdown |
| Shell scripts | `scripts/` | Bash with shellcheck |
| Policies | `policies/` | YAML |
| Templates | `templates/` | Varies |
| Example tasks | `examples/tasks/` | Varies |

## Testing Expectations

- **Shell scripts**: Run `shellcheck` if available. Test with `bash -n` at minimum.
- **Non-trivial logic**: Add unit or integration tests.
- **Setup scripts**: Verify idempotency by running twice.
- **Manual steps**: Document exact commands to verify behavior.

## Commit and PR Practices

- Write clear commit messages describing what changed and why.
- Keep commits focused on a single logical change.
- Reference the phase number in commit messages when applicable.
- Do not amend or force-push unless explicitly asked.
