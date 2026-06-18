---
aliases: 
tags: [agent-lab]
---
# Operator Rules and Guidelines

## Overview

This document defines the operational guidelines for team members running agent workflows in the TSD Agent Lab. These rules ensure safe, auditable, and productive use of agentic coding tools.

**Target Audience**: Software engineers operating the agent lab
**Scope**: Local agent workflows (Claude Code, Superpowers, OpenCode)
**Last Updated**: 2026-06-12

## Core Responsibilities

### As an Agent Operator, You Are Responsible For

1. **Safety First**
   - Never expose production credentials to agent workflows
   - Always verify repository allowlist before starting workflow
   - Review all agent-generated code before merging
   - Stop workflows immediately if unexpected behavior occurs

2. **Audit Trail**
   - Log all workflow executions
   - Document decisions to override policies
   - Report incidents and near-misses
   - Maintain readable commit history

3. **Team Learning**
   - Share successful workflows with team
   - Document failures and lessons learned
   - Contribute to policy improvements
   - Help onboard new operators

4. **Compliance**
   - Follow organization security policies
   - Respect cross-org boundaries
   - Maintain proper access controls
   - Protect intellectual property

## Pre-Flight Checklist

**Complete this checklist before EVERY workflow execution:**

### 1. Environment Verification

- [ ] **Logged in as agent user** (not your primary account)

  ```bash
  whoami  # Should output: tsd-agent (or your agent username)
  ```

- [ ] **No production credentials in environment**

  ```bash
  env | grep -E '(AWS|GCP|AZURE|DATABASE|PROD)'  # Should be empty
  ```

- [ ] **Working directory is appropriate**

  ```bash
  pwd  # Should be in ~/tsd-agent-lab or allowlisted repo
  ```

### 2. Repository Verification

- [ ] **Target repository is in allowlist**
  - Check `policies/repo-allowlist.yaml`
  - Confirm organization and repository name match exactly
  - Verify access level (read-only vs read-write)

- [ ] **Repository is not production**
  - Name does not contain: `production`, `prod`, `customer`, `pii`
  - Confirmed with team that repo is safe for experimentation

- [ ] **Correct organization context**
  - If working across multiple orgs, confirm you're in the right one
  - No cross-org work unless explicitly approved

### 3. Policy Verification

- [ ] **Policies are up to date**

  ```bash
  cd ~/tsd-agent-lab
  git pull origin main
  ```

- [ ] **Policy files exist**
  - `policies/default-policy.yaml`
  - `policies/repo-allowlist.yaml`
  - `policies/command-allowlist.yaml`

- [ ] **Organization-specific policies reviewed**
  - If applicable, check org-specific sections in allowlists

### 4. Workflow Planning

- [ ] **Workflow purpose documented**
  - Write a one-sentence description in workflow log
  - Example: "Testing agent's ability to add unit tests to demo-app"

- [ ] **Expected outcome defined**
  - What should the workflow produce?
  - How will you verify success?

- [ ] **Time budget set**
  - How long should this take?
  - When will you abort if stuck?

- [ ] **Review plan ready**
  - Who will review the PR?
  - What should they look for?

### 5. Tool Verification

- [ ] **Tool version confirmed**

  ```bash
  # For Claude Code:
  claude --version
  
  # For Superpowers (when available):
  superpowers --version
  ```

- [ ] **Tool configuration reviewed**
  - Check `~/.claude/` or equivalent config directory
  - Verify API keys are lab-scoped (not production)

### 6. Ready to Start

- [ ] All checklist items above completed
- [ ] You have 30+ minutes of uninterrupted time
- [ ] You know how to stop the workflow if needed

**If any item is unchecked or uncertain, STOP and resolve before proceeding.**

## During Workflow Execution

### Active Monitoring

**Do:**
- Watch command execution in real-time
- Review file modifications as they happen
- Check for unexpected repository access attempts
- Monitor resource usage (CPU, memory, disk)

**Don't:**
- Walk away from an active workflow
- Ignore warnings or confirmation prompts
- Approve operations you don't understand
- Skip reading command outputs

### Handling Confirmations

When the agent requests confirmation (e.g., "Push to origin?"):

1. **Pause and read the prompt carefully**
   - What operation is being requested?
   - What are the consequences?

2. **Verify the operation is expected**
   - Does this align with workflow goals?
   - Is the target correct (branch, repository, file)?

3. **Check for red flags**
   - Force push to protected branch
   - Access to repository not in allowlist
   - Large number of files deleted
   - Unexpected network operations

4. **Decision matrix**:
   - **Approve**: Operation is expected and safe
   - **Deny**: Operation is unexpected or risky
   - **Abort**: Something is wrong; stop the entire workflow

### Emergency Stop

**Stop the workflow immediately if:**
- Agent attempts to access production repository
- Unexpected credential prompts appear
- Large-scale destructive operations proposed
- System becomes unresponsive
- You see evidence of credential leakage

**How to stop:**
1. Press `Ctrl+C` to interrupt the agent process
2. Kill all agent processes:

   ```bash
   killall -u tsd-agent
   ```

3. Review logs to understand what happened
4. Document incident before cleanup

## Post-Execution Review

**Complete within 30 minutes of workflow completion:**

### 1. Process Review

- [ ] **Workflow completed or aborted cleanly**
  - No hanging processes:

    ```bash
    ps aux | grep tsd-agent
    ```

  - No unexpected background jobs

- [ ] **Logs captured**
  - Workflow log exists in `logs/` directory
  - Timestamp and outcome recorded

### 2. Output Review

- [ ] **Files modified are expected**

  ```bash
  git status
  git diff
  ```

- [ ] **No sensitive files created**
  - Check for `.env`, `.pem`, `.key`, `credentials.*` files
  - Run secret scanner if available

- [ ] **File sizes are reasonable**
  - No unexpectedly large files
  - No binary blobs (unless intentional)

### 3. Code Review (Before Creating PR)

- [ ] **Read every line of changed code**
  - Understand what it does
  - Verify it solves the intended problem

- [ ] **Security check**
  - No hardcoded secrets or tokens
  - No SQL injection vulnerabilities
  - No command injection opportunities
  - No XSS vulnerabilities
  - Input validation present where needed

- [ ] **Quality check**
  - Code follows project conventions
  - Tests added or updated (if applicable)
  - Documentation updated (if applicable)
  - No obvious bugs or logic errors

- [ ] **Diff review**
  - Only intended files changed
  - No unrelated changes bundled in
  - Commit messages are clear

### 4. Allowlist Compliance

- [ ] **No allowlist violations in logs**

  ```bash
  grep -i "violation" logs/latest-workflow.log
  ```

- [ ] **All repository access was authorized**
  - Check log for `git clone`, `gh repo view` commands
  - Verify each repository is in allowlist

- [ ] **All commands were authorized**
  - Review executed commands
  - Flag any that seem unexpected

### 5. Incident Check

- [ ] **No security events occurred**
  - No credential access attempts
  - No production system contact
  - No policy violations

- [ ] **If issues occurred, documented**
  - What happened?
  - Why did it happen?
  - How was it resolved?
  - How can we prevent it?

## Pull Request Creation

### PR Preparation

Before creating a PR from agent-generated code:

- [ ] **Branch naming follows convention**
  - Format: `agent/short-description` or org-specific format
  - Example: `agent/add-unit-tests-to-demo`

- [ ] **Commits are clean**
  - Squash if many tiny commits
  - Keep if each commit is logical unit
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

- **Always create as draft first**
  - Convert to "Ready for Review" only after your own review
  - Gives you time to catch issues before bothering reviewers
- **Request reviewers explicitly**
  - Don't rely on auto-assignment
  - Ping on Slack if urgent
- **Never merge your own agent PRs**
  - Even if you have permission
  - Second pair of eyes is critical

## Code Review as Reviewer

If you're reviewing an agent-generated PR:

### Review Checklist

- [ ] **PR template is complete**
  - All sections filled out
  - Testing described
  - Risks documented

- [ ] **Workflow logs available**
  - Log file exists and is readable
  - No violations or incidents in log

- [ ] **Code quality acceptable**
  - Follows project conventions
  - No obvious bugs
  - Reasonable approach

- [ ] **Security review completed**
  - No secrets in code
  - No vulnerabilities introduced
  - No suspicious patterns

- [ ] **Testing adequate**
  - Tests pass (if CI exists)
  - Manual testing described
  - Edge cases considered

- [ ] **Scope appropriate**
  - PR does one thing
  - No unrelated changes
  - Size is reviewable (< 500 lines ideal)

### Review Mindset

**Remember:**
- Agent code is **untrusted by default**
- Agents can make subtle mistakes humans might miss
- Agents don't understand business context like humans do
- When in doubt, ask questions or request changes

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

**Approve if:**
- All checklist items pass
- You understand what the code does
- You'd be comfortable maintaining this
- Security review shows no issues

**Request changes if:**
- Bugs or vulnerabilities found
- Code quality below standards
- Testing insufficient
- Risks not adequately addressed

**Reject if:**
- Security issues present
- Fundamentally wrong approach
- Out of scope for original workflow

## Policy Overrides

Occasionally you may need to override a policy (e.g., access repository not in allowlist for one-time experiment).

### When Overrides Are Acceptable

- One-time emergency fix
- Temporary access for specific experiment
- Policy is outdated and fix is pending
- False positive block

### Override Process

1. **Document justification**
   - Why is override needed?
   - What is the risk?
   - Is there an alternative?

2. **Get approval**
   - Ask tech lead or security contact
   - Document approval (Slack link, email, etc.)

3. **Execute with caution**
   - Extra vigilant during override
   - Manual review of all operations
   - Detailed logging

4. **Log the override**
   - Record in `logs/allowlist-overrides.jsonl`
   - Include: date, operator, reason, approver, outcome

5. **Follow up**
   - Update policy if needed
   - Remove temporary access
   - Share lesson with team

### Override Log Format

```json
{
  "timestamp": "2026-06-12T14:30:00Z",
  "operator": "alice",
  "override_type": "repository_allowlist",
  "resource": "example-org/temporary-repo",
  "reason": "One-time fix for critical customer bug",
  "approved_by": "tech-lead-bob",
  "approval_ref": "https://slack.com/archives/...",
  "outcome": "success",
  "duration_hours": 2,
  "notes": "Added to allowlist afterward for future use"
}
```

## Incident Response

### Severity Levels

**Critical (P0)**
- Production credentials exposed
- Malicious code merged
- Data exfiltration detected
- Unauthorized repository access to production

**High (P1)**
- Protected branch force-pushed
- Large-scale allowlist violation
- Agent process won't terminate
- Secret detected in PR

**Medium (P2)**
- Policy override needed frequently
- Workflow repeatedly failing
- Unexpected agent behavior
- Resource exhaustion

**Low (P3)**
- Policy needs updating
- Documentation unclear
- Workflow timeout
- Minor bug in agent output

### Incident Response Steps

#### 1. Immediate Response (< 5 minutes)

**For Critical/High Severity:**

1. **STOP EVERYTHING**

   ```bash
   # Kill all agent processes
   killall -u tsd-agent
   
   # Log out of GitHub
   gh auth logout
   ```

2. **Contain the damage**
   - Revoke compromised tokens
   - Close any unexpected PRs
   - Notify team lead

3. **Preserve evidence**
   - Copy logs to safe location
   - Screenshot error messages
   - Note exact time of incident

#### 2. Assessment (< 30 minutes)

1. **What happened?**
   - Review workflow logs
   - Check git history
   - Examine system logs

2. **What's the impact?**
   - Which repositories affected?
   - Was any sensitive data exposed?
   - Who needs to be notified?

3. **Root cause?**
   - Policy gap?
   - Human error?
   - Tool bug?
   - Malicious input?

#### 3. Remediation (< 2 hours)

1. **Fix the immediate issue**
   - Revert bad commits
   - Delete exposed secrets
   - Restore from backup if needed

2. **Close the vulnerability**
   - Update policies
   - Fix broken allowlists
   - Patch tool configuration

3. **Verify the fix**
   - Test that issue can't recur
   - Confirm policies enforced
   - Review related systems

#### 4. Documentation (< 24 hours)

1. **Write incident report**
   - Use template below
   - Be thorough and honest
   - Include lessons learned

2. **Share with team**
   - Post in team channel
   - Schedule retro if major incident
   - Update runbooks

3. **Update policies**
   - Incorporate learnings
   - Add new controls if needed
   - Test changes

### Incident Report Template

```markdown
# Incident Report: [Brief Title]

**Date**: [YYYY-MM-DD]
**Severity**: [Critical / High / Medium / Low]
**Operator**: [Your name]
**Tool**: [Claude Code / Superpowers / OpenCode]

## Summary
[2-3 sentence summary of what happened]

## Timeline
- **[HH:MM]**: Workflow started
- **[HH:MM]**: Incident detected
- **[HH:MM]**: Response initiated
- **[HH:MM]**: Incident contained
- **[HH:MM]**: Incident resolved

## What Happened
[Detailed description of the incident]

## Root Cause
[Why did this happen?]

## Impact
- Repositories affected: [List]
- Data exposed: [Yes/No, details]
- Production impact: [Yes/No, details]
- People notified: [List]

## Response Actions Taken
1. [Action 1]
2. [Action 2]
3. [...]

## Lessons Learned
- **What went wrong**: [List]
- **What went right**: [List]
- **What we'll change**: [List]

## Action Items
- [ ] [Action item 1] - Owner: [Name] - Due: [Date]
- [ ] [Action item 2] - Owner: [Name] - Due: [Date]

## References
- Workflow log: `logs/[workflow-id].log`
- Related PRs: [Links]
- Slack thread: [Link]
```

## Best Practices

### Do's

✅ **Start small**
- Begin with simple, low-risk workflows
- Gradually increase complexity as you gain confidence

✅ **Review everything**
- Never trust agent output blindly
- Read every line of generated code
- Understand before approving

✅ **Document decisions**
- Keep workflow logs
- Write clear commit messages
- Explain why, not just what

✅ **Share knowledge**
- Tell team about successful workflows
- Document failures and fixes
- Contribute to policy improvements

✅ **Ask for help**
- Unsure about a policy? Ask.
- Weird agent behavior? Ask.
- Security concern? Ask immediately.

✅ **Test thoroughly**
- Run tests if they exist
- Manual testing for UI/UX changes
- Check edge cases

### Don'ts

❌ **Don't skip checklists**
- Pre-flight checklist is not optional
- Post-execution review is mandatory
- Shortcuts lead to incidents

❌ **Don't merge without review**
- Even "small" changes need human eyes
- Even if you're confident it's correct
- Even if you're in a hurry

❌ **Don't expose credentials**
- Never run workflows with production env vars
- Never commit secrets (even in private repos)
- Never share tokens across users

❌ **Don't ignore warnings**
- Policy violations mean stop and investigate
- Unusual agent behavior warrants pause
- System alerts are not noise

❌ **Don't work in isolation**
- Team should know you're running workflows
- Share results, good and bad
- Coordinate on overlapping work

❌ **Don't override policies casually**
- Overrides are for exceptions only
- Always document and get approval
- Follow up to fix root cause

## Training and Onboarding

### New Operator Onboarding

Before your first workflow:

1. **Read all documentation**
   - This document (operator-rules.md)
   - Threat model (docs/threat-model.md)
   - Safety model (docs/safety-model.md)
   - Implementation plan (docs/implementation-plan.md)

2. **Review policies**
   - default-policy.yaml
   - repo-allowlist.yaml
   - command-allowlist.yaml

3. **Pair with experienced operator**
   - Watch them run a workflow
   - Ask questions
   - Run your first workflow together

4. **Complete training workflow**
   - Checklist: Create a simple test PR in `demo-app`
   - Practice emergency stop
   - Practice incident reporting

5. **Get sign-off**
   - Team lead confirms you're ready
   - You have access to agent user account
   - You're added to #agent-lab Slack channel

### Ongoing Training

- **Monthly**: Review incident reports
- **Quarterly**: Policy refresh training
- **Annually**: Full security review

## Metrics and Reporting

### Weekly Self-Check

Track your own performance:
- Workflows run: [Count]
- PRs created: [Count]
- PRs merged: [Count]
- Policy violations: [Count] (should be 0)
- Overrides used: [Count]
- Incidents: [Count] (hopefully 0)

### Monthly Team Review

Team discusses:
- What workflows worked well?
- What workflows failed?
- Policy changes needed?
- Tool improvements?
- Training gaps?

## Questions and Support

### Resources

- **Documentation**: `tsd-agent-lab/docs/`
- **Policies**: `tsd-agent-lab/policies/`
- **Logs**: `tsd-agent-lab/logs/`
- **Slack**: `#agent-lab` channel

### When to Escalate

**Immediate escalation (< 5 min):**
- Security incident
- Credential exposure
- Production impact

**Same-day escalation:**
- Policy violation
- Repeated failures
- Tool malfunction

**Next meeting escalation:**
- Policy improvement ideas
- Documentation unclear
- Feature requests

### Contact Points

- **Security issues**: [Your security team contact]
- **Policy questions**: [Tech lead]
- **Tool support**: [Tool-specific support channel]
- **General questions**: `#agent-lab` Slack channel

---

**Remember**: The goal is safe, productive experimentation. When in doubt, be conservative. It's better to stop and ask than to cause an incident.

These rules will evolve based on team experience. Propose improvements via PR to this document.

**Last Updated**: 2026-06-12
**Next Review**: 2026-07-12
**Owner**: Engineering Team
