# Daily Command Center

Consolidates the daily health, stale-docs, broken-builds, and PR review reports into a single digest. Produces both a markdown report and a structured JSON summary suitable for downstream consumers (Slack, dashboards).

## What it collects

- **CI / Builds** — failure count, affected repos, and top failure signatures from `reports/broken-builds/current.md`
- **Documentation Health** — stale link and review finding counts from `reports/stale-docs/current.md`
- **System Health** — warning count, failed launchd jobs, disk alerts from `reports/health/current.md`
- **PR Activity** — reviewed PRs from `.pr-review-state.json`, open PR count via `gh` (if available)
- **Action Items** — auto-generated list of things needing human attention
- **Changes Since Yesterday** — diff against the previous day's JSON (new/resolved failures, status changes)

## Next Steps

The command center includes context-aware suggested actions based on the current state of the system. Each suggestion includes a ready-to-run command.

| Condition | Suggested Action | Command |
|-----------|-----------------|---------|
| CI failures > 0 | View broken-builds report | `cat reports/broken-builds/current.md` |
| CI failures > 0 | Re-run CI diagnosis | `./scripts/macos/broken-builds-skill-run.sh --force-rediagnose` |
| Stale docs > 0 | View stale-docs report | `cat reports/stale-docs/current.md` |
| Stale docs > 0 | Run full docs review | `claude -p "Follow skills/stale-docs-check/SKILL.md"` |
| Health warnings > 0 | View health report | `cat reports/health/current.md` |
| Health warnings > 0 | Check launchd status | `launchctl list \| grep tsd-agent-lab` |
| Open PRs > 0 | Review open PRs | `claude -p "Follow skills/pr-review/SKILL.md"` |
| All clear | Check for new PRs | `gh pr list --repo securesign/rhtas-console-ui --state open` |
| All clear | Run a codebase map | `claude -p "Follow skills/codebase-map/SKILL.md"` |
| All clear | Preview digest | `./scripts/macos/daily-command-center.sh --dry-run` |

When no issues are detected, the system suggests proactive actions like checking for new PRs or running a codebase map.

## Overall status

The digest assigns an overall status based on the data:

| Status | Criteria |
|--------|----------|
| Green | No CI failures, no health warnings, no stale doc links |
| Yellow | Any CI failures, health warnings, or stale doc links |
| Red | 10+ CI failures, or 3+ health warnings |

## Manual run

```sh
# Preview to stdout without writing files
./scripts/macos/daily-command-center.sh --dry-run

# Write reports to reports/
./scripts/macos/daily-command-center.sh

# Write reports and post to Slack
./scripts/macos/daily-command-center.sh --post-slack
```

Running twice on the same day overwrites the previous report (idempotent).

## Schedule via launchd

A plist is provided at `scripts/macos/com.tsd-agent-lab.command-center.plist` but is **not auto-loaded**. It runs daily at 06:30, after health (05:00), stale-docs (05:15), and broken-builds (06:00) have completed.
See [schedule.md](schedule.md) for the full pipeline schedule and timezone context.

To enable:

```sh
cp scripts/macos/com.tsd-agent-lab.command-center.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist
```

To disable:

```sh
launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist
rm ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist
```

The agent-lab user must be logged in for launchd user agents to fire (macOS limitation).

## Output

Reports are written to `reports/command-center/`:

- `current.md` — human-readable consolidated report
- `current.json` — structured summary for Slack and other consumers

### Example markdown output

```markdown
# Daily Command Center — 2026-07-13

## Status: 🔴

### Summary

- 20 CI failure(s) across 5 repo(s)
- 18 stale docs finding(s)
- System health: warnings
- 7 PRs reviewed, 0 open across monitored repos

### CI / Builds

20 failure(s) across 5 repo(s)

**securesign/rhtas-console**
- linter / golangci / golangci-lint (logs unavailable)
- openapi / ui-pr (no step-level detail)
**securesign/rhtas-console-ui**
- Deploy to GH Pages / gh-pages / Deploy to GitHub Pages

### Documentation Health

**Summary:** 5 stale findings, 13 for review (mechanical pass only)

### System Health

**Status:** warnings

Warnings:
- Failed job: com.tsd-agent-lab.stale-docs-check-full

### PR Activity

- **7** PRs reviewed (lifetime)
- **0** PRs currently open across monitored repos

### Action Items

- [ ] Review 20 CI failure(s) across 5 repo(s)
- [ ] Fix 5 stale doc link(s)
- [ ] Address 2 system health warning(s)
```

### Example JSON output

```json
{
  "date": "2026-07-13",
  "status": "red",
  "ci": { "failures": 20, "repos_affected": 5, "top_failures": ["..."] },
  "docs": { "findings": 18, "critical": 5 },
  "health": { "status": "warnings", "warnings": ["..."] },
  "prs": { "reviewed": 7, "open": 0 },
  "action_items": ["..."]
}
```

## Slack integration

The `--post-slack` flag calls `scripts/macos/post-to-slack.sh`, which formats the JSON as a Slack Block Kit message and posts it via an incoming webhook. See [slack-integration.md](slack-integration.md) for setup instructions.

## Dependencies

- **Required:** `bash`, reports in `reports/`
- **Optional:** `jq` (for PR state parsing and JSON diff), `gh` (for live open PR count)
- **Graceful fallback:** missing reports or tools produce "not available" sections rather than errors

## Rollback

1. Unload the plist (if scheduled):

   ```sh
   launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist
   rm ~/Library/LaunchAgents/com.tsd-agent-lab.command-center.plist
   ```

2. Delete the scripts:

   ```sh
   rm scripts/macos/daily-command-center.sh
   rm scripts/macos/post-to-slack.sh
   rm scripts/macos/com.tsd-agent-lab.command-center.plist
   ```

3. Delete generated reports:

   ```sh
   rm -rf reports/command-center/
   ```

4. Delete documentation:

   ```sh
   rm docs/admin/command-center.md
   rm docs/admin/slack-integration.md
   ```
