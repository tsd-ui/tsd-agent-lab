# Daily Command Center — 2026-07-27

## Status: 🔴

### Summary

- 0 CI failure(s) across 0 repo(s)
- 5 stale docs finding(s)
- 8 PRs reviewed, 5 open across monitored repos
- 22 PR(s) triaged: 2 critical, 8 high

### Changes Since Yesterday
- 18 stale doc finding(s) resolved
- Status changed: yellow -> red

### CI / Builds

unknown


### Documentation Health

**Summary:** 2 stale findings, 3 for review

Affected files:
- `docs/draft-pr-mode.md`
- `docs/admin/stale-docs-check.md`
- `skills/broken-builds/SKILL.md`
- `skills/pr-risk-triage/SKILL.md`
- `docs/reference/harness.md`

### PR Activity

- **8** PRs reviewed (lifetime)
- **5** PRs currently open across monitored repos

Recent reviews:
- tsd-ui/tsd-ui#53 (reviewed 2026-07-21)
- securesign/rhtas-console-ui/235 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/313 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/317 (reviewed 2026-07-06)
- securesign/rhtas-console-ui/318 (reviewed 2026-07-06)

### PR Risk Triage

22 PR(s) triaged: 2 critical, 8 high, 11 medium, 4 low.

**Needs Attention (maintained repos):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console-ui#340: feat: display all roles in TUF metadata tab](https://github.com/securesign/rhtas-console-ui/pull/340) | 70 | critical | ci-failing, schema-change, no-test-changes, stale-3d | deep-review |
| 2 | [tsd-ui/tsd-ui#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62) | 63 | high | ci-failing, release-change, stale-6d | deep-review |
| 3 | [securesign/rhtas-console-ui#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325) | 62 | high | ci-failing, release-change, stale-24d, force-push | deep-review |
| 4 | [tsd-ui/tsd-ui#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23) | 59 | high | ci-failing, stale-116d | deep-review |
| 5 | [tsd-ui/tsd-ui#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18) | 59 | high | ci-failing, release-change, stale-123d | deep-review |
| 6 | [securesign/rhtas-console-ui#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324) | 50 | high | ci-failing, release-change, stale-24d, force-push | deep-review |
| 7 | [securesign/rhtas-console-ui#339: feat: surface validFor service window and expiring status in certificates UI](https://github.com/securesign/rhtas-console-ui/pull/339) | 50 | high | schema-change, changes-requested, unresolved-threads, no-test-changes | deep-review |
| 8 | [tsd-ui/tsd-ui-template#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11) | 50 | high | large-diff-1000+, stale-54d | deep-review |

**Upstream Alerts (dependency repos — awareness only, no deep-review):**

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85) | 74 | critical | ci-failing, release-change, stale-54d, force-push-213 | assess-impact |

### Action Items

- [ ] Fix 2 stale doc link(s)
- [ ] Triage 8 critical/high-risk PR(s) in maintained repos
- [ ] Assess impact of 1 high-impact upstream dependency PR(s) — awareness only, no deep-review needed

### Next Steps

- **View stale-docs report:** `cat reports/stale-docs/current.md`
- **Run full docs review:** `claude -p "Follow skills/stale-docs-check/SKILL.md"`
- **Review open PRs:** `claude -p "Follow skills/pr-review/SKILL.md"`
- **View PR triage report:** `cat reports/pr-triage/current.md`
- **Re-run PR triage:** `./scripts/macos/pr-risk-triage-skill-run.sh --dry-run`
