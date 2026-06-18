---
aliases: 
tags: 
---
# Phase 0B Summary: Threat Model and Policy Hardening

**Completion Date**: 2026-06-12
**Phase**: Phase 0B - Tighten the Threat Model
**Status**: ✅ Complete

## Overview

Phase 0B focused on hardening the TSD Agent Lab for operation in a corporate engineering environment. Building on Phase 0A's foundational planning, this phase established comprehensive threat modeling, security policies, and operational guidelines.

## Deliverables Created

### 1. Comprehensive Threat Model

**File**: `docs/threat-model.md`

A detailed security analysis covering:
- **Trust boundaries** between primary user, agent user, and external systems
- **5 threat actors** (compromised tools, malicious AI, insider misuse, external attackers, operator error)
- **8 critical threats** with detailed mitigations:
  - CT1: Production credential leakage
  - CT2: Unauthorized repository access
  - CT3: Malicious code execution via PR
  - CT4: Comment-triggered workflow abuse (eliminated by design)
  - CT5: Autonomous protected branch modification
  - CT6: Hidden long-running processes
  - CT7: Cross-organization policy violations
  - CT8: Log tampering or deletion
- **4 moderate threats** (resource exhaustion, network exfiltration, dependency confusion, prompt injection)
- **Known weaknesses** documented with mitigation plans
- **Compliance mapping** (SOC 2, GDPR, industry-specific considerations)

**Key Innovation**: STRIDE-based analysis tailored for agentic workflows, with explicit trust boundaries and residual risk assessments.

### 2. Default Policy Configuration

**File**: `policies/default-policy.yaml`

Runtime controls enforcing safety at multiple layers:
- **Credential Protection**:
  - 30+ blocked environment variables (AWS, GCP, database URLs, API keys)
  - Allowed variables for lab operation only
  - Credential pattern detection in logs (AWS keys, GitHub PATs, etc.)
  - Sensitive file pattern blocking
- **Repository Controls**:
  - Strict allowlist enforcement mode
  - Protected branch operations blocked (force push, hard reset)
  - High-risk git operations require confirmation
  - Blocked patterns for production repositories
- **Command Controls**:
  - Strict command allowlist enforcement
  - Always-blocked commands (rm -rf /, sudo, nohup, cryptocurrency miners)
  - Confirmation-required commands (git push, gh pr create)
  - Maximum 1-hour execution timeout
- **File System Controls**:
  - Writable path allowlist (lab repo, tmp only)
  - Blocked system directories (/System, /usr, ~/.ssh, ~/.aws)
  - 100MB max file size, 10GB max disk usage
- **Network Controls**:
  - Allowed domains (GitHub, Anthropic, package managers, docs)
  - Blocked exfiltration targets (pastebin sites)
  - Allowed ports (80, 443, 22, 9418)
- **Audit and Logging**:
  - JSON-formatted comprehensive logs
  - 90-day retention
  - Credential pattern sanitization
  - Alert triggers for violations
- **Workflow Controls**:
  - Pre-flight and post-flight checklists
  - 2-hour max workflow duration
  - Pause on policy violation
  - Override logging with justification
- **Pull Request Controls**:
  - Human review required (no auto-merge)
  - PR description minimum 50 characters
  - Required labels (`agent-generated`)
  - Max 50 files / 2000 lines per PR
- **Incident Response**:
  - Emergency stop procedures
  - Severity levels and thresholds
  - Auto-reporting configuration

**Key Innovation**: Defense-in-depth policy covering every layer from OS to PR review.

### 3. Repository Allowlist Template

**File**: `policies/repo-allowlist.example.yaml`

Multi-organization repository access control:
- **Global Settings**:
  - Default block action for unknown repos
  - Cross-org approval required
  - Max 5 repos per workflow
- **Per-Organization Policies**:
  - Example configurations for `example-org-1`, `example-org-2`, and personal accounts
  - Org-specific branch naming conventions
  - Signed commit requirements per org
  - Custom command overrides per org
- **Repository Specifications**:
  - Read-only vs read-write access
  - Protected branch configuration
  - Allowed/blocked operations per repo
  - Pattern-based matching for repo families
  - Explicit blocked repositories with reasons
- **Pattern-Based Allowlists**:
  - Global patterns with auto-expiration
  - Block patterns for production/secrets/customer repos
- **Audit Configuration**:
  - Access logging
  - Weekly summary reports
  - Alert triggers
- **Cross-Org Rules**:
  - Org isolation enforcement
  - Allowed org pairs for joint work
  - Confirmation requirements
- **Temporary Allowlist**:
  - Time-based exceptions with expiration
  - Approval tracking
  - Auto-removal of expired entries
- **Emergency Overrides**:
  - Justification requirements
  - Approval tracking
  - Alert on override usage

**Key Innovation**: Multi-org support with per-org policy customization, critical for teams working across multiple GitHub organizations.

### 4. Command Allowlist

**File**: `policies/command-allowlist.yaml`

Comprehensive command execution control:
- **Git Commands** (60+ operations):
  - Safe read operations (status, log, diff, show, branch)
  - Monitored write operations (clone, checkout, add, commit, push, pull)
  - Dangerous operations with safeguards (reset --soft, revert, stash)
  - Explicitly blocked (push --force, reset --hard, clean -fd, filter-branch)
- **GitHub CLI** (gh):
  - Repository viewing and cloning
  - PR list, view, create, diff, checks
  - Issue list, view, create
  - Blocked: pr merge, pr close, repo delete, secret set
- **File System**:
  - Read: ls, cat, head, tail, find (without -exec), grep, wc, file
  - Write: mkdir, touch, cp, mv
  - Dangerous: rm (confirmation required, -rf blocked), chmod, chown
  - Blocked: dd, mkfs, fdisk
- **Text Processing**:
  - sed, awk, sort, uniq, cut, paste, tr, jq
- **Development Tools**:
  - Node.js: node, npm (install/test/run, publish blocked), yarn
  - Ruby: ruby, bundle, gem (push blocked)
  - Python: python, pip (upload blocked)
  - Go: go (build/test/run/fmt/vet)
  - Rust: cargo (publish blocked)
  - Build: make (deploy target blocked)
- **Testing and Linting**:
  - jest, pytest, rspec, eslint, rubocop, flake8, prettier, black
- **System Info** (read-only):
  - whoami, pwd, date, hostname, uname, which, env (sanitized), ps, df, du
- **Network** (restricted):
  - curl, wget (confirmation required, POST/PUT/DELETE blocked)
  - Blocked: nc, telnet, ssh, scp, sftp, ftp, rsync, nmap, ping
- **Explicitly Blocked**:
  - Privilege escalation (sudo, su, doas)
  - Backgrounding (nohup, disown, screen, tmux)
  - System control (reboot, shutdown, systemctl, launchctl)
  - System packages (apt, yum, brew)
  - Dangerous utilities (dd, crontab, at)
  - Binary compilation (gcc, clang)–language-specific allowed

**Key Innovation**: Granular per-command control with flag-level restrictions and separate read/write/dangerous categorization.

### 5. Operator Rules and Guidelines

**File**: `docs/operator-rules.md`

Comprehensive operational handbook for team members:
- **Core Responsibilities**:
  - Safety first, audit trail, team learning, compliance
- **Pre-Flight Checklist** (6 sections, 20+ items):
  1. Environment verification (user, credentials, directory)
  2. Repository verification (allowlist, non-production, org context)
  3. Policy verification (up to date, files exist)
  4. Workflow planning (purpose, outcome, time budget, review plan)
  5. Tool verification (version, configuration)
  6. Ready to start confirmation

- **During Workflow Execution**:
  - Active monitoring guidelines
  - Confirmation handling decision matrix
  - Emergency stop procedures
- **Post-Execution Review** (5 sections):
  1. Process review (cleanup, logs)
  2. Output review (files, sizes)
  3. Code review (security, quality, diff)
  4. Allowlist compliance check
  5. Incident check

- **Pull Request Creation**:
  - Required PR template with security review section
  - Required labels (agent-generated, needs-review, tool-specific, size, type)
  - Draft-first workflow
  - Never self-merge rule
- **Code Review as Reviewer**:
  - 10-item review checklist
  - Review mindset and red flags
  - Approval decision criteria
- **Policy Overrides**:
  - When acceptable
  - 5-step override process
  - JSON log format
- **Incident Response**:
  - 4 severity levels (P0-P3)
  - 4-phase response (immediate, assessment, remediation, documentation)
  - Incident report template
- **Best Practices**:
  - Do's: Start small, review everything, document decisions, share knowledge, ask for help, test thoroughly
  - Don'ts: Skip checklists, merge without review, expose credentials, ignore warnings, work in isolation, override casually
- **Training and Onboarding**:
  - New operator 5-step onboarding
  - Training workflow
  - Ongoing training schedule
- **Metrics and Reporting**:
  - Weekly self-check
  - Monthly team review

**Key Innovation**: Actionable checklists and templates that operators can actually follow, with clear decision criteria and escalation paths.

## Design Principles Applied

### 1. Defense in Depth

Multiple overlapping controls at different layers:
- OS-level isolation (user accounts, file permissions)
- Policy enforcement (allowlists, command filtering)
- Runtime monitoring (logging, auditing)
- Human review (code review, PR approval)

### 2. Fail Secure

Default-deny stance throughout:
- Unknown repositories → blocked
- Unknown commands → blocked
- Unknown environment variables → blocked
- Unknown network destinations → blocked

### 3. Pragmatic Security

Balanced approach for prototype lab:
- Not aiming for formal certification
- Simple controls small teams can follow
- Known weaknesses documented openly
- Emphasis on learning over perfection

### 4. Auditability

Everything logged for review:
- Command execution with arguments and outputs
- Repository access attempts
- Policy violations and overrides
- Incident reports with timelines

### 5. Escape Hatches

Flexibility when needed:
- Policy overrides with justification
- Emergency stop procedures
- Temporary allowlist entries
- Human judgment respected

## Known Weaknesses (Documented)

As explicitly stated in the threat model:

1. **Single-User Model**: Doesn't scale to full team concurrent usage
2. **Manual Enforcement**: Relies on operator discipline
3. **Incomplete Network Isolation**: Public internet access required for tools
4. **Tool Diversity**: Each tool may have unique risks
5. **Log Storage**: On same system as agent (sophisticated attacker could tamper)
6. **No Real-Time Alerting**: Violations detected during manual review

**Mitigation**: All weaknesses documented with plans for future phases. Acceptable risk for prototype lab.

## Security Innovations

### Multi-Org Policy Support

Unlike single-org solutions, this lab explicitly handles:
- Different GitHub organizations with different rules
- Cross-org boundary enforcement
- Per-org credential isolation
- Org-specific commit signing / branch naming

### Agent-Specific Threat Modeling

Threats unique to agentic workflows:
- AI-generated malicious code (not intentional malware, but emergent bugs)
- Prompt injection via repository contents
- Autonomous behavior beyond human intent
- Comment-triggered abuse (eliminated by design)

### Human-in-the-Loop by Design

Not just policy, but architectural:
- No webhooks or comment triggers possible
- All workflows initiated by logged-in operator
- All PRs require human review and merge
- Confirmation prompts for risky operations

### Comprehensive Operator Handbook

Going beyond policy to actual operational practice:
- Checklists operators can actually use
- Templates for consistent PR descriptions
- Incident response with specific timelines
- Training and onboarding curriculum

## Next Steps

### Immediate (Phase 1)

- Create dedicated Mac user account (`tsd-agent`)
- Test OS-level isolation
- Verify file permission restrictions

### Short-Term (Phase 2-3)

- Implement CLAUDE.md global instructions
- Build policy enforcement harness
- Automate pre-flight checklist validation

### Medium-Term (Phase 4-6)

- Test policies with real Claude Code workflows
- Iterate based on operator feedback
- Add Superpowers/OpenCode support

### Long-Term (Phase 7+)

- Real-time alerting integration
- Multi-user support
- Advanced threat detection
- GitHub Actions experimentation (if appropriate)

## Success Criteria Met

Phase 0B goals achieved:

✅ **Prevented accidental use of production credentials**
- Blocked environment variables list
- Credential pattern detection
- OS-level isolation design

✅ **Prevented comment-triggered abuse**
- Explicitly excluded from design (no webhooks)
- Documented as design decision in threat model

✅ **Prevented autonomous writes to protected branches**
- Branch protection rules
- Force push blocked in command allowlist
- No auto-merge in PR controls

✅ **Prevented cross-org policy violations**
- Per-org policy sections in allowlists
- Cross-org approval requirements
- Org isolation enforcement

✅ **Prevented hidden long-running processes**
- Background operator blocking (nohup, screen, tmux)
- Process monitoring before/after workflow
- Cleanup-on-exit policy

✅ **Kept human review as merge gate**
- No auto-merge in PR controls
- Human review required in policy
- Never self-merge in operator rules

✅ **Made logs useful for audit/review**
- JSON format with structured fields
- Credential sanitization
- 90-day retention
- Weekly summaries

✅ **Kept it pragmatic**
- Simple controls over complex automation
- Known weaknesses section
- Escape hatches with justification
- Not pursuing formal certification

## Metrics

### Documentation

- **Total pages**: 5 new documents
- **Total lines**: ~2,500 lines of policy and guidance
- **Policy coverage**: Credentials, repositories, commands, filesystem, network, workflow, PR, incidents
- **Threat scenarios analyzed**: 12 (8 critical, 4 moderate)

### Policy Specificity

- **Blocked environment variables**: 30+
- **Allowed environment variables**: 10+
- **Git commands specified**: 60+
- **Always-blocked commands**: 25+
- **Command categories**: 10+ (git, gh, filesystem, text, dev tools, testing, network, etc.)
- **Credential patterns**: 8+ regex patterns

### Operational Guidance

- **Checklists**: 3 (pre-flight, post-execution, code review)
- **Checklist items**: 40+ total
- **Templates**: 2 (PR description, incident report)
- **Severity levels**: 4 (P0-P3)
- **Response phases**: 4 (immediate, assessment, remediation, documentation)

## Team Readiness

After Phase 0B, the team has:
- ✅ Clear understanding of threats and mitigations
- ✅ Documented policies for safe operation
- ✅ Operational checklists for consistency
- ✅ Incident response procedures
- ✅ Template allowlists ready to customize
- ✅ Training materials for new operators

**Ready for**: Phase 1 (Dedicated Local User Setup)

## Lessons Learned

### What Went Well

- Comprehensive threat modeling provided clear risk picture
- Multi-org support designed in from the start
- Defense-in-depth approach provides multiple layers
- Pragmatic balance of security and usability
- Templates and checklists make policies actionable

### What Could Be Improved

- Some policies can only be validated once harness is built (Phase 3)
- Network isolation requires external tools (Little Snitch, corporate proxy)
- Real-time alerting deferred to future phases
- Multi-user support not yet addressed

### Risks Identified for Future Phases

- Policy complexity may be overwhelming for new operators → training critical
- Manual checklist discipline required until automation in Phase 3
- Tool diversity (Claude Code, Superpowers, OpenCode) may require policy updates
- Cross-org boundaries harder to enforce without technical controls

## Conclusion

Phase 0B successfully hardened the TSD Agent Lab design for corporate engineering use. The threat model, policies, and operational guidelines provide a solid foundation for safe experimentation with agentic coding tools.

**Key Achievement**: Built comprehensive security framework without sacrificing usability or team productivity.

**Status**: Ready to proceed to Phase 1 (Dedicated Local User Setup).

---

**Completion Date**: 2026-06-12
**Documents Created**: 5
**Total Policy Lines**: 2,500+
**Threats Analyzed**: 12
**Next Phase**: Phase 1 - Dedicated Local User Setup
