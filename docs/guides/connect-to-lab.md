# Connect to the Lab

How to switch to the agent-lab user, verify your environment, and access repos.

## Prerequisites

- macOS with the `agent-lab` user already created (see [setup/macos-agent-lab-user.md](../setup/macos-agent-lab-user.md))
- The `agent` shell alias set up (one-time, see below)
- Claude Code installed and licensed

## One-Time Alias Setup

From your main account, run:

```bash
./scripts/macos/setup-agent-alias.sh
source ~/.zshrc    # or ~/.bashrc
```

This adds an `agent` alias so you can switch users with a single command.

## Daily Connection

```bash
# From your main account terminal
agent
# Enter your admin password when prompted

# Verify you're in the right shell
whoami   # → agent-lab
id       # shows user ID and groups (no admin groups)

# Navigate to the lab
cd ~/workspaces/repos/tsd-agent-lab
```

## Verify the Environment

Run these checks before starting any workflow:

```bash
# No production credentials in the environment
env | grep -E '(AWS|GCP|AZURE|DATABASE|PROD)'   # should be empty

# Working directory is the lab or an allowlisted repo
pwd

# Policies are up to date
git pull origin main
```

## Access Repos

Reference clones live in `~/workspaces/repos/`. The harness re-uses them across runs, so you don't clone manually.

```bash
# See what's already cloned
ls ~/workspaces/repos/

# Run directories (timestamped, one per task execution)
ls ~/workspaces/runs/
```

The harness `prepare-repo.sh` handles cloning and worktree creation for each run.

## Multiple Terminal Windows

You can run your main account and agent-lab side by side:

```bash
# Terminal 1: main account (for git push, Slack, etc.)
# Terminal 2: agent-lab session
agent
cd ~/workspaces/repos/tsd-agent-lab
```

### Using tmux

```bash
tmux new -s main
tmux new-window -n agent
agent
```

Switch windows: `Ctrl-b 0` (main), `Ctrl-b 1` (agent-lab).

## Troubleshooting

| Error | Fix |
|-------|-----|
| `command not found: agent` | Run `source ~/.zshrc` or use `sudo su - agent-lab` |
| `su: user agent-lab does not exist` | See [setup/macos-agent-lab-user.md](../setup/macos-agent-lab-user.md) |
| `sudo: a password is required` | Expected — enter your admin password |
| Can't run sudo from agent-lab | Correct by design — `exit` to return to your admin account |

See also [setup/SSH_TROUBLESHOOTING.md](../setup/SSH_TROUBLESHOOTING.md) if you need SSH specifically.

## Disconnect

When done, simply:

```bash
exit   # returns you to your main account shell
```
