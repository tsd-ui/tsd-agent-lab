# Phase 12—Team documentation and operating model

This phase turns it into something your team can actually use.

## Prompt 12A—Create team operating model

```markdown
Create a team operating model for the local agent lab.

Create:
- `docs/team-operating-model.md`
- `docs/team-onboarding.md`
- `docs/faq.md`

Cover:
- What this lab is.
- What this lab is not.
- Who may run it.
- Where it may run.
- Which repos are allowed.
- How to choose tasks.
- How to review agent output.
- How to report problems.
- How to compare agents.
- How to avoid violating other GitHub orgs’ processes.
- When to stop an agent run.
- When to escalate to the repo owner.
- When a task should not be given to an agent.

Keep it practical and suitable for a small engineering team.
```

## Prompt 12B—Create demo script for team walkthrough

```markdown
Create a 20-minute team demo script for this local agent lab.

Create:
- `docs/demo/20-minute-demo.md`
- `docs/demo/demo-checklist.md`

The demo should show:
1. The problem we are solving
2. Our progressive approach: local first, cloud later
3. How the safety model works
4. How a read-only task runs
5. How a patch-only task would work
6. How we use Claude Code as our primary agent
7. How we share learnings via Obsidian
8. Our current capabilities and future roadmap
9. How the team can contribute skills/prompts
10. How to compare different agent approaches

Focus on:
- What we ARE building (Claude-based workflows, local harness, team collaboration)
- Why we chose this approach
- How team members can get started
- Practical examples from real usage

Do not assume the audience already understands agentic SDLC.
```
