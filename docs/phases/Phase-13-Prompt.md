# Phase 13—Later: controlled GitHub Actions experiment

Only do this once the local lab has proved useful. Claude Code can be integrated with GitHub Actions for CI/CD workflows, but this is deliberately a later step because GitHub automation reintroduces trigger and repo-governance issues.

## Prompt 13A—Design workflow_dispatch-only GitHub Action

```markdown
Design, but do not enable by default, a GitHub Actions experiment for Claude Code.

Constraints:
- No comment triggers
- No issue_comment triggers
- No pull_request_target
- Use workflow_dispatch only
- Read-only review mode first
- Minimal permissions
- No auto-commit
- No auto-merge
- No production secrets
- Must be opt-in per repo
- Must clearly warn that repo owners need to approve use

Create:
- `.github/workflows/claude-read-only-review.example.yml`
- `.github/claude/prompts/review.md`
- `docs/github-actions-experiment.md`

The workflow file should be an example/template, not something we expect to run automatically in this lab repo.

Focus on:
- Safe, manual-trigger-only workflows
- Clear documentation of what it does
- Building on learnings from local experimentation
- Progressive enhancement from local → CI/CD

Include a security notes section explaining why comment triggers are intentionally excluded and why we're starting with workflow_dispatch.
```
