I'll analyze this PR inventory data and produce a risk triage report according to the scoring formula.

Let me process each PR and calculate risk scores:

# PR Risk Triage Report

| Field | Value |
|---|---|
| Date | 2026-07-22 |
| Host | tsd-agent-lab |
| User | agent-lab |
| Generated | 2026-07-22 04:45:05 |
| Status | 34 PR(s) triaged across 8 repo(s) |

## Summary

34 open PR(s) across 7 maintained repo(s) and 1 upstream dependency repo(s). 0 critical, 3 high, 15 medium, 16 low.

## Needs Attention Now

| # | PR | Score | Priority | Key Risks | Action |
|---|---|---|---|---|---|
| 1 | [tsd-ui/tsd-ui-team-docs#13](https://github.com/tsd-ui/tsd-ui-team-docs/pull/13) | 56 | high | ci-failing, release-change, large-diff-over-1000, stale-over-14-days | deep-review |
| 2 | [tsd-ui/tsd-ui#18](https://github.com/tsd-ui/tsd-ui/pull/18) | 54 | high | ci-failing, release-change, large-diff-over-200, stale-over-14-days, force-pushes | deep-review |
| 3 | [tsd-ui/tsd-ui-team-docs#19](https://github.com/tsd-ui/tsd-ui-team-docs/pull/19) | 51 | high | ci-failing, release-change, large-diff-over-200, stale-over-14-days | deep-review |

### Upstream Alerts

_No critical or high priority dependency PRs_

## Full Triage — Maintained Repos

### [securesign/rhtas-console-ui](https://github.com/securesign/rhtas-console-ui) — 3 open PR(s)

#### [#324: chore(deps): update npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/324)
- **Risk Score:** 48 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10)
  - large-diff-over-200-lines (+10)
  - force-pushes-over-2 (+5)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#325: chore(deps): update npm dependencies (major)](https://github.com/securesign/rhtas-console-ui/pull/325)
- **Risk Score:** 38 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10)
  - force-pushes-over-2 (+5)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#338: chore(deps): lock file maintenance npm dependencies](https://github.com/securesign/rhtas-console-ui/pull/338)
- **Risk Score:** 10 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-over-200-lines (+10)
- **Recommended Action:** monitor

### [tsd-ui/tsd-ui](https://github.com/tsd-ui/tsd-ui) — 9 open PR(s)

#### [#18: chore(deps-dev): bump typescript from 5.9.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui/pull/18)
- **Risk Score:** 54 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10)
  - large-diff-over-200-lines (+10)
  - stale-over-14-days (+8)
  - force-pushes-1 (+3)
  - no-reviews-yet (+3)
- **Recommended Action:** deep-review

#### [#23: chore(deps-dev): bump react-dom and @types/react-dom](https://github.com/tsd-ui/tsd-ui/pull/23)
- **Risk Score:** 41 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#54: chore(deps): bump actions/checkout from 4 to 7](https://github.com/tsd-ui/tsd-ui/pull/54)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - security-sensitive-workflow-files (+15)
  - deployment-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#60: chore(deps-dev): bump the dev-dependencies group](https://github.com/tsd-ui/tsd-ui/pull/60)
- **Risk Score:** 25 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-over-1000-lines (+15)
  - release-change (+10)
- **Recommended Action:** monitor

#### [#62: chore(deps-dev): bump astro from 6.4.8 to 7.1.3](https://github.com/tsd-ui/tsd-ui/pull/62)
- **Risk Score:** 20 / 100
- **Priority:** low
- **Reasons:**
  - ci-failing (+20)
- **Recommended Action:** monitor

#### [#61: chore(deps-dev): bump astro from 6.3.3 to 7.1.0](https://github.com/tsd-ui/tsd-ui/pull/61)
- **Risk Score:** 15 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-over-1000-lines (+15)
- **Recommended Action:** monitor

#### [#63: chore(deps-dev): bump brace-expansion from 1.1.12 to 1.1.16](https://github.com/tsd-ui/tsd-ui/pull/63)
- **Risk Score:** 0 / 100
- **Priority:** low
- **Reasons:**
  - none
- **Recommended Action:** monitor

#### [#64: chore(deps): bump postcss from 8.5.8 to 8.5.21](https://github.com/tsd-ui/tsd-ui/pull/64)
- **Risk Score:** 0 / 100
- **Priority:** low
- **Reasons:**
  - none
- **Recommended Action:** monitor

#### [#58: chore(deps-dev): bump markdown-it from 14.1.1 to 14.3.0](https://github.com/tsd-ui/tsd-ui/pull/58)
- **Risk Score:** 0 / 100
- **Priority:** low
- **Reasons:**
  - none
- **Recommended Action:** monitor

### [tsd-ui/tsd-ui-team-docs](https://github.com/tsd-ui/tsd-ui-team-docs) — 14 open PR(s)

#### [#13: chore(deps): bump react and @types/react](https://github.com/tsd-ui/tsd-ui-team-docs/pull/13)
- **Risk Score:** 56 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - large-diff-over-1000-lines (+15)
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** deep-review

#### [#19: chore(deps): bump @docusaurus/theme-mermaid from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/19)
- **Risk Score:** 51 / 100
- **Priority:** high
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10)
  - large-diff-over-200-lines (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** deep-review

#### [#23: chore(deps): bump react-dom from 18.3.1 to 19.2.5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/23)
- **Risk Score:** 41 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#24: chore(ci): bump actions/upload-pages-artifact from 3 to 5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/24)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - security-sensitive-workflow-files (+15)
  - deployment-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#17: chore(ci): bump actions/deploy-pages from 4 to 5](https://github.com/tsd-ui/tsd-ui-team-docs/pull/17)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - security-sensitive-workflow-files (+15)
  - deployment-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#3: chore(ci): bump actions/checkout from 4 to 6](https://github.com/tsd-ui/tsd-ui-team-docs/pull/3)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - security-sensitive-workflow-files (+15)
  - deployment-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#2: chore(ci): bump actions/setup-node from 4 to 6](https://github.com/tsd-ui/tsd-ui-team-docs/pull/2)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - security-sensitive-workflow-files (+15)
  - deployment-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#21: chore(deps): bump @docusaurus/types from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/21)
- **Risk Score:** 31 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-200-lines (+10)
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#22: chore(deps): bump @docusaurus/tsconfig from 3.6.0 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/22)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#20: chore(deps): bump @docusaurus/module-type-aliases from 3.9.2 to 3.10.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/20)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#18: chore(deps): bump typescript from 5.6.3 to 6.0.2](https://github.com/tsd-ui/tsd-ui-team-docs/pull/18)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#8: chore(deps): bump prism-react-renderer from 2.3.1 to 2.4.1](https://github.com/tsd-ui/tsd-ui-team-docs/pull/8)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#6: chore(deps): bump @mdx-js/react from 3.0.1 to 3.1.1](https://github.com/tsd-ui/tsd-ui-team-docs/pull/6)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#4: chore(deps): bump docusaurus-lunr-search from 3.4.0 to 3.6.0](https://github.com/tsd-ui/tsd-ui-team-docs/pull/4)
- **Risk Score:** 21 / 100
- **Priority:** low
- **Reasons:**
  - release-change (+10)
  - stale-over-14-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

### [tsd-ui/tsd-ui-template](https://github.com/tsd-ui/tsd-ui-template) — 6 open PR(s)

#### [#9: bump the server-dependencies group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/9)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-500-lines (+15)
  - release-change (+10)
  - stale-over-7-days (+8)
  - force-pushes-over-2 (+3)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#8: bump the rollup group across 1 directory with 2 updates](https://github.com/tsd-ui/tsd-ui-template/pull/8)
- **Risk Score:** 39 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-500-lines (+15)
  - release-change (+10)
  - stale-over-7-days (+8)
  - force-pushes-over-2 (+3)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#13: bump actions/checkout from 6 to 7](https://github.com/tsd-ui/tsd-ui-template/pull/13)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - security-sensitive-workflow-files (+15)
  - deployment-change (+10)
  - stale-over-7-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#12: bump the linting group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/12)
- **Risk Score:** 36 / 100
- **Priority:** medium
- **Reasons:**
  - large-diff-over-500-lines (+15)
  - release-change (+10)
  - stale-over-7-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** scan-review

#### [#11: bump the patternfly group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/11)
- **Risk Score:** 29 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-over-1000-lines (+15)
  - stale-over-7-days (+8)
  - force-pushes-1 (+3)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

#### [#14: bump the tools group across 1 directory with 4 updates](https://github.com/tsd-ui/tsd-ui-template/pull/14)
- **Risk Score:** 26 / 100
- **Priority:** low
- **Reasons:**
  - large-diff-over-1000-lines (+15)
  - stale-over-7-days (+8)
  - no-reviews-yet (+3)
- **Recommended Action:** monitor

## Upstream Dependencies — Changes to Watch

> These are repositories the team depends on but does not maintain. They are listed
> for awareness: track changes that could affect the team's own repos. Do not review
> or merge these PRs — assess whether the upstream change warrants action downstream.

### [securesign/rhtas-console](https://github.com/securesign/rhtas-console) — 2 open PR(s)

#### [#95: Update Docker Images](https://github.com/securesign/rhtas-console/pull/95)
- **Risk Score:** 38 / 100
- **Priority:** medium
- **Reasons:**
  - ci-pending (+5)
  - security-sensitive-dockerfile (+15)
  - deployment-change (+10)
  - force-pushes-over-2 (+5)
  - no-reviews-yet (+3)
- **Impact Note:** Dockerfile updates may require console-ui to rebuild against new base images if deployed together in the same environment.
- **Recommended Action:** watch

#### [#85: Update Go Dependencies](https://github.com/securesign/rhtas-console/pull/85)
- **Risk Score:** 38 / 100
- **Priority:** medium
- **Reasons:**
  - ci-failing (+20)
  - release-change (+10)
  - force-pushes-over-2 (+5)
  - no-reviews-yet (+3)
- **Impact Note:** Failed go.mod dependency update may indicate incompatible API changes that could affect downstream integration if the console API is consumed by console-ui.
- **Recommended Action:** watch
