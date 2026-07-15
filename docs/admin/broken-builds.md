# Broken Builds

## What It Does

A daily automation that checks recent CI workflow runs on the default branch of allowlisted repos, collects failure data into a structured JSON bundle, and uses a semantic skill to diagnose root causes. The architecture has two layers:

1. **Collector layer** (`collectors/<system>/collect.sh`) — queries CI systems and produces a structured JSON bundle conforming to `schemas/broken-builds-data.schema.json`. Currently implements GitHub Actions; Konflux has a stub for future use.
2. **Skill layer** (`skills/broken-builds/SKILL.md`) — consumes the JSON bundle, diagnoses each unique failure with explicit confidence levels, and produces a markdown report that separates observed evidence from model-authored conclusions.

This separation means additional CI systems can be added by writing a new collector without changing the skill.

## How to Run Manually

```bash
# Full run (collect + diagnose, writes report)
./scripts/macos/broken-builds-skill-run.sh

# Dry run (prints report to stdout, doesn't write files)
./scripts/macos/broken-builds-skill-run.sh --dry-run

# Run just the collector (produces JSON bundle only)
./collectors/github-actions/collect.sh

# Collector dry run (prints JSON to stdout)
./collectors/github-actions/collect.sh --dry-run
```

## How to Regenerate the Repo Inventory

The list of repos to check comes from `policies/generated/repo-inventory.txt`, generated from `policies/repo-allowlist.yaml`:

```bash
./scripts/macos/generate-repo-inventory.sh
```

The skill runner checks if the inventory is missing or stale (older than the allowlist) and regenerates it automatically. You can also run the generator manually after editing `repo-allowlist.yaml`.

## Scheduling

A launchd plist is provided at `scripts/macos/com.tsd-agent-lab.broken-builds.plist` but is **not auto-loaded**. It runs daily at 07:00, staggered after the health report (06:00) and stale-docs check (06:15/06:20). Like the other agent-lab automations, this is a per-user LaunchAgent — it must be installed and loaded while logged in as `agent-lab` (via `su agent-lab` or Fast User Switching); the agent-lab user must be logged in for it to fire (macOS limitation).

To enable:

```bash
cp scripts/macos/com.tsd-agent-lab.broken-builds.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.tsd-agent-lab.broken-builds.plist
```

To disable:

```bash
launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.broken-builds.plist
rm ~/Library/LaunchAgents/com.tsd-agent-lab.broken-builds.plist
```

To check status:

```bash
launchctl list | grep broken-builds
```

The plist runs at 07:00, offset from the health report (06:00) and stale docs check (06:15).

## Intermediate JSON Contract

The collector produces a JSON bundle (`broken-builds-data-YYYY-MM-DD.json`) conforming to the schema at `schemas/broken-builds-data.schema.json`. This is the only interface between the collector and skill layers.

Key fields:
- `schema_version`: always "1"
- `collector`: identifies the CI system ("github-actions" or "konflux")
- `repos[].collection_status`: "ok", "error", or "timeout"
- `repos[].failures[].signature`: dedup key as `repo::workflow::job::step::normalized_error`
- `repos[].failures[].recurrence`: count and first_seen for recurring failures

## Output

Reports are written to `reports/broken-builds-YYYY-MM-DD.md`.

Each report includes:
- Header table (date, host, user, timestamp, status)
- Summary line: "N failure(s) across M repo(s)" or "All builds passing"
- Findings grouped by repo, each with:
  - Observed evidence (verbatim from CI)
  - Diagnosis (model assessment with category and confidence level)
  - Suggested next step
  - Reproduction status

### Finding Categories
| Category | Description |
|---|---|
| `flaky-test` | Test that fails intermittently |
| `dependency-issue` | Network or registry failure fetching dependencies |
| `code-bug` | Compilation error or type error in source |
| `infra-problem` | Permissions, tokens, or infrastructure failure |
| `config-error` | Malformed workflow YAML or configuration |
| `unknown` | Insufficient evidence to categorize |

### Confidence Levels
| Level | Meaning |
|---|---|
| `confirmed` | Evidence directly supports the diagnosis |
| `probable` | Strong evidence, minor uncertainty |
| `possible` | Some evidence, significant uncertainty |
| `insufficient-evidence` | Logs too opaque to diagnose reliably |

## Resource Limits

All limits are tuneable constants at the top of the collector script:

| Limit | Default | Purpose |
|---|---|---|
| Max failed runs per repo | 5 | Caps API calls per repo |
| Max jobs per run | 10 | Limits job inspection depth |
| Max log excerpt bytes | 8192 | Prevents oversized log storage |
| Max bundle size | 2 MB | Caps total JSON output |
| Max agent invocations | 10 | Bounds LLM usage per daily run |
| Timeout per repo | 60s | Prevents slow repos from blocking |
| Max run age | 90 days | Skips runs older than this (logs expire ~90 days); override with `--max-age DAYS` |

To tune, edit the constants at the top of `collectors/github-actions/collect.sh`.

## Adding a New Collector

1. Create `collectors/<system>/collect.sh`
2. The script must produce JSON conforming to `schemas/broken-builds-data.schema.json`
3. Set `"collector"` to the system name
4. Support `--dry-run` and `--help`
5. Update `broken-builds-skill-run.sh` to invoke the new collector
6. See `collectors/konflux/collect.sh` for a stub template

## Rollback

```bash
# 1. Unload the plist
launchctl unload ~/Library/LaunchAgents/com.tsd-agent-lab.broken-builds.plist
rm ~/Library/LaunchAgents/com.tsd-agent-lab.broken-builds.plist

# 2. Remove scripts (optional)
rm scripts/macos/broken-builds-skill-run.sh
rm scripts/macos/com.tsd-agent-lab.broken-builds.plist
rm -rf collectors/github-actions/ collectors/konflux/
rm schemas/broken-builds-data.schema.json
rm skills/broken-builds/SKILL.md
rm scripts/macos/generate-repo-inventory.sh
rm policies/generated/repo-inventory.txt

# 3. Reports in reports/ can be kept or removed as desired
```

## Known Limitations

- **Default branch only** — v1 does not check PR builds
- **No auto-fix** — the report is informational; no code changes are made
- **No notifications** — Slack/email notifications are a separate future feature
- **Dedup heuristic** — error line normalization may over- or under-group failures; tuning may be needed after seeing real data
- **Log volume** — large CI logs are truncated to 8192 bytes per step
- **Konflux** — stub only; real implementation needs API access and must handle ephemeral log expiry
- **API rate limits** — many repos with many failures could hit GitHub API limits; mitigated by per-repo caps and timeouts

## Conventions
- No trailing whitespace in markdown
- Single trailing newline
- kebab-case for all filenames
- No paths under /Users/ryordan/ in output
