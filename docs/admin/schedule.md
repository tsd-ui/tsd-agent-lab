---
aliases: 
tags: 
---
# Daily Report Pipeline Schedule

The Mac running the agent-lab pipeline is set to BST (UTC+1). Times below also show CEST (UTC+2) for c[]()olleagues in Europe.

## Pipeline

| BST   | CEST  | Job                          | Plist label                                | Duration    |
|-------|-------|------------------------------|--------------------------------------------|-------------|
| 05:00 | 06:00 | Health Report                | `com.tsd-agent-lab.health-report`          | ~1 min      |
| 05:15 | 06:15 | Stale Docs (mechanical)      | `com.tsd-agent-lab.stale-docs-check`       | ~1 min      |
| 05:20 | 06:20 | Stale Docs (full/semantic)   | `com.tsd-agent-lab.stale-docs-check-full`  | ~10-15 min  |
| 05:45 | 06:45 | PR Risk Triage               | `com.tsd-agent-lab.pr-risk-triage`         | ~5-10 min   |
| 06:00 | 07:00 | Broken Builds                | `com.tsd-agent-lab.broken-builds`          | ~15-20 min  |
| 06:30 | 07:30 | Command Center               | `com.tsd-agent-lab.command-center`         | ~10-15 min  |
| Every 10 min | --    | Sync & Push            | `com.tsd-agent-lab.sync-and-push`          | ~30s        |
| Sunday 04:00 | 05:00 | Log Rotation             | `com.tsd-agent-lab.rotate-logs`            | ~1 min      |

Pipeline completes by approximately 06:45 BST / 07:45 CEST, with a 15-minute buffer before any downstream consumers need the data.

## Job dependencies

The Command Center job is the final aggregation step. It reads from:

- `reports/health/current.md`
- `reports/stale-docs/current.md`
- `reports/broken-builds/current.md`
- `reports/pr-triage/current.md`

Health Report, Stale Docs, Broken Builds, and PR Risk Triage must finish before
Command Center runs. The schedule above enforces this through staggered start
times.

The Sync & Push job runs independently on a 10-minute interval, committing and
pushing all changes to git.

The Command Center job runs with `--post-slack` enabled, posting a daily digest
to the `#tsd-agent-lab` Slack channel after generating the report.

## Checking status

```
launchctl list | grep tsd-agent-lab
```

A `0` exit status in the output means the last run succeeded. A non-zero value
indicates the last run failed.

## Reloading after schedule changes

The source of truth for plist files is `scripts/macos/com.tsd-agent-lab.*.plist`
in the repo. After editing times or other plist settings:

```bash
# Unload the old versions
launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.*.plist

# Copy updated plists from the repo
cp scripts/macos/com.tsd-agent-lab.*.plist ~/Library/LaunchAgents/

# Load the new versions
launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.*.plist
```

## Important: GUI login requirement

The agent-lab user account must be GUI-logged-in (via Fast User Switching) for
LaunchAgents to fire. Background-only sessions and SSH sessions are not
sufficient -- macOS only runs LaunchAgents for users with an active GUI session.
