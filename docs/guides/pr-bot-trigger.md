# PR Bot Trigger

Comment `/agent review` on any PR in a monitored repository to trigger an automated code review. The review is posted back as a PR comment.

## How it works

1. **Poll** (`pr-bot-poll.sh`, every 5 min): Discovers `/agent review` comments on PRs, validates the commenter against the allowlist and GitHub association, and writes a queue file.
2. **Worker** (`pr-bot-worker.sh`, every 5 min): Claims the oldest queued request, verifies the PR head SHA hasn't changed, runs `lab-action review-pr`, and posts the formatted review as a PR comment.

Both scripts run as launchd jobs via `run-automation`.

## Authorization

Two checks must pass:

- **Static allowlist**: Commenter must appear in `policies/bot-commenter-allowlist.yaml`
- **GitHub association**: Commenter must be a COLLABORATOR, MEMBER, or OWNER on the repository

## Safety controls

- **Review-only mode**: Agent runs with `--disallowedTools` blocking file mutations, push, PR/issue mutations, and outbound network
- **Cost cap**: `--max-budget-usd 2` per review
- **Rate limiting**: 5 reviews/hour per user, 20 reviews/hour global
- **SHA pinning**: Review aborts if the PR head has changed since the comment was posted
- **Idempotent posting**: Duplicate comments are prevented via HTML comment markers
- **Mention neutralization**: `@usernames` in agent output are wrapped to prevent GitHub notifications

See `docs/architecture/threat-model.md` CT4 for the full threat model.

## Command format

The trigger must appear on its own line, outside code blocks and blockquotes:

```
/agent review
```

Commands inside fenced code blocks, inline code, or blockquotes are ignored.

## Rate limiting

If rate-limited, the bot adds an hourglass reaction to the comment instead of queuing a review. Limits reset each hour.

## Files

| File | Purpose |
|------|---------|
| `scripts/macos/pr-bot-poll.sh` | Discovery and authorization |
| `scripts/macos/pr-bot-worker.sh` | Execution and posting |
| `automations/jobs/pr-bot-poll.yaml` | Poll job definition |
| `automations/jobs/pr-bot-worker.yaml` | Worker job definition |
| `policies/bot-commenter-allowlist.yaml` | Authorized commenters |
| `~/workspaces/runs/.pr-bot-queue/` | Queue directory (one JSON file per request) |
| `~/workspaces/runs/.pr-bot-state.json` | Poll watermarks and rate counters |
| `~/workspaces/runs/.pr-review-state.json` | Review history (consumed by command center) |

## Dry-run and testing

```bash
# See what the poller would find without queuing anything
scripts/macos/pr-bot-poll.sh --detect-only

# Test comment formatting against a sample file
scripts/macos/pr-bot-worker.sh --format-fixture path/to/agent-output.md

# Run a review manually (already exists)
bin/lab-action review-pr owner/repo#123 --dry-run
```

## Job management

```bash
# List all jobs (including pr-bot-poll and pr-bot-worker)
automations/bin/lab-jobs list

# Check job status
automations/bin/lab-jobs status

# Run a job manually
automations/bin/lab-jobs run pr-bot-poll
automations/bin/lab-jobs run pr-bot-worker

# View logs
automations/bin/lab-jobs logs pr-bot-poll
automations/bin/lab-jobs logs pr-bot-worker

# Render plists after changing job definitions
automations/bin/lab-jobs render

# Validate job definitions and plists
automations/bin/lab-jobs validate
```

## Scope

Only `/agent review` is supported via comment triggers. `/agent fix` and `/agent triage` require direct operator invocation and are explicitly out of scope (see `docs/architecture/assumptions-and-non-goals.md`).
