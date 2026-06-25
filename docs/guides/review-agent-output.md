# Review Agent Output

How to create a PR from agent-generated code and how to review one as a code reviewer.

## As the Operator: Creating a PR

### PR Preparation

Before creating a PR from agent-generated code:

- [ ] **Branch naming follows convention**
  - Format: `agent/short-description` or org-specific format
  - Example: `agent/add-unit-tests-to-demo`

- [ ] **Commits are clean**
  - Squash if many tiny commits
  - Keep if each commit is a logical unit
  - Rewrite commit messages if unclear

- [ ] **PR description is complete**
  - What problem does this solve?
  - What approach did the agent take?
  - Any risks or concerns?
  - Testing completed

### Required PR Template

Use this template for all agent-generated PRs:

```markdown
## Summary
[One-sentence description of change]

## Context
- **Workflow tool**: [Claude Code / Superpowers / OpenCode]
- **Workflow date**: [YYYY-MM-DD]
- **Operator**: [Your name]
- **Workflow purpose**: [Why you ran this workflow]

## Changes
- [Bulleted list of key changes]
- [Be specific about what was modified]

## Testing
- [ ] [How you tested this]
- [ ] [What edge cases you checked]
- [ ] [Any manual verification performed]

## Security Review
- [ ] No hardcoded secrets
- [ ] No new vulnerabilities introduced
- [ ] Input validation appropriate
- [ ] No credential exposure risk

## Risks and Concerns
[Any issues or uncertainties]

## Review Guidance
[What should reviewers pay special attention to?]

---
🤖 Generated with: [Tool Name]
📋 Workflow log: `logs/[workflow-id].log`
```

### PR Labels

Apply these labels to every agent-generated PR:

- `agent-generated` (required)
- `needs-review` (required)
- Tool-specific: `claude-code`, `superpowers`, or `opencode`
- Size: `size/S`, `size/M`, `size/L`, `size/XL`
- Type: `enhancement`, `bugfix`, `refactor`, `docs`, `test`

### PR Settings

- **Always create as draft first** — convert to "Ready for Review" only after your own review
- **Request reviewers explicitly** — don't rely on auto-assignment; ping on Slack if urgent
- **Never merge your own agent PRs** — second pair of eyes is critical, even if you have permission

---

## As the Reviewer: Code Review Checklist

### Review Checklist

- [ ] **PR template is complete** — all sections filled, testing described, risks documented

- [ ] **Workflow logs available** — log file exists and is readable, no violations in log

- [ ] **Code quality acceptable** — follows project conventions, no obvious bugs, reasonable approach

- [ ] **Security review completed** — no secrets in code, no vulnerabilities, no suspicious patterns

- [ ] **Testing adequate** — tests pass (if CI), manual testing described, edge cases considered

- [ ] **Scope appropriate** — PR does one thing, no unrelated changes, size is reviewable (< 500 lines ideal)

### Review Mindset

Agent code is **untrusted by default**. Agents can make subtle mistakes humans miss, and they don't understand business context.

**Look for:**
- **Correctness**: Does it actually work?
- **Security**: Are there vulnerabilities?
- **Maintainability**: Can humans understand and modify this later?
- **Completeness**: Are there missing edge cases?

**Red flags:**
- Obfuscated or overly complex code
- Patterns you've never seen in your codebase
- Comments that don't match the code
- Magic numbers or hardcoded values
- Missing error handling

### Approval Decision

**Approve if:** All checklist items pass, you understand what the code does, you'd be comfortable maintaining it, security review shows no issues.

**Request changes if:** Bugs or vulnerabilities found, code quality below standards, testing insufficient, risks not adequately addressed.

**Reject if:** Security issues present, fundamentally wrong approach, out of scope for original workflow.
