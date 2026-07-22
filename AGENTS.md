# TSD Agent Lab

## Core Principles

- This is a local experimentation lab focused on safe agent exploration.
- Work incrementally: read-only analysis first, then patches, then automation.
- Keep changes reviewable and well-documented.
- When uncertain, make a plan first.

## Agent Conventions

All agents must follow `policies/agent-conventions.md`. Key rules:

- Use `claude -p` for non-interactive invocations.
- Write files in place — never copy-and-rename (breaks Obsidian tabs).
- Trim trailing whitespace in Markdown files; end with a single newline.
- Use kebab-case for all generated names (tasks, runs, reports, skills).
- Every LLM-authored commit uses Conventional Commits formatting and ends with a trailing `Assisted-by: Claude` git trailer.

## Safety Guidelines

- Do not push branches unless explicitly requested.
- Do not store secrets in the repo.
- Do not auto-merge or create automated PR workflows yet.
- Prefer dry-run mode for scripts.
- Prefer simple shell/Node/Python scripts over complex frameworks.
- Update documentation alongside scripts.

## Phase Completion Checklist

When completing a phase:

1. Create a summary at `docs/phases/Phase-N-Summary.md` documenting deliverables, verification, and next steps.
2. Update `README.md`: mark the phase checkbox as complete and advance the "Current phase" line.
3. Commit all phase artifacts together.

