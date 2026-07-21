# Daily Command Center — 2026-07-21

## Status: 🟡

### Summary

- 0 CI failure(s) across 0 repo(s)
- 9 stale docs finding(s)
- 7 PRs reviewed, 3 open across monitored repos
- 30 PR(s) triaged: 1 critical, 1 high

### Changes Since Yesterday
- 11 CI failure(s) resolved
- 12 stale doc finding(s) resolved
- Status changed: red -> yellow

### CI / Builds

unknown


### Documentation Health

**Summary:** 6 stale findings, 3 for review

Affected files:
- `skills/broken-builds/SKILL.md`
- `skills/pr-risk-triage/SKILL.md`
- `docs/reference/harness.md`
- `docs/reference/run-claude.md`
- `docs/pilot/phase-1-read-only-pilot.md`

### PR Activity

- **7** PRs reviewed (lifetime)
- **3** PRs currently open across monitored repos

Recent reviews:
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/324 (reviewed 2026-07-06)

### PR Risk Triage

30 PR(s) triaged: 1 critical, 1 high, 11 medium, 17 low.

**Needs Attention:**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85) | 73 | critical | ci-failing, release-change, stale-45d, excessive-force-pushes | deep-review |
| 2 | [securesign/rhtas-console-ui#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325) | 50 | high | ci-failing, release-change, stale-15d | deep-review |

### Action Items

- [ ] Fix 6 stale doc link(s)
- [ ] Triage 1 critical and 1 high-risk PR(s)

### Next Steps

- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
