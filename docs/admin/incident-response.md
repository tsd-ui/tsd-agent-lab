# Incident Response

Severity levels, response steps, and report template for agent workflow incidents.

## Severity Levels

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

## Incident Response Steps

### 1. Immediate Response (< 5 minutes)

**For Critical/High Severity:**

1. **STOP EVERYTHING**

   ```bash
   killall -u agent-lab
   gh auth logout
   ```

2. **Contain the damage**
   - Revoke compromised tokens
   - Close any unexpected PRs
   - Notify team lead

3. **Preserve evidence**
   - Copy logs to a safe location
   - Screenshot error messages
   - Note exact time of incident

### 2. Assessment (< 30 minutes)

1. **What happened?** — Review workflow logs, check git history, examine system logs
2. **What's the impact?** — Which repositories affected? Was any sensitive data exposed? Who needs to be notified?
3. **Root cause?** — Policy gap? Human error? Tool bug? Malicious input?

### 3. Remediation (< 2 hours)

1. **Fix the immediate issue** — Revert bad commits, delete exposed secrets, restore from backup if needed
2. **Close the vulnerability** — Update policies, fix broken allowlists, patch tool configuration
3. **Verify the fix** — Test that the issue can't recur, confirm policies are enforced

### 4. Documentation (< 24 hours)

1. **Write incident report** — Use template below, be thorough and honest
2. **Share with team** — Post in team channel, schedule retro if major incident
3. **Update policies** — Incorporate learnings, add new controls, test changes

## Incident Report Template

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

## Lessons Learned
- **What went wrong**: [List]
- **What went right**: [List]
- **What we'll change**: [List]

## Action Items
- [ ] [Action item 1] - Owner: [Name] - Due: [Date]

## References
- Workflow log: `logs/[workflow-id].log`
- Related PRs: [Links]
- Slack thread: [Link]
```

## Contact Points

- **Security issues**: Your security team contact
- **Policy questions**: Tech lead
- **Tool support**: Tool-specific support channel
- **General questions**: `#agent-lab` Slack channel

**Immediate escalation (< 5 min):** Security incident, credential exposure, production impact.
**Same-day escalation:** Policy violation, repeated failures, tool malfunction.
**Next meeting escalation:** Policy improvement ideas, documentation unclear, feature requests.
