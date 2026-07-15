# Daily Health Report

Automated daily health check for the agent-lab environment. Produces a markdown report summarizing service status, log errors, disk usage, and background processes.

## What it checks

- **Launchd agents** — lists tsd-agent-lab services and their current run/exit status
- **Failed jobs** — flags any tsd-agent-lab launchd jobs with non-zero exit status
- **Log errors** — counts error/fault messages from the last 24 hours (capped at 1000)
- **Disk usage** — reports disk space for all local volumes, warns above 80% capacity
- **Background processes** — lists notable running processes (claude, node, python, fullsend)

## Manual run

```sh
# Print report to stdout without writing a file
./scripts/macos/health-report.sh --dry-run

# Write report to reports/health-YYYY-MM-DD.md
./scripts/macos/health-report.sh
```

Running twice on the same day overwrites the previous report (idempotent).

## Schedule via launchd

A plist is provided at `scripts/macos/com.tsd-agent-lab.health-report.plist` but is **not auto-loaded**. It runs daily at 06:00.

To enable:

```sh
cp scripts/macos/com.tsd-agent-lab.health-report.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.health-report.plist
```

To disable:

```sh
launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.health-report.plist
rm ~/Library/LaunchAgents/com.tsd-agent-lab.health-report.plist
```

The agent-lab user must be logged in for launchd user agents to fire (macOS limitation).

## Output

Reports are written to `reports/health-YYYY-MM-DD.md`. Each report includes:

- Date, host, user, and generation timestamp
- Overall status line (`healthy` or `N warning(s)`)
- Sections for each check with tables and details

### Example output

```markdown
# Agent Lab Health Report

- **Date:** 2026-07-09
- **Host:** agent-lab-mac
- **User:** agent-lab
- **Generated:** 2026-07-09 06:00:03
- **Status:** healthy

## Launchd Agents

No tsd-agent-lab launchd agents registered.

## Failed Jobs

No failed tsd-agent-lab jobs detected.

## Recent Log Errors (Last 24h)

42 errors/faults in the last 24 hours.

## Disk Usage

| Filesystem | Size | Used | Avail | Capacity | Mounted On |
|------------|------|------|-------|----------|------------|
| /dev/disk3s1s1 | 460Gi | 14Gi | 282Gi | 5% | / |
| /dev/disk3s5 | 460Gi | 160Gi | 282Gi | 37% | /System/Volumes/Data |

Threshold: 80%

## Background Processes

No notable background processes running (checked: claude, node, python, fullsend).
```

## Rollback

To fully remove this feature:

1. Unload the plist (if scheduled):

   ```sh
   launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.health-report.plist
   rm ~/Library/LaunchAgents/com.tsd-agent-lab.health-report.plist
   ```

2. Delete the script and plist source:

   ```sh
   rm scripts/macos/health-report.sh
   rm scripts/macos/com.tsd-agent-lab.health-report.plist
   ```

3. Delete generated reports:

   ```sh
   rm -rf reports/
   ```

4. Delete this documentation:

   ```sh
   rm docs/admin/health-report.md
   ```

## Known limitations

- `log show --last 24h` can be slow (30+ seconds) depending on system log volume
- Error count is capped at 1000 entries per run
- launchd user agents require the user to be logged in
- Disk threshold is hardcoded at 80% — edit `DISK_THRESHOLD` in the script to change
