# Policy Overrides

Process and log format for overriding lab policies (e.g., accessing a repo not yet in the allowlist).

## When Overrides Are Acceptable

- One-time emergency fix
- Temporary access for a specific experiment
- Policy is outdated and a fix is pending
- False positive block

## Override Process

1. **Document justification** — Why is the override needed? What is the risk? Is there an alternative?

2. **Get approval** — Ask tech lead or security contact. Document approval (Slack link, email, etc.)

3. **Execute with caution** — Extra vigilant during the override, manual review of all operations, detailed logging

4. **Log the override** — Record in `logs/allowlist-overrides.jsonl` using the format below

5. **Follow up** — Update policy if needed, remove temporary access, share lessons with team

## Override Log Format

Record every override in `logs/allowlist-overrides.jsonl`:

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

## Reminder

Overrides are exceptions, not shortcuts. Always document and get approval. Follow up to fix the root cause so the same override isn't needed again.
