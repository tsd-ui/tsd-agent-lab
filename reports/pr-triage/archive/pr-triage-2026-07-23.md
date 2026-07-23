# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-23 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-23 05:47:48 |
| Status | 23 PR(s) triaged across 9 repo(s) |

## Summary

21 open PR(s) across 6 maintained repo(s) and 2 upstream dependency repo(s). 1 critical, 3 high, 8 medium, 11 low.

## Needs Attention Now

| # | PR | Score | Priority | Action |
|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui#23](https://github.com/tsd-ui/tsd-ui/pull/23) | 70 | critical | deep-review |
| 2 | [tsd-ui/tsd-ui#18](https://github.com/tsd-ui/tsd-ui/pull/18) | 58 | high | deep-review |
| 3 | [tsd-ui/tsd-ui#62](https://github.com/tsd-ui/tsd-ui/pull/62) | 50 | high | deep-review |
| 4 | [securesign/rhtas-console-ui#325](https://github.com/securesign/rhtas-console-ui/pull/325) | 50 | high | deep-review |

### Upstream Alerts

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85](https://github.com/securesign/rhtas-console/pull/85) | 71 | critical | assess-impact |

## Full Triage — Maintained Repos

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 3 open PR(s)

#### [#338: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/338)
- **Risk Score:** 28 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - large-diff-over-200-lines (+5)
  - missing-tests (+10)
  - no-reviews-over-1-day (+3)
  - force-pushes-1 (+3)
  - stale-over-3-days (+3)
  - draft-pr (-10)
  - contextual-diff-scan (+9): force-push count (6 in upstream dep) suggests churn
- **Recommended Action:** monitor

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 50 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-2+ (+5)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+4): major version bumps in package.json files
- **Recommended Action:** deep-review

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 40 / 100
- **Priority:** medium
- **Reasons:**
  - ci-pending (+5)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-2+ (+5)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+9): one failing coverage check in CI
- **Recommended Action:** scan-review

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 10 open PR(s)

#### [#65: chore(deps): bump actions/setup-node from 6 to 7](https://github.com/tsd-ui/tsd-ui/pull/65)
- **Risk Score:** 23 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-changes (+10)
  - missing-tests (+10)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#64: chore(deps): bump postcss from 8.5.8 to 8.5.21](https://github.com/tsd-ui/tsd-ui/pull/64)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-3-days (+3)
- **Recommended Action:** monitor

#### [#63: chore(deps-dev): bump brace-expansion from 1.1.12 to 1.1.16](https://github.com/tsd-ui/tsd-ui/pull/63)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-3-days (+3)
- **Recommended Action:** monitor

#### [#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62)
- **Risk Score:** 50 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-3-days (+3)
  - contextual-diff-scan (+4): major version bump (6.x → 7.x) likely causing CI failures
- **Recommended Action:** deep-review

#### [#61: chore(deps-dev): bump astro from 6.3.3 to 7.1.0](https://github.com/tsd-ui/tsd-ui/pull/61)
- **Risk Score:** 41 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-1000-lines (+15)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-3-days (+3)
  - contextual-diff-scan (+10): major version bump with 2466 additions, high churn risk
- **Recommended Action:** scan-review

#### [#60: chore(deps-dev): bump the dev-dependencies group across 1 directory with 13 updates](https://github.com/tsd-ui/tsd-ui/pull/60)
- **Risk Score:** 37 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-500-lines (+10)
  - high-file-dispersion (+8)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - stale-over-3-days (+3)
- **Recommended Action:** scan-review

#### [#58: chore(deps-dev): bump markdown-it from 14.1.1 to 14.3.0](https://github.com/tsd-ui/tsd-ui/pull/58)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-3-days (+3)
- **Recommended Action:** monitor

#### [#54: chore(deps): bump actions/checkout from 4 to 7](https://github.com/tsd-ui/tsd-ui/pull/54)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - release-deployment-changes (+10)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+8): major version jump (4→7) in critical workflow files
- **Recommended Action:** scan-review

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 70 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+9): stale for 112 days, multiple CI failures
- **Recommended Action:** deep-review

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 58 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+4): major TypeScript version bump (5.x → 6.x)
- **Recommended Action:** deep-review

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#14: :ghost: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-1000-lines (+15)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-14-days (+8)
  - contextual-diff-scan (-2): all checks passing, grouped update
- **Recommended Action:** scan-review

#### [#13: :ghost: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 24 / 100
- **Priority:** low
- **Reasons:**
  - release-deployment-changes (+10)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - stale-over-14-days (+8)
  - contextual-diff-scan (-7): all checks passing, workflow changes only
- **Recommended Action:** monitor

#### [#12: :ghost: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+0): linting group update, checks pass
- **Recommended Action:** scan-review

#### [#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 41 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-1000-lines (+15)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+2): large PatternFly update (3994 additions)
- **Recommended Action:** scan-review

#### [#9: :ghost: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 24 / 100
- **Priority:** low
- **Reasons:**
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - stale-over-14-days (+8)
- **Recommended Action:** monitor

#### [#8: :ghost: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 24 / 100
- **Priority:** low
- **Reasons:**
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-1 (+3)
  - stale-over-14-days (+8)
- **Recommended Action:** monitor

### [tsd-ui/conforma-policy-test](https://github.com/tsd-ui/conforma-policy-test) — 0 open PR(s)

No open PRs.

### [tsd-ui/devtools](https://github.com/tsd-ui/devtools) — 0 open PR(s)

No open PRs.

### [tsd-ui/tsd-agent-lab](https://github.com/tsd-ui/tsd-agent-lab) — 0 open PR(s)

No open PRs.

### [tsd-ui/tsd-ui-plugin](https://github.com/tsd-ui/tsd-ui-plugin) — 0 open PR(s)

No open PRs.

## Upstream Dependencies — Changes to Watch

> These are repositories the team depends on but does not maintain. They are listed
> for awareness: track changes that could affect the team's own repos. Do not review
> or merge these PRs — assess whether the upstream change warrants action downstream.

### [securesign/rhtas-console](https://github.com/securesign/rhtas-console) — 2 open PR(s)

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - release-deployment-changes (+10)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-2+ (+5)
  - stale-over-7-days (+5)
  - contextual-diff-scan (-7): Dockerfile updates only, likely automated
- **Impact Note:** Docker base image updates in upstream rhtas-console may require rebuilding rhtas-console-ui if there are shared image dependencies.
- **Recommended Action:** watch

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 71 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - release-deployment-changes (+10)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - force-pushes-2+ (+5)
  - stale-over-14-days (+8)
  - contextual-diff-scan (+5): 50 days old with 193 force pushes, go.mod changes
- **Impact Note:** Failing Go dependency updates in rhtas-console may indicate incompatible API changes that could affect rhtas-console-ui's backend integration.
- **Recommended Action:** assess-impact

---

**Report Complete.** 23 PRs triaged: 1 critical, 3 high, 8 medium, 11 low priority.
