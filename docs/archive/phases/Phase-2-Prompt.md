---
aliases: 
tags: 
---
# Phase 2—Claude global and repo instructions

This phase matters. Claude Code reads `CLAUDE.md` files before doing work, providing both global guidance under `~/.claude` and project-level guidance in repositories.

## Prompt 2A—Create repo-level CLAUDE.md

```markdown
Create the first version of `CLAUDE.md` for this repository.

This repository is a local agentic SDLC lab for a small software engineering team.

The instructions should tell Claude and other coding agents:

Core principles:
- This is a local experimentation lab focused on safe agent exploration
- Work incrementally: read-only analysis first, then patches, then automation
- Keep changes reviewable and well-documented
- When uncertain, make a plan first

Repository purpose:
- Develop reusable skills and harnesses for agent-assisted development
- Compare different agent approaches and capabilities
- Build protocols for safe, effective agent collaboration
- Document patterns that work well for our team

Current tech stack:
- Claude Code as primary agent interface
- GitHub for version control
- Obsidian for team knowledge sharing
- Local Mac user environment for isolation
- Future: GCP integration when ready

Safety guidelines:
- Do not push branches unless explicitly requested
- Do not store secrets in the repo
- Do not auto-merge or create automated PR workflows yet
- Prefer dry-run mode for scripts
- Prefer simple shell/Node/Python scripts over complex frameworks
- Update documentation alongside scripts

Repository conventions:
- Scripts go under `scripts/`.
- Harness code goes under `harness/`.
- Policies go under `policies/`.
- Protocol experiments go under `protocols/`.
- Skills go under `skills/`.
- Docs go under `docs/`.
- Example tasks go under `examples/tasks/`.

Verification:
- Add or update tests for non-trivial scripts.
- Run shellcheck if shellcheck is available.
- Run basic smoke tests.
- Include manual test instructions when automated tests are not practical.

Also create:
- `docs/agent-guidance.md`

Keep it concise but strong.
```

## Prompt 2B—Create a global Claude CLAUDE.md template

```markdown
Create a template file for the dedicated `agent-lab` Mac user’s global Claude instructions.

Create:
- `templates/claude/global-CLAUDE.md`
- `docs/setup/install-claude-global-instructions.md`

The template should be suitable for copying to:

`~/.claude/CLAUDE.md`

It should include:
- Work safely by default
- Focus on local, safe experimentation
- Never use production secrets
- Never push or create PRs unless explicitly asked
- Prefer reading and planning before editing
- Ask before installing dependencies
- Do not use sudo
- Do not modify system settings
- Keep a concise task log
- Summarize changed files and verification steps at the end
- Document what you’re building, not just what you’re avoiding

Also include a short install command snippet in the docs, but do not create a script that overwrites an existing user’s global CLAUDE.md without backup.
```
