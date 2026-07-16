# Daily Command Center — 2026-07-16

## Status: 🔴

### Summary

- 10 CI failure(s) across 3 repo(s)
- 28 stale docs finding(s)
- System health: ok
- 7 PRs reviewed, 4 open across monitored repos

### Changes Since Yesterday
- 10 new CI failure(s)
- 28 new stale doc finding(s)
- Status changed: green -> red

### CI / Builds

10 failures across 3 repos (down from 20 across 5 in the prior report — securesign/rhtas-console and tsd-ui/tsd-ui-team-docs are now clear)


### Documentation Health

**Summary:** 5 stale findings, 23 for review (mechanical pass only)

Affected files:
- `docs/pilot/phase-1-read-only-pilot.md`
- `docs/reference/evaluation.md`
- `docs/setup/SWITCHING-TO-AGENT-LAB.md`
- `skills/broken-builds/SKILL.md`
- `docs/admin/command-center.md`
- `docs/admin/schedule.md`
- `docs/admin/stale-docs-check.md`
- `docs/pilot/fullsend-local-evaluation.md`
- `docs/pilot/phase-1-read-only-pilot.md`
- `docs/reference/harness.md`
- `docs/reference/run-claude.md`
- `scripts/macos/README.md`
- `skills/adr-writer/SKILL.md`
- `skills/stale-docs-check/SKILL.md`

### System Health

**Status:** ok

### PR Activity

- **7** PRs reviewed (lifetime)
- **4** PRs currently open across monitored repos

Recent reviews:
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/324 (reviewed 2026-07-06)

### Action Items

- [ ] Review 10 CI failure(s) across 3 repo(s)
- [ ] Fix 5 stale doc link(s)

### Next Steps

- **View broken-builds report:** `cat reports/broken-builds/current.md`
- **Re-run CI diagnosis:** `./scripts/macos/broken-builds-skill-run.sh --force-rediagnose`
- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
