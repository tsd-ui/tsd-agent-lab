# TSD Agent Lab

This repository is a local agentic SDLC lab for a small software engineering team.

## Core Principles

- This is a local experimentation lab focused on safe agent exploration.
- Work incrementally: read-only analysis first, then patches, then automation.
- Keep changes reviewable and well-documented.
- When uncertain, make a plan first.

## Repository Purpose

- Develop reusable skills and harnesses for agent-assisted development.
- Compare different agent approaches and capabilities.
- Build protocols for safe, effective agent collaboration.
- Document patterns that work well for our team.

## Tech Stack

- Claude Code as primary agent interface
- GitHub for version control
- Obsidian for team knowledge sharing
- Local Mac user environment for isolation
- Future: GCP integration when ready

## Agent Conventions

All agents must follow `policies/agent-conventions.md`. Key rules:

- Use `claude -p` for non-interactive invocations.
- Write files in place — never copy-and-rename (breaks Obsidian tabs).
- Trim trailing whitespace in Markdown files; end with a single newline.
- Use kebab-case for all generated names (tasks, runs, reports, skills).

## Safety Guidelines

- Do not push branches unless explicitly requested.
- Do not store secrets in the repo.
- Do not auto-merge or create automated PR workflows yet.
- Prefer dry-run mode for scripts.
- Prefer simple shell/Node/Python scripts over complex frameworks.
- Update documentation alongside scripts.

## Repository Conventions

- Scripts go under `scripts/`.
- Harness code goes under `harness/`.
- Policies go under `policies/`.
- Protocol experiments go under `protocols/`.
- Skills go under `skills/`.
- Docs go under `docs/`.
- Generated reports go under `reports/`.
- Example tasks go under `examples/tasks/`.
- Phase prompts go under `docs/phases/` as `Phase-N-Prompt.md`.
- Phase summaries go under `docs/phases/` as `Phase-N-Summary.md`.

## Phase Completion Checklist

When completing a phase:

1. Create a summary at `docs/phases/Phase-N-Summary.md` documenting deliverables, verification, and next steps.
2. Update `README.md`: mark the phase checkbox as complete and advance the "Current phase" line.
3. Commit all phase artifacts together.

## Scripts and Automation

- Write scripts in shell, Node, or Python. Keep dependencies minimal.
- Prefer `set -euo pipefail` in shell scripts.
- Include a `--dry-run` flag for scripts that modify state.
- Make scripts idempotent where possible.
- Add usage comments or `--help` output.

## Testing Expectations

- **Shell scripts**: Run `shellcheck` if available. Test with `bash -n` at minimum.
- **Non-trivial logic**: Add unit or integration tests.
- **Setup scripts**: Verify idempotency by running twice.
- **Manual steps**: Document exact commands to verify behavior.

## Verification

- Add or update tests for non-trivial scripts.
- Run `shellcheck` if shellcheck is available.
- Run basic smoke tests.
- Include manual test instructions when automated tests are not practical.
