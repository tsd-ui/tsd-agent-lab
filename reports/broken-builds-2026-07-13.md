# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-13 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-13 14:31:48 |
| Status | 20 failure(s) across 5 repo(s) |

## Summary

20 failure(s) across 5 repo(s).

10 unique failure signatures identified. Notable patterns: GitHub Pages deployment timeouts (rhtas-console-ui), recurring fullsend/triage token minting failures (conforma-policy-test), npm publishing auth issues (tsd-ui), and several cases where logs were unavailable (410 Gone) due to age.

## Findings

### securesign/rhtas-console

#### Failure: linter / golangci / golangci-lint (logs unavailable)

**Observed Evidence** (verbatim from CI)
- Run: [24129384700](https://github.com/securesign/rhtas-console/actions/runs/24129384700), [24128885958](https://github.com/securesign/rhtas-console/actions/runs/24128885958)
- Workflow: linter
- Job: golangci
- Step: golangci-lint
- SHA: 17b1b1034e3367e279c5dfa742d888552931955b, 4bf470904fbc616c9a6327f3a2a7cba855ff4ad6
- Started: 2026-04-08T09:55:30Z, 2026-04-08T09:43:33Z
- Log excerpt:
  ```
  {"message":"Server Error","documentation_url":"https://docs.github.com/rest/actions/workflow-jobs#download-job-logs-for-a-workflow-run","status":"410"}
  ```

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** The log excerpt is a GitHub API 410 (Gone) response, meaning the actual CI logs have expired and were unavailable at collection time. These runs are from April 2026 (~3 months old). The golangci-lint step failed, but the true failure reason cannot be determined from the available data.
- **Suggested next step:** Check if this workflow is currently passing on the default branch. If it is, these are stale failures and can be ignored. If still failing, trigger a fresh run and collect logs while they are available.

**Reproduction Status**
- 2 occurrences with same signature on the same date (2026-04-08), likely the same underlying issue
- Signature: `securesign/rhtas-console::linter::golangci::golangci-lint::{"message":"Server Error","documentation_url":"https://docs.github.com/rest/actions/workflow-jobs#download-job-logs-for-a-workflow-run","status":"410"}`

---

#### Failure: openapi / ui-pr (no step-level detail)

**Observed Evidence** (verbatim from CI)
- Run: [16968683504](https://github.com/securesign/rhtas-console/actions/runs/16968683504), [16742980946](https://github.com/securesign/rhtas-console/actions/runs/16742980946), [16313244252](https://github.com/securesign/rhtas-console/actions/runs/16313244252)
- Workflow: openapi
- Job: ui-pr
- Step: (none identified)
- SHA: 2958cb4ba12fb801121967b72aca6dbbba1aee2f, caa5d92df240382d38b456fdfda7bb2c0d3a6dbc, 6ae449c47bb71190d7a64ecd2b3e58ae32a73e8d
- Started: 2025-08-14T14:52:03Z, 2025-08-05T07:01:21Z, 2025-07-27T08:06:22Z
- Log excerpt: (none available — no failed steps were captured)

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** The job `ui-pr` failed but no specific step failure was captured, and no log excerpts are available. These runs are from July–August 2025 (~12 months old), so logs have long expired. The repeated failures across three different SHAs over three weeks suggest a persistent issue at the time.
- **Suggested next step:** Check if the `openapi` workflow is currently passing. These are very old failures and may have been resolved. If still failing, investigate the `ui-pr` job configuration.

**Reproduction Status**
- 3 occurrences spanning 2025-07-27 to 2025-08-14
- Signature: `securesign/rhtas-console::openapi::::unknown`

---

### securesign/rhtas-console-ui

#### Failure: Deploy to GH Pages / gh-pages / Deploy to GitHub Pages

**Observed Evidence** (verbatim from CI)
- Run: [28604785882](https://github.com/securesign/rhtas-console-ui/actions/runs/28604785882), [28603472215](https://github.com/securesign/rhtas-console-ui/actions/runs/28603472215)
- Workflow: Deploy to GH Pages
- Job: gh-pages
- Step: Deploy to GitHub Pages
- SHA: c6e69bd881886fd298008b957acc939e2802874b, be33e9da0002ee3062edc9ae5f03d6402fcaed54
- Started: 2026-07-02T16:14:27Z, 2026-07-02T15:53:38Z
- Log excerpt (representative, both runs show the same pattern):
  ```
  Current status: deployment_queued
  ...
  ##[error]Timeout reached, aborting!
  ##[error]Timeout reached, aborting!
  Canceling Pages deployment...
  Canceled deployment with ID c6e69bd881886fd298008b957acc939e2802874b
  ```

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** confirmed
- **Root cause:** The GitHub Pages deployment remained stuck in `deployment_queued` status, polling every 5 seconds for the full timeout window (~2 minutes) before aborting. Both runs failed within ~20 minutes of each other on the same day (2026-07-02), indicating a GitHub Pages infrastructure issue — the Pages deployment backend was not processing the queue. This is external to the repository.
- **Suggested next step:** Check if subsequent deployments to GitHub Pages have succeeded. If this was a transient GitHub Pages outage on 2026-07-02, no action is needed. If deployments are still failing, check the GitHub Pages settings for the repository and verify the source branch/environment configuration. Consider re-running the workflow.

**Reproduction Status**
- 2 occurrences on 2026-07-02, ~20 minutes apart
- Signature: `securesign/rhtas-console-ui::Deploy to GH Pages::gh-pages::Deploy to GitHub Pages::Cleaning up orphan processes`

---

#### Failure: CI (e2e) / e2e-integration-tests / Run Playwright tests

**Observed Evidence** (verbatim from CI)
- Run: [28577442879](https://github.com/securesign/rhtas-console-ui/actions/runs/28577442879)
- Workflow: CI (e2e)
- Job: run-e2e-ci / e2e-integration-tests
- Step: Run Playwright tests
- SHA: 6377d57067f11840e30b97551f55068aee425f6e
- Started: 2026-07-02T08:47:37Z
- Log excerpt:
  ```
  await expect(page.locator('[aria-label="Rekor Entries toolbar"]')).toBeVisible();
  ...
  at verify_search_page_has_main_sections (/home/runner/work/rhtas-console-ui/rhtas-console-ui/e2e/tests/pages/rekor-search/search.spec.ts:10:73)
  ...
  1 failed
    [chromium] › tests/pages/rekor-search/search.spec.ts:15:7 › Rekor Search UI › Search by email ──
  41 passed (9.8m)
  ```

- Run: [28176356788](https://github.com/securesign/rhtas-console-ui/actions/runs/28176356788)
- Workflow: CI (e2e)
- Job: run-e2e-ci / e2e-integration-tests
- Step: Run Playwright tests
- SHA: 9adad7a2ee3039bf94edebd4f62f559de245cb72
- Started: 2026-06-25T14:11:41Z
- Log excerpt:
  ```
  2 failed
    [chromium] › tests/pages/artifacts/accessibility.spec.ts:13:7 › Artifacts page Accessibility › Page view after search
    [chromium] › tests/pages/artifacts/accessibility.spec.ts:20:7 › Artifacts page Accessibility › Page view after expanding signature
  3 flaky
    [chromium] › tests/pages/artifacts/accessibility.spec.ts:35:7 › Artifacts page Accessibility › Page view after expanding attestation
    [chromium] › tests/pages/artifacts/verification.spec.ts:67:7 › Artifacts Verification Flow › User has clear indicator of verification status per signature
    [chromium] › tests/pages/trust-root/certificates.spec.ts:13:7 › Trust Root - Certificates › Pagination
  37 passed (9.2m)
  ```

Additionally, run 28577442879 also failed the coverage job:
- Job: run-e2e-coverage / coverage
- Step: Tests with coverage
- Log excerpt:
  ```
  [chromium] › tests/pages/rekor-search/search.spec.ts:22:7 › Rekor Search UI › Search by hash ───
  39 passed (27.3m)
  ```

**Diagnosis** (model assessment)
- **Category:** flaky-test
- **Confidence:** probable
- **Root cause:** Different Playwright e2e tests fail on different runs — `Search by email` on 07-02, `Accessibility` tests on 06-25, `Search by hash` on the coverage run. The 06-25 run also reported 3 explicitly "flaky" tests. The fact that different tests fail each time, and the tests involve UI element visibility checks (e.g., waiting for `[aria-label="Rekor Entries toolbar"]` to be visible), strongly suggests test flakiness related to timing/rendering rather than a consistent code bug. The high pass rate (37–41 out of 42) supports this.
- **Suggested next step:** Review the failing tests for timing-sensitive assertions. Consider adding explicit waits or increasing timeouts for element visibility checks. The `search.spec.ts` and `accessibility.spec.ts` tests appear most prone to flakiness. Adding retry configuration in Playwright config may reduce false negatives.

**Reproduction Status**
- 2 occurrences (2026-06-25, 2026-07-02) with different failing tests each time
- Signature: `securesign/rhtas-console-ui::CI (e2e)::run-e2e-ci / e2e-integration-tests::Run Playwright tests::Cleaning up orphan processes`

---

#### Failure: CI (e2e) / check-images / Check server_db_image image exists

**Observed Evidence** (verbatim from CI)
- Run: [28511728347](https://github.com/securesign/rhtas-console-ui/actions/runs/28511728347)
- Workflow: CI (e2e)
- Job: run-e2e-coverage / check-images
- Step: Check server_db_image image exists
- SHA: ebfe3e6ce212155f6a0edfdb7ba9d140ffcbf0d3
- Started: 2026-07-01T10:42:12Z
- Log excerpt:
  ```
  Image does not exist locally
  failed to configure transport: error pinging v2 registry: Get "https://registry-1.docker.io/v2/": context deadline exceeded
  ##[error]Process completed with exit code 1.
  ```

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** confirmed
- **Root cause:** The CI job attempted to pull/inspect `docker.io/library/mariadb:10.5` from Docker Hub, but the connection to `registry-1.docker.io` timed out ("context deadline exceeded"). This is a network connectivity issue between the GitHub Actions runner and Docker Hub — either a transient Docker Hub outage or network restriction on the runner.
- **Suggested next step:** Check if this is a recurring issue. If so, consider caching the `mariadb:10.5` image in a private registry (e.g., GHCR) to avoid Docker Hub rate limits and connectivity issues. A single occurrence likely indicates a transient network problem.

**Reproduction Status**
- First seen (1 occurrence on 2026-07-01)
- Signature: `securesign/rhtas-console-ui::CI (e2e)::run-e2e-coverage / check-images::Check server_db_image image exists::Cleaning up orphan processes`

---

### tsd-ui/conforma-policy-test

#### Failure: fullsend / dispatch / Triage / Mint triage token

**Observed Evidence** (verbatim from CI)
- Run: [28162819107](https://github.com/tsd-ui/conforma-policy-test/actions/runs/28162819107), [27759860180](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27759860180), [27625553481](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27625553481), [27623488109](https://github.com/tsd-ui/conforma-policy-test/actions/runs/27623488109)
- Workflow: fullsend
- Job: dispatch / Triage / Triage
- Step: Mint triage token
- SHA: a47c9eec25ee1f00d4a785916dcea21d532802c2 (2 runs), d40b0706f1884f33d87496fe071cd7060a2ab06b, 54fabe16e78e969ec78a368966b0eaebf93fb74a
- Started: 2026-06-25T10:09:52Z, 2026-06-18T12:36:18Z, 2026-06-16T14:56:54Z, 2026-06-16T14:57:11Z
- Log excerpt (all 4 runs show only post-job cleanup — the actual failure output was not captured):
  ```
  /home/runner/work/conforma-policy-test/conforma-policy-test/.defaults
  Removing SSH command configuration
  [command]/usr/bin/git config --local --name-only --get-regexp core\.sshCommand
  ...
  Cleaning up orphan processes
  ```

**Diagnosis** (model assessment)
- **Category:** config-error
- **Confidence:** possible
- **Root cause:** The "Mint triage token" step is consistently failing across 4 runs over 10 days (June 16–25), spanning multiple commits. The actual error is not visible in the log excerpts — only post-job cleanup (git credential removal) is shown, meaning the failure output was either truncated or occurred earlier in the step. The step name "Mint triage token" suggests it is creating a GitHub App or fine-grained token for triage operations. The consistent failure across multiple SHAs and dates points to a configuration or secrets issue (e.g., expired GitHub App credentials, missing secrets, or incorrect permissions) rather than a code change.
- **Suggested next step:** Manually inspect one of the recent run logs in the GitHub UI to see the actual error output from the "Mint triage token" step. Verify that the GitHub App or token used for triage operations has valid credentials and correct permissions. Check if any repository secrets have expired.

**Reproduction Status**
- 4 occurrences spanning 2026-06-16 to 2026-06-25
- Signature: `tsd-ui/conforma-policy-test::fullsend::dispatch / Triage / Triage::Mint triage token::Cleaning up orphan processes`

---

### tsd-ui/tsd-ui

#### Failure: Release / release / Publish to npm

**Observed Evidence** (verbatim from CI)
- Run: [26500983210](https://github.com/tsd-ui/tsd-ui/actions/runs/26500983210)
- Workflow: Release
- Job: release
- Step: Publish to npm
- SHA: a72636152d0c1c30b982e77d7e24965bdc565bb4
- Started: 2026-05-27T08:48:38Z
- Log excerpt:
  ```
  npm notice Publishing to https://registry.npmjs.org/ with tag latest and public access
  npm error code E403
  npm error 403 403 Forbidden - PUT https://registry.npmjs.org/@tsd-ui%2fcore - Two-factor authentication or granular access token with bypass 2fa enabled is required to publish packages.
  npm error 403 In most cases, you or one of your dependencies are requesting
  npm error 403 a package version that is forbidden by your security policy, or
  npm error 403 on a server you do not have access to.
  ```

**Diagnosis** (model assessment)
- **Category:** config-error
- **Confidence:** confirmed
- **Root cause:** The npm publish step failed because the npm auth token (`NODE_AUTH_TOKEN`) used in CI does not have 2FA bypass enabled. npm requires either interactive 2FA or a granular access token with "bypass 2fa" permission to publish `@tsd-ui/core`. The token was successfully created (git tag push and GitHub release creation succeeded earlier in the same step), but the npm token lacks the required permission level.
- **Suggested next step:** Generate a new npm granular access token with "bypass 2fa" enabled, or use an automation token type, and update the `NODE_AUTH_TOKEN` repository secret. Note: the git tag `v0.3.0` and GitHub release were already created before this step failed, so those may need cleanup if the release is re-attempted.

**Reproduction Status**
- First seen (1 occurrence on 2026-05-27)
- Signature: `tsd-ui/tsd-ui::Release::release::Publish to npm::Cleaning up orphan processes`

---

#### Failure: Release / release / Update package versions

**Observed Evidence** (verbatim from CI)
- Run: [26445057499](https://github.com/tsd-ui/tsd-ui/actions/runs/26445057499)
- Workflow: Release
- Job: release
- Step: Update package versions
- SHA: b8d24429929be30194655d4c2ee94c1c18554be9
- Started: 2026-05-26T09:48:47Z
- Log excerpt:
  ```
  npm error code E404
  npm error 404 Not Found - GET https://registry.npmjs.org/@tsd-ui%2fcore - Not found
  npm error 404
  npm error 404  '@tsd-ui/core@^0.2.0' is not in this registry.
  npm error 404
  npm error 404 Note that you can also install from a
  npm error 404 tarball, folder, http url, or git url.
  ```

**Diagnosis** (model assessment)
- **Category:** config-error
- **Confidence:** confirmed
- **Root cause:** After `npm version "0.3.0" --workspaces --no-git-tag-version` successfully bumped all workspace package versions, a subsequent `npm install` (or dependency resolution) failed because `@tsd-ui/core@^0.2.0` was not found on the npm registry. This indicates the package had never been successfully published to npm — the workspace packages reference each other via registry versions rather than workspace protocol (`workspace:*`), so npm tries to fetch them from the registry during install. This is a chicken-and-egg problem in the release workflow.
- **Suggested next step:** Update the workspace `package.json` files to use workspace protocol references (e.g., `"@tsd-ui/core": "workspace:*"`) for internal dependencies, and configure the build tool to resolve these to actual versions at publish time. Alternatively, ensure initial package versions are published before running the release workflow. This failure preceded the E403 failure on 2026-05-27 chronologically — the 2FA issue was discovered on the subsequent attempt.

**Reproduction Status**
- First seen (1 occurrence on 2026-05-26)
- Signature: `tsd-ui/tsd-ui::Release::release::Update package versions::Cleaning up orphan processes`

---

#### Failure: CodeQL / analyze (javascript-typescript) (logs unavailable)

**Observed Evidence** (verbatim from CI)
- Run: [22668915790](https://github.com/tsd-ui/tsd-ui/actions/runs/22668915790)
- Workflow: CodeQL
- Job: analyze (javascript-typescript)
- Step: Run github/codeql-action/analyze@v3
- SHA: 9a2800cfaca2cbe53215f48f9cd2a3b15c8fa605
- Started: 2026-03-04T12:15:22Z
- Log excerpt:
  ```
  {"message":"Server Error","documentation_url":"https://docs.github.com/rest/actions/workflow-jobs#download-job-logs-for-a-workflow-run","status":"410"}
  ```

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** The log excerpt is a GitHub API 410 (Gone) response — the actual CI logs have expired. This run is from March 2026 (~4 months old). The CodeQL analysis step failed, but the true failure reason cannot be determined.
- **Suggested next step:** Check if the CodeQL workflow is currently passing. If so, this was a transient issue that has been resolved. If still failing, trigger a fresh run.

**Reproduction Status**
- First seen (1 occurrence on 2026-03-04)
- Signature: `tsd-ui/tsd-ui::CodeQL::analyze (javascript-typescript)::Run github/codeql-action/analyze@v3::{"message":"Server Error","documentation_url":"https://docs.github.com/rest/actions/workflow-jobs#download-job-logs-for-a-workflow-run","status":"410"}`

---

### tsd-ui/tsd-ui-team-docs

#### Failure: Deploy to GitHub Pages / Build Docs (no step-level detail)

**Observed Evidence** (verbatim from CI)
- Run: [21143581622](https://github.com/tsd-ui/tsd-ui-team-docs/actions/runs/21143581622), [21143568295](https://github.com/tsd-ui/tsd-ui-team-docs/actions/runs/21143568295), [21142005080](https://github.com/tsd-ui/tsd-ui-team-docs/actions/runs/21142005080)
- Workflow: Deploy to GitHub Pages
- Job: Build Docs
- Step: (none identified)
- SHA: 97411f234dfaad096ddca2c3cf421f29805cf556, f577351a43c6fc03972b82fd9666cecb1602355f, 08e4ba696b1af14169af84ab024b1dd8c370289e
- Started: 2026-01-19T15:47:04Z, 2026-01-19T15:46:41Z, 2026-01-19T14:56:07Z
- Log excerpt: (none available — no failed steps were captured)

**Diagnosis** (model assessment)
- **Category:** unknown
- **Confidence:** insufficient-evidence
- **Root cause:** The "Build Docs" job failed 3 times on the same day (2026-01-19) across three different commits, but no specific step failure was captured and no log excerpts are available. The runs are ~6 months old. The rapid succession (two runs within 23 seconds of each other) suggests these may have been triggered by quick successive pushes during active development.
- **Suggested next step:** Check if the Deploy to GitHub Pages workflow is currently passing. These failures are from January 2026 and are very likely stale. If the workflow is currently healthy, no action is needed.

**Reproduction Status**
- 3 occurrences on 2026-01-19
- Signature: `tsd-ui/tsd-ui-team-docs::📕  Deploy to GitHub Pages::::unknown`
