---
aliases: []
tags: []
status: ✅ Complete
---
# Phase 0—Discovery and safety boundaries

**Status**: ✅ **COMPLETE**

**Completion Date**: 2026-06-12

**Summary**: Initial repository structure, documentation, and threat model have been established. The lab plan has been created and safety boundaries defined.

---

## Prompt 0A—Create the initial lab plan ✅

```markdown
You are helping me set up a local agentic SDLC lab for my software engineering team.

Our approach:
- **Primary agent**: Claude Code - our main tool for agent-assisted development
- **Team collaboration**: Obsidian for sharing knowledge, learnings, and patterns
- **Version control**: GitHub across multiple orgs (not single-org focused)
- **Environment**: Dedicated non-admin Mac user for isolation and safety
- **Scope**: Local prototype lab focused on experimentation and learning
- **Progressive enhancement**: Start with read-only analysis, then patches, then automation
- **Future possibilities**: GCP integration when ready, Superpowers, OpenCode

Safety principles:
- Human review is the merge gate
- No auto-merge
- No production secrets
- No shared personal GitHub tokens
- No comment-triggered automation
- No long-running daemons yet
- Start local, expand carefully

Task:
Create a repository-level implementation plan for `tsd-agent-lab`.

Produce:
1. A proposed repository structure
2. A phased implementation plan
3. A safety model focused on what we're building, not just preventing
4. A list of assumptions
5. A list of non-goals
6. A first draft of `README.md`
7. A first draft of `docs/adr/0001-local-agent-lab-first.md`

Focus on:
- Building practical, safe workflows with Claude
- Enabling team experimentation and learning
- Creating reusable patterns and skills
- Progressive enhancement from simple to sophisticated
- Clear documentation of what works

Do not install tools, modify machine-level settings, or create Mac users.
Only create or update files inside this repository.
```

## Prompt 0B—Tighten the threat model ✅

```markdown
Review the current repository plan and harden it as if this were a team prototype inside a corporate engineering environment.

Focus on:
- Preventing accidental use of production credentials.
- Preventing comment-triggered abuse.
- Preventing autonomous writes to protected branches.
- Preventing cross-org policy violations.
- Preventing hidden long-running processes.
- Keeping human review as the merge gate.
- Making logs and reports useful for audit/review.

Create or update:
- `docs/threat-model.md`
- `policies/default-policy.yaml`
- `policies/repo-allowlist.example.yaml`
- `policies/command-allowlist.yaml`
- `docs/operator-rules.md`

Constraints:
- Keep it pragmatic.
- This is not a formal security certification exercise.
- Prefer simple controls that a small team can actually follow.
- Include a “known weaknesses” section.
```
