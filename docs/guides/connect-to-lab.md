# Connect to the Lab

How to switch to the agent-lab user, verify your environment, and access repos.

## Prerequisites

- macOS with the `agent-lab` user already created (see [setup/macos-agent-lab-user.md](../setup/macos-agent-lab-user.md))
- The `agent` shell alias set up (one-time, see below)
- Claude Code installed and licensed

## One-Time Alias Setup

> **Remote colleagues (SSH via Tailscale):** skip this section. SSH authenticates you directly as `agent-lab` — no alias needed. Jump to [Remote Access via Tailscale](#remote-access-via-tailscale-colleagues-on-fedora).

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

---

## Remote Access via Tailscale (Colleagues on Fedora)

Colleagues on other machines can SSH into the lab over Tailscale. The Mac's Tailscale address is:

```
ryordan-mac.tail9cbf83.ts.net   (100.121.85.22)
```

### Colleague Setup (Fedora)

**1. Generate an SSH key (if you don't have one)**

```bash
ls ~/.ssh/id_ed25519.pub 2>/dev/null || \
  ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_ed25519 -N ""
```

Remove `-N ""` if you'd prefer a passphrase (recommended for personal keys).

**2. Share your public key with ryordan**

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the output and send it via Slack or email. ryordan will add it to `agent-lab`'s `authorized_keys`.

**3. Install Tailscale on Fedora**

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled
sudo tailscale up
```

Follow the browser link to authenticate. Mention your machine name to ryordan — they need to approve it in the Tailscale admin console before you can reach the Mac.

**4. Verify Tailscale is working**

```bash
tailscale status       # should show the Mac: ryordan-mac
tailscale ip -4        # your own Tailscale IP
```

**5. SSH in (once your key and device are approved)**

Tailscale must be running each time you connect. `tailscaled` is enabled to autostart on boot, but verify if anything seems off:

```bash
systemctl status tailscaled   # should be active (running)
tailscale status               # should show ryordan-mac in the list
```

Then connect:

```bash
ssh agent-lab@ryordan-mac.tail9cbf83.ts.net
```

Verify you're in the right environment:

```bash
whoami   # → agent-lab
cd ~/workspaces/repos/tsd-agent-lab
git log --oneline -3
```

### Adding a Colleague's Key (ryordan's steps)

For each colleague who sends you their public key:

```bash
sudo su - agent-lab
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "ssh-ed25519 AAAA... colleague-name@hostname" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
exit
```

Confirm it landed correctly:

```bash
sudo su - agent-lab -c 'cat ~/.ssh/authorized_keys'
```

### Troubleshooting Remote Access

| Symptom | Check |
|---------|-------|
| `Connection refused` | Is Tailscale running on both sides? `tailscale status` |
| `Permission denied (publickey)` | Did ryordan add your key? Run the `cat authorized_keys` check above |
| `Host not found` | Try IP directly: `ssh agent-lab@100.121.85.22` |
| Device not visible on tailnet | ryordan needs to approve it at [tailscale.com/admin](https://login.tailscale.com/admin/machines) |
