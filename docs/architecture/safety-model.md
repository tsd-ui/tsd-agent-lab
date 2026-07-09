# Safety Model

## Overview

The TSD Agent Lab implements defense-in-depth safety controls to prevent production impact, credential leakage, and policy violations while enabling productive experimentation with agentic workflows.

## Core Safety Principles

### 1. Isolation by Default

**Dedicated User Account**
- All agent operations run under non-admin Mac user
- Separate home directory and credential storage
- No access to production tools or credentials
- Limited file system permissions

**Network Isolation**
- No VPN access from agent user
- No production system access
- No internal service credentials
- Public internet only (for tool downloads, documentation)

### 2. Human-in-the-Loop

**Merge Gate**
- Every pull request requires human review
- No auto-merge capability
- Explicit approval required for all changes
- Review checklist enforced

**Workflow Approval**
- High-risk operations require confirmation
- Destructive commands blocked by default
- Explicit allowlist for commands
- Audit log for all operations

### 3. Credential Protection

**Scoped Credentials**
- **GitHub**: Each team member uses personal tokens (no shared PATs)
- **Claude Code**: Shared GCP service account key (Vertex AI) — scoped to the lab's GCP project, not personal credentials. Do not run `claude auth login` or `gcloud auth login` on the agent-lab user.
- Token/key scope limited to lab resources only

**Credential Isolation**
- Agent user has separate credential store
- No access to production secrets
- No access to password managers
- Environment variables explicitly controlled

### 4. Repository Boundaries

**Allowlist Enforcement**
- Only approved repositories accessible
- Cross-org access requires explicit permission
- Unknown repositories blocked by default
- Repository list versioned in lab repo

**Branch Protection**
- No direct commits to protected branches
- Pull request workflow required
- No force push capability
- Branch naming conventions enforced

### 5. Command Safety

**Allowlist-Based Execution**
- Explicit list of approved commands
- Destructive commands blocked
- Network commands restricted
- File system access limited

**Audit Trail**
- All commands logged
- Execution context captured
- Results recorded
- Timestamps and user tracked

## Safety Layers

### Layer 1: OS-Level Isolation

```
┌─────────────────────────────────────┐
│  Non-Admin User (tsd-agent)         │
│  - Limited file permissions         │
│  - No sudo access                   │
│  - Separate home directory          │
│  - Controlled PATH                  │
└─────────────────────────────────────┘
```

**Controls**:
- User account permissions
- File system ACLs
- Process isolation
- Resource limits

### Layer 2: Policy Enforcement

```
┌─────────────────────────────────────┐
│  Policy Enforcer                     │
│  - Repository allowlist              │
│  - Command allowlist                 │
│  - Credential checks                 │
│  - Branch protection                 │
└─────────────────────────────────────┘
```

**Controls**:
- Pre-execution validation
- Runtime monitoring
- Post-execution verification
- Policy violation blocking

### Layer 3: Workflow Controls

```
┌─────────────────────────────────────┐
│  Workflow Harness                    │
│  - Human approval gates              │
│  - Result capture                    │
│  - Error handling                    │
│  - Rollback capability               │
└─────────────────────────────────────┘
```

**Controls**:
- Approval checkpoints
- State management
- Recovery procedures
- Audit logging

### Layer 4: Human Review

```
┌─────────────────────────────────────┐
│  Code Review                         │
│  - Manual inspection                 │
│  - Checklist verification            │
│  - Risk assessment                   │
│  - Explicit approval                 │
└─────────────────────────────────────┘
```

**Controls**:
- Pull request review
- Change validation
- Risk evaluation
- Merge decision

## Threat Scenarios and Mitigations

### T1: Production Credential Leakage

**Threat**: Agent accesses and uses production credentials

**Mitigations**:
- Dedicated user with isolated credential store
- No access to production password managers
- Credential scanning in logs
- Environment variable controls

**Detection**:
- Audit log review
- Unusual access patterns
- Failed authentication attempts

### T2: Unauthorized Repository Access

**Threat**: Agent accesses unauthorized GitHub repositories

**Mitigations**:
- Repository allowlist enforcement
- Token scope limitation
- Access logging
- Cross-org boundary checks

**Detection**:
- Allowlist violation logs
- Unexpected clone operations
- Cross-org access attempts

### T3: Malicious Code Injection

**Threat**: Agent introduces malicious code via PR

**Mitigations**:
- Human code review required
- Command allowlist prevents execution
- Isolated environment limits blast radius
- Git history provides audit trail

**Detection**:
- Code review process
- Unusual patterns in changes
- Security scanning tools

### T4: Resource Abuse

**Threat**: Agent consumes excessive resources

**Mitigations**:
- User-level resource limits
- Process monitoring
- Timeout enforcement
- Manual intervention capability

**Detection**:
- Resource monitoring
- Timeout violations
- System alerts

### T5: Hidden Long-Running Processes

**Threat**: Agent spawns background processes

**Mitigations**:
- Process monitoring
- User session isolation
- Explicit process management
- Audit logging

**Detection**:
- Process listing in logs
- Unexpected resource usage
- Session cleanup verification

### T6: Cross-Org Policy Violations

**Threat**: Agent violates organization-specific policies

**Mitigations**:
- Per-org policy configuration
- Repository-level policy enforcement
- Cross-org boundary checks
- Explicit allowlist per org

**Detection**:
- Policy violation logs
- Cross-org access attempts
- Compliance monitoring

## Operational Safety

### Pre-Flight Checks

Before any workflow execution:
1. Verify user isolation active
2. Check policy configuration current
3. Confirm allowlists loaded
4. Validate credentials scoped correctly
5. Review repository permissions

### Runtime Monitoring

During workflow execution:
1. Log all commands
2. Monitor resource usage
3. Track file modifications
4. Capture network activity
5. Record timing information

### Post-Execution Review

After workflow completion:
1. Review audit logs
2. Verify expected outcomes
3. Check for anomalies
4. Validate cleanup
5. Document lessons learned

## Audit and Logging

### Log Requirements

All logs must include:
- Timestamp (UTC)
- User/agent identifier
- Operation type
- Target repository
- Command executed
- Result status
- Duration
- Context information

### Log Storage

- Logs stored in `logs/` directory
- Organized by date and session
- Retained for minimum 90 days
- Searchable format (JSON or structured text)
- Backed up regularly

### Log Review

- Weekly review of all operations
- Monthly summary report
- Incident investigation as needed
- Pattern analysis for improvements

## Known Limitations

### Current Weaknesses

1. **Local-only**: Single user setup doesn't scale to full team
2. **Manual overhead**: Human review slows iteration
3. **Limited monitoring**: Basic logging, not comprehensive observability
4. **Tool diversity**: Multiple tools increase complexity
5. **Policy gaps**: Initial policies will have edge cases

### Accepted Risks

1. **Experiment failure**: Some workflows will fail; that's expected
2. **Performance**: Safety controls add latency
3. **Usability**: Restrictions may frustrate users initially
4. **Completeness**: Not all threats covered in v0

### Future Improvements

1. Enhanced monitoring and alerting
2. Automated policy testing
3. Multi-user support
4. Advanced threat detection
5. Integration with security tools

## Safety Checklist

Before deploying any new workflow:

- [ ] Threat model reviewed
- [ ] Policies updated if needed
- [ ] Allowlists validated
- [ ] Audit logging confirmed
- [ ] Rollback plan documented
- [ ] Review process defined
- [ ] Known risks documented
- [ ] Team trained on new workflow

## Emergency Procedures

### Incident Response

1. **Immediate**: Kill agent processes
2. **Contain**: Revoke repository access
3. **Assess**: Review audit logs
4. **Remediate**: Fix vulnerabilities
5. **Document**: Write incident report
6. **Improve**: Update policies

### Rollback Procedures

1. Stop ongoing workflows
2. Revert problematic changes
3. Restore from known-good state
4. Verify system integrity
5. Document incident
6. Update controls

## Compliance Considerations

While this is a prototype lab, maintain awareness of:

- Organization security policies
- GitHub terms of service
- Data handling requirements
- Tool licensing terms
- Team member responsibilities

This safety model is a living document. Update based on lessons learned, new threats, and changing requirements.
