# Daily Command Center — 2026-07-22

## Status: 🔴

### Summary

- 0 CI failure(s) across 0 repo(s)
- 13 stale docs finding(s)
- 8 PRs reviewed, 3 open across monitored repos
- 34 PR(s) triaged: 0 critical, 3 high

### Changes Since Yesterday
- 11 CI failure(s) resolved
- 8 stale doc finding(s) resolved

### CI / Builds

unknown


### Documentation Health

**Summary:** 0 stale findings, 13 for review

Affected files:
- `skills/broken-builds/SKILL.md`
- `skills/pr-risk-triage/SKILL.md`
- `docs/admin/command-center.md`
- `docs/admin/schedule.md`
- `docs/admin/stale-docs-check.md`
- `docs/pilot/fullsend-local-evaluation.md`
- `docs/pilot/phase-1-read-only-pilot.md`
- `docs/reference/harness.md`
- `docs/reference/run-claude.md`
- `scripts/macos/README.md`
- `skills/stale-docs-check/SKILL.md`

### PR Activity

- **8** PRs reviewed (lifetime)
- **3** PRs currently open across monitored repos

Recent reviews:
- tsd-ui/tsd-ui#53 (reviewed 2026-07-21)
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)

### PR Risk Triage

34 PR(s) triaged: 0 critical, 3 high, 15 medium, 16 low.

**Needs Attention (maintained repos):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui-team-docs#13: chore(deps): bump react and @types/react](https://github.com/tsd-ui/tsd-ui-team-docs/pull/13) | 56 | high | ci-failing, release-change, large-diff-over-1000, stale-over-14-days | deep-review |
| 2 | [tsd-ui/tsd-ui#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18) | 54 | high | ci-failing, release-change, large-diff-over-200, stale-over-14-days, force-pushes | deep-review |
| 3 | [tsd-ui/tsd-ui-team-docs#19: chore(deps): bump @docusaurus/theme-mermaid from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/19) | 51 | high | ci-failing, release-change, large-diff-over-200, stale-over-14-days | deep-review |

### Action Items

- [ ] Triage 3 critical/high-risk PR(s) in maintained repos

### Next Steps

- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
