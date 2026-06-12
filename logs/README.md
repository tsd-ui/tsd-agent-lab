# Logs Directory

This directory stores execution logs and audit trails for all agent operations.

## Purpose

- **Audit trail**: Track all agent commands and operations
- **Debugging**: Investigate issues and unexpected behavior
- **Learning**: Analyze patterns and improve workflows
- **Compliance**: Demonstrate safety controls in operation

## Log Format

Logs use structured JSON-line format for easy parsing:

```json
{"timestamp":"2026-06-12T14:23:45Z","session":"001","user":"tsd-agent","operation":"git_clone","repository":"org/repo","status":"success","duration_ms":1234}
{"timestamp":"2026-06-12T14:24:10Z","session":"001","user":"tsd-agent","operation":"command","command":"npm test","status":"success","exit_code":0}
```

### Required Fields

- `timestamp`: ISO 8601 UTC timestamp
- `session`: Session identifier
- `user`: User/agent identifier
- `operation`: Type of operation
- `status`: success, failure, blocked, etc.

### Optional Fields

- `repository`: Target repository (if applicable)
- `command`: Command executed (if applicable)
- `exit_code`: Command exit code
- `duration_ms`: Operation duration in milliseconds
- `error`: Error message (if failed)
- `context`: Additional context information

## Organization

Logs are organized by date:

```
logs/
├── 2026-06/
│   ├── 2026-06-12-session-001.log
│   ├── 2026-06-12-session-002.log
│   └── 2026-06-13-session-001.log
└── 2026-07/
    └── ...
```

## Retention

- **Minimum**: 90 days
- **Maximum**: Configurable (default 1 year)
- **Archive**: Compress logs older than 30 days

## Security

Logs may contain sensitive information:
- Repository names
- File paths
- Command arguments
- Error messages

**Never commit actual log files to git.**

Logs are excluded via `.gitignore`. Only commit:
- This README
- Log format documentation
- Example log entries (redacted)

## Access

- Logs readable by lab operators
- Automated review tools in Phase 3+
- Weekly manual review recommended
- Incident investigation as needed

## Analysis Tools

Future phases will add:
- Log parsing scripts
- Pattern analysis
- Anomaly detection
- Summary reports

## Privacy

Redact sensitive information before sharing:
- Real repository names
- Internal URLs
- Credentials (should never appear, but check)
- Personal identifiers

Use example names for documentation:
- `org/repo` instead of real org
- `user@example.com` instead of real emails
- `github.com/example/project` for examples
