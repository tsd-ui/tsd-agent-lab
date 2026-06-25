---
aliases: 
tags: 
---
# Phase 5—Skills and Superpowers-style workflows

Claude Code skills are reusable packages with a required `SKILL.md`, plus optional scripts/resources. This provides a way to package task-specific capabilities and reusable workflows that can be shared across the team.

## Prompt 5A—Create initial skills

```markdown
Create initial reusable skills for this agent lab.

Create these directories:
- `skills/codebase-map/`
- `skills/bugfix-minimal/`
- `skills/test-generation/`
- `skills/pr-review/`
- `skills/adr-writer/`

Each skill should include:
- `SKILL.md`
- optional `references/README.md`

Each `SKILL.md` should include:
- name
- description
- when to use
- when not to use
- step-by-step workflow
- expected output
- safety constraints
- verification expectations

Design the skills to be:
- Portable across different agents (Claude Code, Gemini, OpenCode later)
- Well-documented with clear use cases
- Focused on practical team workflows
- Built around what we ARE using (Claude, GitHub, local environment)
- Compatible with Fullsend skill conventions (SKILL.md structure, companion files)

Follow Fullsend's SKILL.md format where practical—same field names (name, description,
when to use, workflow steps, expected output). This avoids a format migration later when
we integrate Fullsend locally. Where Fullsend conventions don't apply (e.g. pre/post-scripts,
sandbox config), note the gap but don't invent placeholders.

For each skill, include a `fullsend_role` note indicating which Fullsend agent role
it maps to (code, review, triage, or quality). This is informational only—it documents
intent for the future hosted lane.

Do not assume a specific framework-specific feature unless clearly marked.
Do not add scripts yet unless truly useful.
Do not install or depend on Fullsend runtime.
```

## Prompt 5B—Add Superpowers compatibility notes

```markdown
Add documentation explaining how this repository should work with Superpowers-style agentic development workflows.

Create:
- `docs/superpowers.md`
- `skills/README.md`

Explain:
- How the skills in this repo map to Superpowers-like workflows
- How to invoke them manually with Claude Code
- How to keep skills portable across different agents
- How to evaluate whether a skill is useful
- How to add a new skill
- How to share skills with the team via Obsidian

Focus on:
- Practical, reusable patterns
- Clear documentation
- Team collaboration
- Progressive enhancement (read-only → patch-only → automation)

Do not install Superpowers.
Do not assume Superpowers is present.
Do not depend on Fullsend runtime, but follow Fullsend skill format conventions where practical.
```
