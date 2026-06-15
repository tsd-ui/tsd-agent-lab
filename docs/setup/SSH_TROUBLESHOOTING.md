# SSH Troubleshooting: publickey-hostbound Issue

## Problem Summary

SSH public key authentication from `ryordan` → `agent-lab@localhost` is failing with this signature error pattern:

```
debug1: Server accepts key: ...
debug3: sign_and_send_pubkey: using publickey-hostbound-v00@openssh.com
debug2: we did not send a packet, disable method
```

This is a known issue with macOS OpenSSH and the `publickey-hostbound-v00@openssh.com` extension when connecting to localhost.

## Root Cause

The `publickey-hostbound` protocol extension introduced in OpenSSH 9.0+ binds the signature to the target hostname. On macOS, this can fail for localhost connections due to how the SSH agent handles the signing operation.

## Solution Options

### Option 1: Use `su` Instead of SSH (Recommended)

Since you confirmed `sudo su - agent-lab` works, this is the simplest solution:

```bash
# Add an alias to your shell config (~/.zshrc)
alias agent='sudo su - agent-lab'

# Then just use:
agent
```

**Pros:**
- Works immediately
- No password needed if you're already admin
- More reliable than SSH for local user switching
- Simpler permission model

**Cons:**
- Requires admin (sudo) access
- Slightly different from remote SSH workflow

### Option 2: Disable Hostbound in SSH Client

Add this to `/Users/ryordan/.ssh/config` under the `agent-lab` host entry:

```
Host agent-lab
    HostName localhost
    User agent-lab
    IdentityFile ~/.ssh/id_ed25519_github_work
    IdentitiesOnly yes
    PubkeyAcceptedAlgorithms -publickey-hostbound-v00@openssh.com
    HostbasedAcceptedAlgorithms -publickey-hostbound-v00@openssh.com
```

The `-` prefix explicitly removes the hostbound algorithm from the accepted list.

Then test:
```bash
ssh agent-lab whoami
```

### Option 3: Remove Key from SSH Agent

The issue may be related to the SSH agent. Try removing all keys and testing with direct file auth:

```bash
# Remove all keys from agent
ssh-add -D

# Test without agent
ssh -o "IdentitiesOnly=yes" agent-lab whoami
```

### Option 4: Create a New Dedicated Key

Create a simple key specifically for this localhost connection:

```bash
# As ryordan
ssh-keygen -t ed25519 -f ~/.ssh/id_agent_lab -N "" -C "ryordan-to-agent-lab"

# Copy to agent-lab (you'll need to do this manually or use sudo)
# Option A: If you can sudo
sudo mkdir -p /Users/agent-lab/.ssh
sudo chmod 700 /Users/agent-lab/.ssh
sudo sh -c 'cat /Users/ryordan/.ssh/id_agent_lab.pub >> /Users/agent-lab/.ssh/authorized_keys'
sudo chmod 600 /Users/agent-lab/.ssh/authorized_keys
sudo chown -R agent-lab:staff /Users/agent-lab/.ssh

# Update SSH config
# Change IdentityFile line to:
#   IdentityFile ~/.ssh/id_agent_lab

# Test
ssh agent-lab whoami
```

### Option 5: Use SSH with Password (Temporary)

Set a password for agent-lab and use that:

```bash
# Set password (requires admin)
sudo dscl . -passwd /Users/agent-lab <new-password>

# Then SSH will prompt for password
ssh agent-lab@localhost
```

## Recommended Approach

Given your requirements and the current state:

1. **Short term**: Use `sudo su - agent-lab` with an alias
2. **Long term**: If you really need SSH, try Option 4 (dedicated key) or Option 2 (disable hostbound)

## Diagnostic Commands

If you want to continue troubleshooting:

```bash
# Check SSH daemon logs in real-time
# In one terminal:
log stream --predicate 'process == "sshd"' --level debug

# In another terminal, try to connect:
ssh -vvv agent-lab whoami

# Check if the key is in authorized_keys correctly
sudo su - agent-lab -c 'cat ~/.ssh/authorized_keys'

# Verify key fingerprints match
ssh-keygen -l -f ~/.ssh/id_ed25519_github_work.pub
sudo su - agent-lab -c 'ssh-keygen -l -f ~/.ssh/authorized_keys'

# Check sshd_config for restrictions
grep -E "^(PubkeyAuthentication|AuthorizedKeysFile|AllowUsers|DenyUsers)" /etc/ssh/sshd_config
```

## Next Steps for Implementation

Based on the plan at `~/.claude/plans/encapsulated-wishing-wolf.md`, I recommend:

1. **Accept that SSH might not work reliably** for localhost on macOS with the current OpenSSH version
2. **Update the setup documentation** to recommend `sudo su - agent-lab` instead
3. **Create a convenience alias** or script for easy switching
4. **Move forward with Phase 1** using `su` as the access method

Would you like me to:
- Update the main setup docs to reflect this?
- Create shell aliases/functions for easy switching?
- Try one more SSH fix attempt with a brand new key?

