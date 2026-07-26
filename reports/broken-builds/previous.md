# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-26 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-26 06:00:25 |
| Status | All builds passing |

## Summary

All builds passing.

However, 8 repositories experienced collection errors and could not be checked:
- securesign/rhtas-console dependency
- securesign/rhtas-console-ui maintained
- tsd-ui/conforma-policy-test maintained
- tsd-ui/devtools maintained
- tsd-ui/tsd-agent-lab maintained
- tsd-ui/tsd-ui maintained
- tsd-ui/tsd-ui-plugin maintained
- tsd-ui/tsd-ui-template maintained

## Collection Issues

### securesign/rhtas-console dependency

> **Collection issue:** error — Failed to query repo API

### securesign/rhtas-console-ui maintained

> **Collection issue:** error — Failed to query repo API

### tsd-ui/conforma-policy-test maintained

> **Collection issue:** error — Failed to query repo API

### tsd-ui/devtools maintained

> **Collection issue:** error — Failed to query repo API

### tsd-ui/tsd-agent-lab maintained

> **Collection issue:** error — Failed to query repo API

### tsd-ui/tsd-ui maintained

> **Collection issue:** error — Failed to query repo API

### tsd-ui/tsd-ui-plugin maintained

> **Collection issue:** error — Failed to query repo API

### tsd-ui/tsd-ui-template maintained

> **Collection issue:** error — Failed to query repo API

---

## Diagnosis (model assessment)

**Category:** infra-problem

**Confidence:** probable

**Root cause:** The collector failed to query the GitHub repository API for all 8 repositories with identical error messages. The repo names include suffixes like "dependency" and "maintained" which are not standard GitHub repository naming patterns. This suggests either:
1. The repo list configuration contains malformed repository identifiers
2. The GitHub API token lacks access permissions to these repositories
3. The repository names are incorrectly formatted (mixing org/repo with additional labels)

**Suggested next step:** 
1. Verify the repository list configuration file contains valid GitHub repository identifiers in the format `org/repo` (without additional labels like "dependency" or "maintained")
2. If labels are metadata, ensure they're stored separately from the repository identifier
3. Test the GitHub API token with a simple query: `gh api repos/tsd-ui/tsd-agent-lab` to verify credentials and access
4. Check if these repositories exist and are accessible to the authenticated user

**Impact:** Unable to perform CI failure detection on any monitored repositories due to collection failure.
