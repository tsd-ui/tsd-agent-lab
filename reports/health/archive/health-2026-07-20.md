# Agent Lab Health Report

- **Date:** 2026-07-20
- **Host:** ryordan-mac
- **User:** agent-lab
- **Generated:** 2026-07-20 05:14:46
- **Status:** 2 warning(s)

## Launchd Agents

| Status | Last Exit | Label |
|--------|-----------|-------|
| not running | 0 | com.tsd-agent-lab.sync-and-push |
| running (PID 93152) | 0 | com.tsd-agent-lab.health-report |
| not running | 1 | com.tsd-agent-lab.stale-docs-check-full |
| not running | 1 | com.tsd-agent-lab.broken-builds |
| not running | 0 | com.tsd-agent-lab.stale-docs-check |
| not running | 0 | com.tsd-agent-lab.command-center |

## Failed Jobs

The following jobs had non-zero exit status on their last run:

| Exit Code | Label |
|-----------|-------|
| 1 | com.tsd-agent-lab.stale-docs-check-full |
| 1 | com.tsd-agent-lab.broken-builds |

## Recent Log Errors (Last 24h)

No errors or faults in the last 24 hours.

## Disk Usage

| Filesystem | Size | Used | Avail | Capacity | Mounted On |
|------------|------|------|-------|----------|------------|
| /dev/disk3s1s1 | 926Gi | 12Gi | 805Gi | 2% | / |
| /dev/disk3s6 | 926Gi | 20Ki | 805Gi | 1% | /System/Volumes/VM |
| /dev/disk3s2 | 926Gi | 8.5Gi | 805Gi | 2% | /System/Volumes/Preboot |
| /dev/disk3s4 | 926Gi | 3.0Mi | 805Gi | 1% | /System/Volumes/Update |
| /dev/disk1s2 | 550Mi | 6.0Mi | 530Mi | 2% | /System/Volumes/xarts |
| /dev/disk1s1 | 550Mi | 5.9Mi | 530Mi | 2% | /System/Volumes/iSCPreboot |
| /dev/disk1s3 | 550Mi | 3.0Mi | 530Mi | 1% | /System/Volumes/Hardware |
| /dev/disk3s5 | 926Gi | 99Gi | 805Gi | 11% | /System/Volumes/Data |

Threshold: 80%

## Background Processes

| PID | Elapsed | Command |
|-----|---------|---------|
| 76056 | 03-17:43:33 | /Users/agent-lab/.vscode-server/cli/servers/Stable-125df4672b8a6a34975303c6b0baa124e560a4f7/server/node |
| 76066 | 03-17:43:30 | /Users/agent-lab/.vscode-server/cli/servers/Stable-125df4672b8a6a34975303c6b0baa124e560a4f7/server/node |
| 76344 | 03-17:43:27 | /Users/agent-lab/.vscode-server/cli/servers/Stable-125df4672b8a6a34975303c6b0baa124e560a4f7/server/node |
| 76345 | 03-17:43:27 | /Users/agent-lab/.vscode-server/cli/servers/Stable-125df4672b8a6a34975303c6b0baa124e560a4f7/server/node |
| 76360 | 03-17:43:23 | /Users/agent-lab/.vscode-server/cli/servers/Stable-125df4672b8a6a34975303c6b0baa124e560a4f7/server/node |
| 77080 | 03-17:43:11 | /Users/agent-lab/.vscode-server/cli/servers/Stable-125df4672b8a6a34975303c6b0baa124e560a4f7/server/node |
| 59146 | 02-16:30:59 | claude |
