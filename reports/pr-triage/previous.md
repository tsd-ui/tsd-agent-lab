Now I'll analyze each PR and compute risk scores, then produce the report.

# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-17 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-17 16:28:53 |
| Status | 30 PR(s) triaged across 8 repo(s) |

## Summary

30 open PR(s) across 8 repo(s). 1 critical, 1 high, 11 medium, 17 low.

## Needs Attention Now

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85](https://github.com/securesign/rhtas-console/pull/85) | 73 | critical | ci-failing, release-change, stale-45d, excessive-force-pushes | deep-review |
| 2 | [securesign/rhtas-console-ui#325](https://github.com/securesign/rhtas-console-ui/pull/325) | 50 | high | ci-failing, release-change, stale-15d | deep-review |

## Full Triage

### [securesign/rhtas-console](https://github.com/securesign/rhtas-console) — 2 open PR(s)

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 27 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - release-change: Dockerfile (+10)
  - force-push-count-2 (+3)
  - no-reviews-yet (+3)
  - stale-1d: no staleness penalty (+0)
  - test-coverage-ok (+0)
- **Recommended Action:** monitor

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 73 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - release-change: go.mod (+10)
  - force-push-count-165: 2+ (+5)
  - no-reviews-yet (+3)
  - stale-45d: >14 days (+8)
  - test-coverage-ok (+0)
  - excessive-force-pushes: 165 force pushes indicates unstable branch or integration issues (+10)
  - contextual-bonus: Excessive force push count (165) suggests chronic CI/integration issues (+10)
  - staleness-additional: 45 days open with no resolution (+7)
- **Recommended Action:** deep-review

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 3 open PR(s)

#### [#337: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/337)
- **Risk Score:** 8 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - release-change: package-lock.json at root (+0)
  - no-reviews-yet (+3)
  - stale-1d: no staleness penalty (+0)
- **Recommended Action:** monitor

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 50 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change: package.json at root (+10)
  - force-push-count-5 (+5)
  - no-reviews-yet (+3)
  - stale-15d: >14 days (+8)
  - contextual-bonus: major version bump with CI failures (+4)
- **Recommended Action:** deep-review

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 46 / 100
- **Priority:** medium
- **Reasons:**
  - ci-partial-failure: coverage job failed (+10)
  - release-change: package.json at root (+10)
  - force-push-count-29: 2+ (+5)
  - no-reviews-yet (+3)
  - stale-15d: >14 days (+8)
  - contextual-bonus: 29 force pushes suggests integration challenges (+10)
- **Recommended Action:** scan-review

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 12 open PR(s)

#### [#57: chore(deps): bump postcss from 8.5.8 to 8.5.16](https://github.com/tsd-ui/tsd-ui/pull/57)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-18d: >14 days (+8)
- **Recommended Action:** monitor

#### [#56: chore(deps-dev): bump js-yaml from 4.1.1 to 4.3.0](https://github.com/tsd-ui/tsd-ui/pull/56)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-18d: >14 days (+8)
- **Recommended Action:** monitor

#### [#55: chore(deps-dev): bump the dev-dependencies group across 1 directory with 12 updates](https://github.com/tsd-ui/tsd-ui/pull/55)
- **Risk Score:** 24 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - large-diff: 994+574=1568 lines (+15)
  - no-reviews-yet (+3)
  - stale-22d: >14 days (+8)
  - release-change: package.json at root (-2 offset by group update complexity)
- **Recommended Action:** monitor

#### [#54: chore(deps): bump actions/checkout from 4 to 7](https://github.com/tsd-ui/tsd-ui/pull/54)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflow files (+10)
  - no-reviews-yet (+3)
  - stale-22d: >14 days (+8)
- **Recommended Action:** monitor

#### [#53: chore(deps): bump undici from 7.24.5 to 7.28.0](https://github.com/tsd-ui/tsd-ui/pull/53)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-27d: >14 days (+8)
- **Recommended Action:** monitor

#### [#52: chore(deps-dev): bump astro from 6.3.3 to 6.4.6](https://github.com/tsd-ui/tsd-ui/pull/52)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-27d: >14 days (+8)
- **Recommended Action:** monitor

#### [#51: chore(deps-dev): bump markdown-it from 14.1.1 to 14.2.0](https://github.com/tsd-ui/tsd-ui/pull/51)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-29d: >14 days (+8)
- **Recommended Action:** monitor

#### [#45: chore(deps): bump actions/upload-pages-artifact from 3 to 5](https://github.com/tsd-ui/tsd-ui/pull/45)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflow file (+10)
  - no-reviews-yet (+3)
  - stale-57d: >14 days (+8)
  - stale-additional: 57 days indicates abandoned (-2 offset)
- **Recommended Action:** monitor

#### [#44: chore(deps): bump actions/deploy-pages from 4 to 5](https://github.com/tsd-ui/tsd-ui/pull/44)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflow file (+10)
  - no-reviews-yet (+3)
  - stale-57d: >14 days (+8)
  - stale-additional: 57 days indicates abandoned (-2 offset)
- **Recommended Action:** monitor

#### [#41: chore(deps-dev): bump turbo from 2.8.20 to 2.9.14](https://github.com/tsd-ui/tsd-ui/pull/41)
- **Risk Score:** 30 / 100
- **Priority:** medium
- **Reasons:**
  - ci-success (+0)
  - release-change: package.json at root (+10)
  - force-push-count-1 (+3)
  - no-reviews-yet (+3)
  - stale-58d: >14 days (+8)
  - contextual-bonus: turbo is build orchestrator, changes can affect entire monorepo (+6)
- **Recommended Action:** scan-review

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 44 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change: package.json (+10)
  - no-reviews-yet (+3)
  - stale-106d: >14 days (+8)
  - contextual-bonus: React upgrade failures on multiple Node versions (+3)
- **Recommended Action:** scan-review

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 51 / 100
- **Priority:** high (score rounds to 51)
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change: package.json at root (+10)
  - force-push-count-3 (+3)
  - no-reviews-yet (+3)
  - stale-113d: >14 days (+8)
  - contextual-bonus: TypeScript major version upgrade with failures (+7)
- **Recommended Action:** scan-review

### [tsd-ui/tsd-ui-team-docs](https://github.com/tsd-ui/tsd-ui-team-docs) — 13 open PR(s)

#### [#24: chore(ci): bump actions/upload-pages-artifact from 3 to 5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/24)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflow (+10)
  - no-reviews-yet (+3)
  - stale-88d: >14 days (+8)
  - stale-additional: appears abandoned (-2)
- **Recommended Action:** monitor

#### [#23: chore(deps): bump react-dom from 18.3.1 to 19.2.5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/23)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - no-reviews-yet (+3)
  - stale-95d: >14 days (+8)
- **Recommended Action:** scan-review

#### [#22: chore(deps): bump @docusaurus/tsconfig from 3.6.0 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/22)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-95d: >14 days (+8)
- **Recommended Action:** monitor

#### [#21: chore(deps): bump @docusaurus/types from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/21)
- **Risk Score:** 26 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - large-diff: 381+6=387 lines (+5)
  - public-api-change: types package (+12)
  - no-reviews-yet (+3)
  - stale-95d: >14 days (+8)
  - stale-additional: likely abandoned (-2)
- **Recommended Action:** monitor

#### [#20: chore(deps): bump @docusaurus/module-type-aliases from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/20)
- **Risk Score:** 23 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - public-api-change: type aliases (+12)
  - no-reviews-yet (+3)
  - stale-95d: >14 days (+8)
- **Recommended Action:** monitor

#### [#19: chore(deps): bump @docusaurus/theme-mermaid from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/19)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - no-reviews-yet (+3)
  - stale-95d: >14 days (+8)
- **Recommended Action:** scan-review

#### [#18: chore(deps): bump typescript from 5.6.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui-team-docs/pull/18)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: package.json (+10)
  - no-reviews-yet (+3)
  - stale-109d: >14 days (+8)
- **Recommended Action:** monitor

#### [#17: chore(ci): bump actions/deploy-pages from 4 to 5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/17)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflow (+10)
  - no-reviews-yet (+3)
  - stale-109d: >14 days (+8)
- **Recommended Action:** monitor

#### [#13: chore(deps): bump react and @types/react](https://github.com/tsd-ui/tsd-ui-team-docs/pull/13)
- **Risk Score:** 49 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - large-diff: 765+518=1283 lines (+15)
  - no-reviews-yet (+3)
  - stale-165d: >14 days (+8)
  - contextual-bonus: React major upgrade with failures (+3)
- **Recommended Action:** scan-review

#### [#8: chore(deps): bump prism-react-renderer from 2.3.1 to 2.4.1](https://github.com/tsd-ui/tsd-ui-team-docs/pull/8)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-178d: >14 days (+8)
- **Recommended Action:** monitor

#### [#6: chore(deps): bump @mdx-js/react from 3.0.1 to 3.1.1](https://github.com/tsd-ui/tsd-ui-team-docs/pull/6)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-178d: >14 days (+8)
- **Recommended Action:** monitor

#### [#4: chore(deps): bump docusaurus-lunr-search from 3.4.0 to 3.6.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/4)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - no-reviews-yet (+3)
  - stale-178d: >14 days (+8)
- **Recommended Action:** monitor

#### [#3: chore(ci): bump actions/checkout from 4 to 6](https://github.com/tsd-ui/tsd-ui-team-docs/pull/3)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflows (+10)
  - no-reviews-yet (+3)
  - stale-178d: >14 days (+8)
- **Recommended Action:** monitor

#### [#2: chore(ci): bump actions/setup-node from 4 to 6](https://github.com/tsd-ui/tsd-ui-team-docs/pull/2)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflows (+10)
  - no-reviews-yet (+3)
  - stale-178d: >14 days (+8)
- **Recommended Action:** monitor

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#14: :ghost: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - large-diff: 1612+2096=3708 lines (+15)
  - no-reviews-yet (+3)
  - stale-16d: >14 days (+8)
  - contextual-bonus: multiple tool updates in bundle (-7 reduction for passing CI)
- **Recommended Action:** monitor

#### [#13: :ghost: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 19 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: GitHub workflows (+10)
  - no-reviews-yet (+3)
  - stale-16d: >14 days (+8)
  - stale-additional: (-2 for passing checks)
- **Recommended Action:** monitor

#### [#12: :ghost: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 28 / 100
- **Priority:** low
- **Reasons:**
  - ci-success (+0)
  - release-change: package.json (+10)
  - force-push-count-1 (+3)
  - no-reviews-yet (+3)
  - stale-25d: >14 days (+8)
  - contextual-bonus: linting changes can affect developer workflow (+4)
- **Recommended Action:** monitor

#### [#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - ci-success (+0)
  - large-diff: 3994+4025=8019 lines (+15)
  - force-push-count-2 (+3)
  - no-reviews-yet (+3)
  - stale-45d: >14 days (+8)
  - contextual-bonus: PatternFly updates can affect UI significantly (+5)
- **Recommended Action:** scan-review

#### [#9: :ghost: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - ci-success (+0)
  - release-change: package.json (+10)
  - force-push-count-2 (+3)
  - no-reviews-yet (+3)
  - stale-45d: >14 days (+8)
  - contextual-bonus: server dependency changes (+7)
- **Recommended Action:** scan-review

#### [#8: :ghost: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - ci-success (+0)
  - release-change: package.json (+10)
  - force-push-count-2 (+3)
  - no-reviews-yet (+3)
  - stale-45d: >14 days (+8)
  - contextual-bonus: Rollup is build tool, changes can affect bundling (+7)
- **Recommended Action:** scan-review

---

## Notes

- **Critical Attention:** PR #85 in securesign/rhtas-console has 165 force pushes over 45 days with failing CI on a go.mod update — this indicates chronic integration issues that need immediate investigation.
- **Stale PRs:** 17 PRs are >14 days old with no reviews, indicating possible abandonment or low prioritization.
- **Dependency Bot PRs:** The majority (28/30) are automated dependency updates. Consider batch-reviewing low-risk passing PRs to clear backlog.
- **CI Failures:** 5 PRs have failing CI, all dependency updates — these should be investigated or closed if incompatible.
