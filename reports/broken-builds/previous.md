# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-21 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-21 06:00:25 |
| Status | 0 failures (collection errors: 9 repos) |

## Summary

All monitored repos encountered collection errors. No CI failure data was successfully retrieved. This indicates a systemic issue with the GitHub API collection process rather than actual CI build failures.

## Collection Errors

All 9 repos failed to collect data with error: "Failed to query repo API"

Affected repos:
- [securesign/rhtas-console dependency](https://github.com/securesign/rhtas-console)
- [securesign/rhtas-console-ui maintained](https://github.com/securesign/rhtas-console-ui)
- [tsd-ui/conforma-policy-test maintained](https://github.com/tsd-ui/conforma-policy-test)
- [tsd-ui/devtools maintained](https://github.com/tsd-ui/devtools)
- [tsd-ui/tsd-agent-lab maintained](https://github.com/tsd-ui/tsd-agent-lab)
- [tsd-ui/tsd-ui maintained](https://github.com/tsd-ui/tsd-ui)
- [tsd-ui/tsd-ui-plugin maintained](https://github.com/tsd-ui/tsd-ui-plugin)
- [tsd-ui/tsd-ui-team-docs maintained](https://github.com/tsd-ui/tsd-ui-team-docs)
- [tsd-ui/tsd-ui-template maintained](https://github.com/tsd-ui/tsd-ui-template)

**Diagnosis** (model assessment)
- **Category:** infra-problem
- **Confidence:** confirmed
- **Root cause:** The GitHub API collector script failed to authenticate or reach the GitHub API for all monitored repos. This is likely due to:
  - Missing or expired GitHub token (GITHUB_TOKEN environment variable)
  - Network connectivity issue
  - GitHub API rate limiting
  - Incorrect repository names or permissions
- **Suggested next step:** Check the collector script logs for the underlying HTTP error. Verify that GITHUB_TOKEN is set and valid. Test GitHub API connectivity with: `gh api user` or `curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user`

## Notes

This report documents a collection failure, not CI build failures. The monitoring system cannot assess build health until the collection issue is resolved.
