# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-24 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-24 06:00:31 |
| Status | 0 failures (collection errors across 8 repos) |

## Summary

All tracked repos returned collection errors. No CI build data was available for analysis. This likely indicates a GitHub API authentication or rate-limiting issue with the collector script.

## Collection Errors

### [securesign/rhtas-console dependency](https://github.com/securesign/rhtas-console)

> **Collection issue:** error — Failed to query repo API

### [securesign/rhtas-console-ui maintained](https://github.com/securesign/rhtas-console-ui)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/conforma-policy-test maintained](https://github.com/tsd-ui/conforma-policy-test)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/devtools maintained](https://github.com/tsd-ui/devtools)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-agent-lab maintained](https://github.com/tsd-ui/tsd-agent-lab)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui maintained](https://github.com/tsd-ui/tsd-ui)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui-plugin maintained](https://github.com/tsd-ui/tsd-ui-plugin)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui-template maintained](https://github.com/tsd-ui/tsd-ui-template)

> **Collection issue:** error — Failed to query repo API

## Diagnosis (model assessment)

**Category:** infra-problem  
**Confidence:** probable  
**Root cause:** The collector script failed to query the GitHub API for all 8 monitored repositories. This is likely due to one of:
- Missing or expired `GITHUB_TOKEN` environment variable
- GitHub API rate limiting
- Network connectivity issues
- Incorrect API endpoint or authentication method

**Suggested next step:** 
1. Verify the collector script has a valid `GITHUB_TOKEN` configured
2. Check GitHub API rate limit status: `gh api rate_limit`
3. Review collector script logs for the actual HTTP error response
4. Ensure the collector has read permissions for the target repositories

## Notes

This report reflects a complete collection failure rather than CI build failures. The collector infrastructure must be fixed before build health can be assessed.
