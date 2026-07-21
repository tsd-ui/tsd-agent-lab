# Daily Command Center — 2026-07-21

## Status: 🔴

### Summary

- 0 CI failure(s) across 0 repo(s)
- 14 stale docs finding(s)
- 7 PRs reviewed, 3 open across monitored repos
- 29 PR(s) triaged: 2 critical, 3 high

### Changes Since Yesterday
- 11 CI failure(s) resolved
- 7 stale doc finding(s) resolved

### CI / Builds

unknown


### Documentation Health

**Summary:** 5 stale findings, 9 for review

Affected files:
- `skills/broken-builds/SKILL.md`
- `skills/pr-risk-triage/SKILL.md`
- `docs/admin/schedule.md`
- `docs/admin/command-center.md`
- `docs/admin/stale-docs-check.md`
- `docs/pilot/fullsend-local-evaluation.md`
- `docs/pilot/phase-1-read-only-pilot.md`
- `docs/reference/harness.md`
- `docs/reference/run-claude.md`
- `scripts/macos/README.md`
- `skills/stale-docs-check/SKILL.md`

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

29 PR(s) triaged: 2 critical, 3 high, 7 medium, 17 low.

**Needs Attention (maintained repos):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console-ui#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324) | 55 | high | ci-failing, force-pushes-2+, stale-14+, no-reviews-yet | deep-review |
| 2 | [securesign/rhtas-console-ui#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325) | 53 | high | ci-failing, force-pushes-2+, stale-14+, no-reviews-yet | deep-review |
| 3 | [tsd-ui/tsd-ui#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18) | 51 | high | ci-failing, large-diff-500+, stale-14+, force-pushes-2+, high-dispersion, no-reviews-yet | deep-review |

**Upstream Alerts (dependency repos — awareness only, no deep-review):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85) | 74 | critical | ci-failing, release-change, force-pushes-2+, stale-14+ | assess-impact |
| 2 | [securesign/rhtas-console#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95) | 70 | critical | deployment-change, force-pushes-2+, missing-tests, no-reviews-yet | assess-impact |

### Action Items

- [ ] Fix 5 stale doc link(s)
- [ ] Triage 3 critical/high-risk PR(s) in maintained repos
- [ ] Assess impact of 2 high-impact upstream dependency PR(s) — awareness only, no deep-review needed

### Next Steps

- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
