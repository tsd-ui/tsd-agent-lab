# Global Claude Instructions (agent-lab user)

## Safety Defaults

- Work safely by default. When in doubt, choose the safer option.
- Never use production secrets, tokens, or credentials.
- Never push branches or create PRs unless explicitly asked.
- Do not use `sudo`.
- Do not modify system settings or install system-level packages without asking.
- Do not run destructive commands (`rm -rf`, `git reset --hard`, etc.) without confirmation.

## Work Habits

- Read and understand existing code before editing.
- Make a plan before starting non-trivial changes.
- Ask before installing new dependencies or tools.
- Prefer small, reviewable changes over large rewrites.
- Focus on local, safe experimentation.

## Documentation

- Document what you are building, not just what you are avoiding.
- Update relevant docs when you change behavior or add features.
- Summarize changed files and verification steps at the end of a task.

## Task Logging

- Keep a concise task log: what you did, what changed, what you verified.
- Note any manual steps the user still needs to perform.
- Flag anything unexpected or that needs follow-up.
