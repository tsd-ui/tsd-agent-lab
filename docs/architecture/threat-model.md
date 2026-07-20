# Threat Model

## Overview

This threat model analyzes security risks in the TSD Agent Lab from the perspective of a corporate engineering environment. It focuses on preventing production impact, credential leakage, and policy violations while enabling productive experimentation.

**Scope**: Local agentic SDLC lab for multi-org GitHub access  
**Threat Modeling Framework**: STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege)  
**Risk Tolerance**: Prototype lab environment, prioritize learning over perfection  
**Review Date**: 2026-06-12  

## Trust Boundaries

```
┌─────────────────────────────────────────────────────────────┐
│ Engineering Workstation (Trusted Host)                      │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │ Primary User Account (High Trust)                  │    │
│  │ - Production credentials                           │    │
│  │ - VPN access                                       │    │
│  │ - Internal systems                                 │    │
│  └────────────────────────────────────────────────────┘    │
│                           │                                  │
│              Trust Boundary (OS-level isolation)            │
│                           │                                  │
│  ┌────────────────────────────────────────────────────┐    │
│  │ Agent User Account (Low Trust)                     │    │
│  │ - Lab credentials only                             │    │
│  │ - No VPN access                                    │    │
│  │ - Public internet only                             │    │
│  │                                                     │    │
│  │  ┌──────────────────────────────────────────┐     │    │
│  │  │ Agent Process (Untrusted)                │     │    │
│  │  │ - Claude Code / Superpowers / OpenCode   │     │    │
│  │  │ - Executes AI-generated code             │     │    │
│  │  │ - Policy-constrained                     │     │    │
│  │  └──────────────────────────────────────────┘     │    │
│  └────────────────────────────────────────────────────┘    │
│                           │                                  │
│              Trust Boundary (Network)                       │
│                           │                                  │
└───────────────────────────┼──────────────────────────────────┘
                            │
          ┌─────────────────┴─────────────────┐
          │                                   │
    GitHub.com                          Public Internet
    (External)                          (Untrusted)
```

## Threat Actors

### TA1: Compromised Agent Tool
- **Profile**: Malicious update to Claude Code, Superpowers, or OpenCode
- **Capability**: Full control of agent process
- **Motivation**: Data exfiltration, credential theft, backdoor installation
- **Likelihood**: Low (trusted vendors, but supply chain risk exists)

### TA2: Malicious AI Output
- **Profile**: AI model generates malicious code (accidental or adversarial)
- **Capability**: Code injection, privilege escalation attempts
- **Motivation**: N/A (emergent behavior, not intentional)
- **Likelihood**: Medium (AI hallucinations, unexpected behaviors)

### TA3: Insider Misuse
- **Profile**: Team member intentionally bypassing controls
- **Capability**: Full access to lab environment, policy modification
- **Motivation**: Shortcuts, curiosity, malicious intent
- **Likelihood**: Low (small trusted team, but human error is real)

### TA4: External Attacker
- **Profile**: Remote attacker compromising workstation or GitHub account
- **Capability**: Depends on entry point and privilege level
- **Motivation**: Data theft, lateral movement, persistence
- **Likelihood**: Low (standard corporate security controls apply)

### TA5: Accidental Operator Error
- **Profile**: Team member makes configuration or operational mistake
- **Capability**: Unintentional policy violation, credential exposure
- **Motivation**: N/A (accident)
- **Likelihood**: High (expected in experimental environment)

## Critical Threats

### CT1: Production Credential Leakage

**Attack Vector**: Agent gains access to production credentials through:
- Shared credential store
- Environment variable inheritance
- Password manager access
- Token reuse across accounts

**Impact**: HIGH  
- Production system compromise
- Data breach
- Service disruption
- Compliance violation

**Mitigations**:
1. **Primary**: Dedicated user account with isolated credential store
   - Separate `~/.ssh`, `~/.aws`, `~/.config` directories
   - No access to password managers (1Password, LastPass, etc.)
   - Explicit environment variable control (see `default-policy.yaml`)
   
2. **Secondary**: Token scoping
   - Lab tokens limited to specific repositories
   - Read-only access where possible
   - Short expiration times (30-90 days)
   
3. **Tertiary**: Credential scanning
   - Pre-commit hooks for secret detection
   - Log scanning for credential patterns
   - Regular audit of environment variables

**Detection**:
- Monitor for authentication attempts to production systems
- Alert on credential file access from agent user
- Track environment variable usage in logs
- Review failed authentication logs

**Residual Risk**: LOW  
With OS-level isolation and scoped tokens, risk is minimal.

### CT2: Unauthorized Repository Access

**Attack Vector**: Agent accesses GitHub repositories outside allowlist through:
- Overly broad token permissions
- Cross-org repository inference
- Typo-squatting repository names
- Hardcoded URLs in prompts

**Impact**: MEDIUM  
- Unauthorized code access
- Cross-org policy violation
- Confidential information disclosure
- Compliance issues

**Mitigations**:
1. **Primary**: Repository allowlist enforcement (see `repo-allowlist.example.yaml`)
   - Explicit per-org repository list
   - Pattern-based allowlist for known prefixes
   - Default-deny for unknown repositories
   - Pre-execution validation
   
2. **Secondary**: Token scope limitation
   - Fine-grained GitHub PAT with specific repo access
   - Separate tokens per organization
   - Regular token rotation
   
3. **Tertiary**: Audit logging
   - Log all `git clone`, `gh repo view` operations
   - Alert on allowlist violations
   - Weekly review of accessed repositories

**Detection**:
- Allowlist violation logs
- Unexpected clone operations
- Cross-org boundary crossing attempts
- Repository access outside work hours

**Residual Risk**: LOW  
Allowlist enforcement provides strong control, though human override is possible.

### CT3: Malicious Code Execution via PR

**Attack Vector**: Agent creates PR containing:
- Backdoor code
- Credential harvesting scripts
- Data exfiltration logic
- Privilege escalation exploits

**Impact**: MEDIUM  
- Codebase compromise
- Future vulnerability introduction
- Trust erosion in AI tools
- Security incident

**Mitigations**:
1. **Primary**: Human code review (mandatory)
   - Checklist-based review process (see `docs/admin/operator-checklist.md`)
   - Focus on security-sensitive patterns
   - Explicit approval required for merge
   - No auto-merge under any circumstances
   
2. **Secondary**: Command allowlist (see `command-allowlist.yaml`)
   - Block execution of generated scripts in PR validation
   - Prevent shell command injection
   - Restrict file system access during PR creation
   
3. **Tertiary**: Static analysis
   - Secret scanning on all commits
   - Linter enforcement
   - Dependency vulnerability checks

**Detection**:
- Code review catches malicious patterns
- Pre-commit hooks flag suspicious code
- Anomaly detection in PR contents (unusual languages, obfuscation)

**Residual Risk**: MEDIUM  
Sophisticated attacks may bypass human review; defense in depth required.

### CT4: Comment-Triggered Workflow Abuse

**Attack Vector**: Attacker posts GitHub issue/PR comment to trigger agent action:
- `/agent review` or similar command in comment
- Malicious prompt injection in PR body or diff
- Social engineering team members to comment
- Compromised collaborator account posting trigger comments

**Impact**: MEDIUM
- Unauthorized workflow execution
- Resource consumption
- Privilege escalation attempts
- PR spam or manipulation

**Mitigations**:
1. **Primary**: Polling-based discovery (no inbound webhooks, no exposed endpoints,
   no GitHub App — agent pulls on schedule, never receives pushes)
   - No webhook endpoints to attack or spoof
   - No GitHub App installation with event subscriptions
   - Agent polls on a cron schedule, discovering comments after the fact
   - No real-time trigger surface for attackers to exploit

2. **Secondary**: Static commenter allowlist (`policies/bot-commenter-allowlist.yaml`)
   plus `author_association` check (COLLABORATOR, MEMBER, OWNER)
   - Only comments from explicitly allowlisted users are processed
   - `author_association` must be COLLABORATOR, MEMBER, or OWNER
   - External contributors and anonymous users ignored entirely
   - Allowlist is version-controlled and requires PR review to change

3. **Tertiary**: Review-only mode — agent runs with `--disallowedTools` blocking
   Edit, Write, push, PR/issue mutations, and outbound network; `--max-budget-usd 2`
   cost cap; detached HEAD worktree (no branch to push)
   - Agent cannot modify files, push commits, or mutate PR state
   - Output limited to review comments on the PR
   - Cost bounded to $2 per review invocation
   - Detached HEAD worktree prevents accidental pushes

4. **Quaternary**: Rate limiting — per-user and global rate limits prevent cost
   exhaustion; rate-limited users get visible feedback
   - Per-user rate limits prevent a single account from exhausting budget
   - Global rate limits cap total review invocations per time window
   - Rate-limited requests produce visible feedback (comment or skip)
   - Prevents runaway cost from compromised or misbehaving accounts

5. **Quinary**: Containment — prompt injection via PR content is mitigated by
   structured prompt composition (safety preamble + task prompt), tool restrictions
   preventing code execution of injected commands, and review-only output that is
   human-reviewed before action
   - Safety preamble establishes agent constraints before PR content is seen
   - Tool restrictions prevent execution of any injected commands
   - Review output is posted as PR comments, visible to humans before action
   - No autonomous code changes or merges result from reviews

**Detection**:
- Polling logs record every discovered comment and processing decision
- Rate limit hits logged with user and timestamp
- Allowlist rejections logged for audit
- Review cost tracked per invocation and per user
- Anomalous comment volume detectable via rate limit metrics

**Residual Risk**: LOW
Polling-based review triggers accept controlled risk. A compromised collaborator
account could trigger reviews, but the review-only tool restriction, cost cap, and
rate limiting bound the blast radius to wasted compute ($2/review) and potentially
misleading review comments. No code mutation, no push, no external network access.

> **Note**: `/agent fix` and other write-mode triggers remain out of scope and would
> require a separate threat-model amendment before implementation. This CT4 amendment
> covers only polling-based, review-only triggers (`/agent review`).

### CT5: Autonomous Protected Branch Modification

**Attack Vector**: Agent attempts to:
- Force push to `main` or protected branches
- Bypass branch protection rules
- Auto-merge without review
- Amend commits after PR approval

**Impact**: HIGH  
- Code integrity loss
- Audit trail corruption
- Compliance violation
- Trust damage

**Mitigations**:
1. **Primary**: GitHub branch protection rules
   - Require PR for all changes to `main`
   - Require human review approval
   - Prevent force pushes
   - Require status checks
   
2. **Secondary**: Command allowlist blocks force push (see `command-allowlist.yaml`)
   - `git push --force` blocked
   - `git push -f` blocked
   - `git commit --amend` allowed only on feature branches
   
3. **Tertiary**: Audit logging
   - Log all git operations
   - Alert on protected branch access attempts
   - Track PR merge events

**Detection**:
- GitHub audit log for branch protection violations
- Command allowlist violation alerts
- Unexpected commits to `main`

**Residual Risk**: LOW  
GitHub native controls + local command blocking provide strong protection.

### CT6: Hidden Long-Running Processes

**Attack Vector**: Agent spawns background processes that:
- Continue after workflow completion
- Mine cryptocurrency
- Exfiltrate data over time
- Establish backdoor persistence

**Impact**: MEDIUM  
- Resource consumption
- Workstation compromise
- Long-term persistence
- Detection difficulty

**Mitigations**:
1. **Primary**: Process monitoring and cleanup
   - List all processes at workflow start/end
   - Kill all agent-spawned processes on completion
   - User session isolation (log out terminates all processes)
   
2. **Secondary**: Process allowlist
   - Only approved executables can run
   - Block `nohup`, `&`, background job operators
   - Prevent `screen` / `tmux` usage from agent context
   
3. **Tertiary**: Resource limits
   - CPU/memory limits on agent user account
   - Alert on sustained resource usage
   - Regular process audits

**Detection**:
- Process diff in logs (before/after workflow)
- Resource monitoring alerts
- Unexpected network connections
- Parent-less processes under agent user

**Residual Risk**: MEDIUM  
Detection relies on logging discipline; sophisticated persistence may evade.

### CT7: Cross-Organization Policy Violation

**Attack Vector**: Agent workflow violates org-specific policies:
- Uses patterns forbidden in Org A while working in Org B repo
- Commits code with org-inappropriate license
- Exposes Org A patterns in Org B repository
- Violates org-specific commit signing requirements

**Impact**: MEDIUM  
- Legal/compliance issues
- Contract violations
- Trust damage with partner organizations
- Intellectual property leakage

**Mitigations**:
1. **Primary**: Per-org policy files (see `repo-allowlist.example.yaml`)
   - Separate policy sections per GitHub organization
   - Org-specific command allowlists
   - Org-specific commit requirements
   - Validation before PR creation
   
2. **Secondary**: Manual operator awareness
   - Operator chooses policy for each workflow
   - Pre-flight checklist includes org verification
   - Review process includes org-specific checks
   
3. **Tertiary**: Repository metadata
   - `.github/CODEOWNERS` enforcement
   - License file validation
   - Commit signing enforcement per repo

**Detection**:
- Pre-commit hooks for policy violations
- Manual review catches inappropriate patterns
- Org admins may flag violations post-merge

**Residual Risk**: MEDIUM  
Requires operator discipline; automated enforcement is incomplete.

### CT8: Log Tampering or Deletion

**Attack Vector**: Agent or operator modifies audit logs to:
- Hide malicious activity
- Remove evidence of policy violations
- Evade detection
- Cover tracks after incident

**Impact**: MEDIUM  
- Reduced auditability
- Incident response difficulty
- Compliance violation
- Trust erosion

**Mitigations**:
1. **Primary**: Write-once log storage
   - Logs written with append-only permissions
   - Agent user cannot delete or modify logs
   - Primary user has read access for review
   
2. **Secondary**: Off-system log backup
   - Periodic copy to primary user account
   - Weekly backup to external storage
   - Consider GitHub repo for log archival
   
3. **Tertiary**: Log integrity checks
   - Hash logs at creation
   - Verify integrity during review
   - Alert on missing log files

**Detection**:
- File system audit logs (macOS `fsawatch` or similar)
- Log integrity check failures
- Missing expected log entries

**Residual Risk**: LOW  
Append-only permissions provide strong protection within single-user environment.

## Moderate Threats

### MT1: Resource Exhaustion (DoS)

**Attack Vector**: Agent consumes excessive resources through:
- Infinite loops in generated code
- Large file operations
- Fork bombs
- Memory leaks

**Impact**: LOW (workstation only, not production)

**Mitigations**:
- User-level CPU/memory limits (via `launchd` or `ulimit`)
- Workflow timeouts (kill after 1 hour)
- Disk quota on agent user home directory
- Manual kill capability

**Detection**:
- System resource monitoring
- Workflow timeout alerts
- Unresponsive workstation

**Residual Risk**: ACCEPTABLE  
Impact limited to single workstation; operator can recover.

### MT2: Network Exfiltration

**Attack Vector**: Agent sends data to external endpoints:
- Upload code to pastebin services
- Exfiltrate via DNS queries
- POST data to attacker-controlled servers
- WebSocket connections to C2 servers

**Impact**: MEDIUM  
- Information disclosure
- Intellectual property theft
- Compliance violation

**Mitigations**:
- No VPN access from agent user (prevents internal system access)
- Network monitoring (macOS Little Snitch or corporate proxy)
- Allowlist for permitted domains (GitHub, Anthropic API, package repos)
- Review network connections in logs

**Detection**:
- Unusual outbound connections
- Large data transfers
- Connections to unknown domains

**Residual Risk**: MEDIUM  
Public internet access required for tool functionality; some exfiltration risk remains.

### MT3: Dependency Confusion

**Attack Vector**: Agent installs malicious package through:
- Typo-squatted package names
- Public package with same name as internal package
- Malicious version of legitimate package

**Impact**: MEDIUM  
- Code execution in build process
- Credential theft
- Supply chain compromise

**Mitigations**:
- Review all dependency additions in PR review
- Use lock files (package-lock.json, Gemfile.lock, etc.)
- Package signature verification where available
- Allowlist for package sources

**Detection**:
- PR review catches unexpected dependencies
- Dependency scanning tools
- Build process anomalies

**Residual Risk**: MEDIUM  
Requires manual review; hard to fully automate.

### MT4: Prompt Injection in Logs

**Attack Vector**: Attacker places malicious content in:
- Commit messages reviewed by agent
- File contents read by agent
- Error messages from external tools
- Aim: Manipulate agent behavior in future workflows

**Impact**: LOW  
- Agent behavior manipulation
- Workflow corruption
- Unexpected outputs

**Mitigations**:
- Treat agent as untrusted (see CT3 mitigations)
- Human review validates all outputs
- No autonomous decision-making without human approval
- Log sanitization for sensitive patterns

**Detection**:
- Anomalous agent behavior
- Unusual prompts in logs
- Review process catches unexpected outputs

**Residual Risk**: ACCEPTABLE  
Human review mitigates; impact limited to single workflow.

## Known Weaknesses

### Documented Gaps

1. **Single-User Model**
   - Doesn't scale to full team concurrent usage
   - No multi-tenancy controls
   - Shared allowlists across all operators
   - **Mitigation**: Document as prototype limitation; future phases address

2. **Manual Enforcement Dependencies**
   - Relies on operator following pre-flight checklists
   - No automated policy enforcement engine (yet)
   - Human error possible
   - **Mitigation**: Checklist discipline, post-execution audits

3. **Incomplete Network Isolation**
   - Agent user has public internet access
   - No egress filtering (requires corporate infrastructure)
   - Exfiltration risk exists
   - **Mitigation**: Monitoring, log review, acceptable risk for prototype

4. **Limited Tool Diversity Validation**
   - Each tool (Claude Code, Superpowers, OpenCode) has different capabilities
   - Policies may not cover all tool-specific risks
   - **Mitigation**: Start with one tool, expand policies incrementally

5. **Log Storage on Same System**
   - Logs stored on same workstation as agent
   - Sophisticated attacker could tamper if they gain root
   - **Mitigation**: Periodic off-system backup, acceptable risk for prototype

6. **No Real-Time Alerting**
   - Violations detected during manual log review
   - Incident response delayed
   - **Mitigation**: Weekly log review, operator awareness, future improvement

## Compliance Mapping

### SOC 2 Control Considerations

While this is a prototype lab (not SOC 2 certified), these controls align with common requirements:

- **Access Control**: Dedicated user isolation, token scoping
- **Audit Logging**: Comprehensive execution logs
- **Change Management**: PR review, no auto-merge
- **Data Protection**: Credential isolation, no production secrets
- **Monitoring**: Log review process, incident response procedures

### GDPR/Privacy Considerations

- No personal data processing expected in lab
- If processing personal data: add to allowlist policy, document in workflows
- Agent user has no access to production databases or customer data

### Industry-Specific Policies

If your organization has specific requirements (FedRAMP, HIPAA, PCI-DSS, etc.):
- Review `repo-allowlist.example.yaml` per-org policy sections
- Add compliance-specific checks to `docs/admin/operator-checklist.md`
- Document exceptions in ADR format

## Threat Model Maintenance

### Review Triggers

Update this threat model when:
- Adding new tools (Superpowers, OpenCode)
- Expanding to new GitHub organizations
- Incident occurs (add lessons learned)
- Quarterly review (every 90 days)
- Major policy changes

### Review Process

1. Convene team review session
2. Walk through each threat scenario
3. Validate mitigations still effective
4. Add new threats discovered
5. Update risk ratings based on real-world data
6. Document changes in git history

### Metrics to Track

- Allowlist violations per week
- Policy violations detected in review
- Incidents (if any)
- False positive rate (blocked legitimate operations)
- Manual override frequency

---

**Document Version**: 1.0  
**Last Updated**: 2026-06-12  
**Next Review**: 2026-09-12  
**Owner**: Engineering Team  
