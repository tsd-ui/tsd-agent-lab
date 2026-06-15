# Switching to the agent-lab User

Quick reference for switching between your main account and the agent-lab user.

## Recommended Method: Shell Alias

The easiest and most reliable way to switch to the agent-lab user is using the `su` command with a convenient alias.

### One-Time Setup

Run this from your main account:
```bash
./scripts/macos/setup-agent-alias.sh
source ~/.zshrc    # or ~/.bashrc
```

### Daily Usage

```bash
# From your main account terminal
agent    # Switch to agent-lab user
# You'll be prompted for your admin password

# Now you're in a shell as agent-lab
whoami   # Shows: agent-lab
pwd      # Shows: /Users/agent-lab

# Do your work...
cd workspaces/repos/tsd-agent-lab
git status
# etc.

# When done, return to your main account
exit
```

## Why This Method?

✅ **Advantages:**
- Works from any terminal session
- Supports copy/paste between sessions
- No UI switching required
- Integrates with tmux/screen
- More reliable than SSH for localhost
- Single command to switch

❌ **Fast User Switching drawbacks:**
- No clipboard sharing between users
- UI elements disappear when switching back
- Slower for quick context switches
- Requires leaving current desktop

## Alternative Methods

### Manual `su` Command

If you haven't set up the alias:
```bash
sudo su - agent-lab
```

### Fast User Switching (GUI)

If you prefer GUI:
1. Click your username in the menu bar
2. Select "agent-lab"
3. Both sessions remain active in the background

### SSH (Not Recommended)

SSH to localhost has known issues on macOS. See [SSH_TROUBLESHOOTING.md](./SSH_TROUBLESHOOTING.md) if you specifically need SSH.

## Tips

### Multiple Terminal Windows

You can have multiple terminals open as different users:

```bash
# Terminal 1: Your main account
cd ~/projects/my-work

# Terminal 2: agent-lab (in a new terminal window)
agent
cd ~/workspaces/repos/tsd-agent-lab

# Both terminals work independently
```

### Using with tmux

```bash
# Start tmux in your main account
tmux new -s main

# Create a window for agent-lab
tmux new-window -n agent
agent

# Switch between windows with tmux keybindings
# Ctrl-b 0  (main account)
# Ctrl-b 1  (agent-lab)
```

### Quick Status Check

To verify which user you are:
```bash
whoami           # Shows current user
id               # Shows user ID and groups
echo $USER       # Shows username
```

## Troubleshooting

### "command not found: agent"

The alias wasn't loaded. Try:
```bash
source ~/.zshrc    # or ~/.bashrc
# OR
sudo su - agent-lab   # Use the full command
```

### "sudo: a password is required"

This is expected - you need to enter your admin password when switching to agent-lab.

### "su: user agent-lab does not exist"

The agent-lab user hasn't been created yet. See [macos-agent-lab-user.md](./macos-agent-lab-user.md) for setup.

### Can't run sudo from agent-lab

This is correct - agent-lab is a non-admin user and should NOT have sudo access. If you need admin privileges, return to your main account:
```bash
exit    # Exit agent-lab shell
# Now you're back in your admin account
```

## Security Notes

- The alias uses `sudo su -`, which requires admin password
- agent-lab user has no sudo privileges (by design)
- The `-` flag gives a clean login shell with agent-lab's environment
- Each switch prompts for password (can configure sudo timeout if desired)

## Reference

- Full setup guide: [macos-agent-lab-user.md](./macos-agent-lab-user.md)
- SSH troubleshooting: [SSH_TROUBLESHOOTING.md](./SSH_TROUBLESHOOTING.md)
- Phase 1 quickstart: [PHASE1-QUICKSTART.md](../../PHASE1-QUICKSTART.md)
