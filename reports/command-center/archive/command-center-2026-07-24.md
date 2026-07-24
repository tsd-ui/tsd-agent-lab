# Daily Command Center — 2026-07-24

## Status: 🟡

### Summary

- 0 CI failure(s) across 0 repo(s)
- 10 stale docs finding(s)
- 8 PRs reviewed, 4 open across monitored repos
- 19 PR(s) triaged: 0
0 critical, 1
1 high

### Changes Since Yesterday
- 3 stale doc finding(s) resolved
- Status changed: red -> yellow

### CI / Builds

unknown


### Documentation Health

**Summary:** 7 stale findings, 3 for review

Affected files:
- `docs/admin/command-center.md`
- `docs/admin/schedule.md`
- `docs/admin/stale-docs-check.md`
- `docs/pilot/phase-1-read-only-pilot.md`
- `docs/reference/harness.md`
- `docs/reference/run-claude.md`
- `scripts/macos/README.md`
- `docs/draft-pr-mode.md`
- `skills/broken-builds/SKILL.md`
- `skills/pr-risk-triage/SKILL.md`
- `docs/admin/schedule.md`
- `docs/pilot/fullsend-local-evaluation.md`
- `docs/admin/stale-docs-check.md`
- `skills/stale-docs-check/SKILL.md`

### PR Activity

- **8** PRs reviewed (lifetime)
- **4** PRs currently open across monitored repos

Recent reviews:
- tsd-ui/tsd-ui#53 (reviewed 2026-07-21)
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)

### PR Risk Triage

19 PR(s) triaged: 0
0 critical, 1
1 high, 10
0 medium, 8
1 low.

**Needs Attention (maintained repos):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18) | 54 | high | ci-failing, stale-73-days, root-package-json-change | deep-review |

**Upstream Alerts (dependency repos — awareness only, no deep-review):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85) | 56 | high | ci-failing, missing-tests, stale-51-days, excessive-force-pushes | assess-impact |

### Action Items

- [ ] Fix 7 stale doc link(s)
- [ ] Triage 1 critical/high-risk PR(s) in maintained repos
- [ ] Assess impact of 1 high-impact upstream dependency PR(s) — awareness only, no deep-review needed

### Next Steps

- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
