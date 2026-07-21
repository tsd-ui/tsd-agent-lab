# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-21 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-21 13:23:10 |
| Status | 29 PR(s) triaged across 9 repo(s) |

## Summary

29 open PR(s) across 7 maintained repo(s) and 1 upstream dependency repo(s). 2 critical, 3 high, 7 medium, 17 low.

## Needs Attention Now

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console-ui#324](https://github.com/securesign/rhtas-console-ui/pull/324) | 55 | high | ci-failing, force-pushes-2+, stale-14+, no-reviews-yet | deep-review |
| 2 | [securesign/rhtas-console-ui#325](https://github.com/securesign/rhtas-console-ui/pull/325) | 53 | high | ci-failing, force-pushes-2+, stale-14+, no-reviews-yet | deep-review |
| 3 | [tsd-ui/tsd-ui#18](https://github.com/tsd-ui/tsd-ui/pull/18) | 51 | high | ci-failing, large-diff-500+, stale-14+, force-pushes-2+, high-dispersion, no-reviews-yet | deep-review |

### Upstream Alerts

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [securesign/rhtas-console#85](https://github.com/securesign/rhtas-console/pull/85) | 74 | critical | ci-failing, release-change, force-pushes-2+, stale-14+ | assess-impact |
| 2 | [securesign/rhtas-console#95](https://github.com/securesign/rhtas-console/pull/95) | 70 | critical | deployment-change, force-pushes-2+, missing-tests, no-reviews-yet | assess-impact |

## Full Triage — Maintained Repos

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 3 open PR(s)

#### [#337: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/337)
- **Risk Score:** 8 / 100
- **Priority:** low
- **Reasons:**
  - ci-pending (+5)
  - stale-3-7-days (+3)
- **Recommended Action:** monitor

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 53 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - force-pushes-2+ (+5)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - stale-7-14-days (+5)
  - missing-tests (+10)
  - no-test-coverage (+0)
  - stale-3-7-days (+0)
- **Recommended Action:** deep-review

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 55 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - force-pushes-2+ (+5)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - stale-7-14-days (+5)
  - missing-tests (+10)
  - no-test-coverage (+0)
  - stale-3-7-days (+0)
  - large-diff-200+ (+5)
- **Recommended Action:** deep-review

### [tsd-ui/conforma-policy-test](https://github.com/tsd-ui/conforma-policy-test) — 0 open PR(s)

### [tsd-ui/devtools](https://github.com/tsd-ui/devtools) — 0 open PR(s)

### [tsd-ui/tsd-agent-lab](https://github.com/tsd-ui/tsd-agent-lab) — 0 open PR(s)

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 10 open PR(s)

#### [#64: chore(deps): bump postcss from 8.5.8 to 8.5.21](https://github.com/tsd-ui/tsd-ui/pull/64)
- **Risk Score:** 0 / 100
- **Priority:** low
- **Reasons:**
  - (all checks passing, small diff, no other risk factors)
- **Recommended Action:** monitor

#### [#63: chore(deps-dev): bump brace-expansion from 1.1.12 to 1.1.16](https://github.com/tsd-ui/tsd-ui/pull/63)
- **Risk Score:** 0 / 100
- **Priority:** low
- **Reasons:**
  - (all checks passing, small diff, no other risk factors)
- **Recommended Action:** monitor

#### [#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3 in /apps/docs in the npm_and_yarn group across 1 directory](https://github.com/tsd-ui/tsd-ui/pull/62)
- **Risk Score:** 23 / 100
- **Priority:** low
- **Reasons:**
  - ci-failing (+20)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#61: chore(deps-dev): bump astro from 6.3.3 to 7.1.0](https://github.com/tsd-ui/tsd-ui/pull/61)
- **Risk Score:** 18 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-1000+ (+15)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#60: chore(deps-dev): bump the dev-dependencies group across 1 directory with 13 updates](https://github.com/tsd-ui/tsd-ui/pull/60)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-500+ (+10)
  - force-pushes-1 (+3)
  - high-dispersion (+8)
- **Recommended Action:** monitor

#### [#58: chore(deps-dev): bump markdown-it from 14.1.1 to 14.3.0](https://github.com/tsd-ui/tsd-ui/pull/58)
- **Risk Score:** 0 / 100
- **Priority:** low
- **Reasons:**
  - (all checks passing, small diff, no other risk factors)
- **Recommended Action:** monitor

#### [#54: chore(deps): bump actions/checkout from 4 to 7](https://github.com/tsd-ui/tsd-ui/pull/54)
- **Risk Score:** 26 / 100
- **Priority:** low
- **Reasons:**
  - deployment-workflow-change (+10)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - stale-7-14-days (+5)
- **Recommended Action:** monitor

#### [#53: chore(deps): bump undici from 7.24.5 to 7.28.0](https://github.com/tsd-ui/tsd-ui/pull/53)
- **Risk Score:** 16 / 100
- **Priority:** low
- **Reasons:**
  - stale-14+-days (+8)
  - stale-7-14-days (+5)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 40 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - stale-14+-days (+8)
  - stale-7-14-days (+5)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 51 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - large-diff-500+ (+10)
  - stale-14+-days (+8)
  - force-pushes-2+ (+5)
  - high-dispersion (+8)
  - missing-tests (+10)
  - stale-7-14-days (+0)
  - no-reviews-yet (+0)
- **Recommended Action:** deep-review

### [tsd-ui/tsd-ui-plugin](https://github.com/tsd-ui/tsd-ui-plugin) — 0 open PR(s)

### [tsd-ui/tsd-ui-team-docs](https://github.com/tsd-ui/tsd-ui-team-docs) — 14 open PR(s)

#### [#24: chore(ci): bump actions/upload-pages-artifact from 3 to 5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/24)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - deployment-workflow-change (+10)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#23: chore(deps): bump react-dom from 18.3.1 to 19.2.5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/23)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#22: chore(deps): bump @docusaurus/tsconfig from 3.6.0 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/22)
- **Risk Score:** 14 / 100
- **Priority:** low
- **Reasons:**
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#21: chore(deps): bump @docusaurus/types from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/21)
- **Risk Score:** 29 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-200+ (+5)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#20: chore(deps): bump @docusaurus/module-type-aliases from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/20)
- **Risk Score:** 26 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-200+ (+5)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#19: chore(deps): bump @docusaurus/theme-mermaid from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/19)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - large-diff-200+ (+5)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#18: chore(deps): bump typescript from 5.6.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui-team-docs/pull/18)
- **Risk Score:** 14 / 100
- **Priority:** low
- **Reasons:**
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#17: chore(ci): bump actions/deploy-pages from 4 to 5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/17)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - deployment-workflow-change (+10)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#13: chore(deps): bump react and @types/react](https://github.com/tsd-ui/tsd-ui-team-docs/pull/13)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - large-diff-500+ (+10)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#8: chore(deps): bump prism-react-renderer from 2.3.1 to 2.4.1](https://github.com/tsd-ui/tsd-ui-team-docs/pull/8)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#6: chore(deps): bump @mdx-js/react from 3.0.1 to 3.1.1](https://github.com/tsd-ui/tsd-ui-team-docs/pull/6)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#4: chore(deps): bump docusaurus-lunr-search from 3.4.0 to 3.6.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/4)
- **Risk Score:** 11 / 100
- **Priority:** low
- **Reasons:**
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#3: chore(ci): bump actions/checkout from 4 to 6](https://github.com/tsd-ui/tsd-ui-team-docs/pull/3)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - deployment-workflow-change (+10)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#2: chore(ci): bump actions/setup-node from 4 to 6](https://github.com/tsd-ui/tsd-ui-team-docs/pull/2)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - deployment-workflow-change (+10)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#14: :ghost: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 29 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-1000+ (+15)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** monitor

#### [#13: :ghost: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - deployment-workflow-change (+10)
  - stale-14+-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#12: :ghost: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 32 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-500+ (+10)
  - stale-14+-days (+8)
  - force-pushes-1 (+3)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#11: :ghost: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 46 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-1000+ (+15)
  - stale-14+-days (+8)
  - force-pushes-2+ (+5)
  - no-reviews-yet (+3)
  - missing-tests (+10)
  - stale-7-14-days (+5)
- **Recommended Action:** scan-review

#### [#9: :ghost: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-500+ (+10)
  - stale-14+-days (+8)
  - force-pushes-2+ (+5)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

#### [#8: :ghost: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 34 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-500+ (+10)
  - stale-14+-days (+8)
  - force-pushes-2+ (+5)
  - no-reviews-yet (+3)
  - missing-tests (+10)
- **Recommended Action:** scan-review

## Upstream Dependencies — Changes to Watch

> These are repositories the team depends on but does not maintain. They are listed for awareness: track changes that could affect the team's own repos. Do not review or merge these PRs — assess whether the upstream change warrants action downstream.

### [securesign/rhtas-console](https://github.com/securesign/rhtas-console) — 2 open PR(s)

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 70 / 100
- **Priority:** critical
- **Reasons:**
  - deployment-change-dockerfile (+10)
  - force-pushes-2+ (+5)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - ci-pending (+5)
  - stale-3-7-days (+3)
  - security-sensitive-dockerfile (+15)
  - release-dockerfile (+10)
  - contextual-bonus-dockerfile-base-images (+9)
- **Impact Note:** Docker base image updates in both standard and Red Hat Dockerfiles may affect build processes or runtime behavior in rhtas-console-ui or other downstream consumers.
- **Recommended Action:** assess-impact

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 74 / 100
- **Priority:** critical
- **Reasons:**
  - ci-failing (+20)
  - release-change-go-mod (+10)
  - force-pushes-2+ (+5)
  - stale-14+-days (+8)
  - missing-tests (+10)
  - no-reviews-yet (+3)
  - large-diff-200+ (+5)
  - stale-7-14-days (+5)
  - contextual-bonus-go-mod-many-force-pushes (+8)
- **Impact Note:** Major Go dependency updates with failing CI across 49 days and 185 force pushes suggest significant compatibility issues that could cascade to rhtas-console-ui's backend integrations.
- **Recommended Action:** assess-impact

---

**Triage Notes:**
- 2 critical-priority PRs in upstream dependencies warrant immediate impact assessment
- 3 high-priority PRs in maintained repos (rhtas-console-ui#324, #325, tsd-ui/tsd-ui#18) need deep review
- 7 medium-priority PRs are candidates for focused scan-review
- Most low-priority PRs are automated dependency updates with passing CI and can be monitored
- Staleness is widespread: 23 of 29 PRs are >14 days old, suggesting possible bottlenecks in review capacity
