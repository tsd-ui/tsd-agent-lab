# Phase 1—Dedicated local user setup

Don't let `claude` blindly create the Mac user. Have `claude` generate the setup script and checklist, then you review/run manually.

As of 2026-06-17 I think this is pretty much done?

## Prompt 1A—Generate Mac user setup checklist

```markdown
Create a Mac setup checklist for a dedicated non-admin local user named `agent-lab`.

Goal:
The `agent-lab` user is for local agentic SDLC experiments only.

Requirements:
- Non-admin user.
- No personal browser sessions.
- No personal SSH keys copied automatically.
- No production credentials.
- Separate home directory.
- Separate Codex/Claude/Gemini config directories.
- Separate workspace under `~/workspaces`.
- Explicit manual steps for any credential setup.
- Clear warning against using this as a shared always-on team service.

Create:
- `docs/setup/macos-agent-lab-user.md`
- `scripts/macos/README.md`

Also create a script:
- `scripts/macos/check-agent-lab-user.sh`

The script should only inspect and report:
- current user
- whether `agent-lab` exists
- whether `agent-lab` is admin or non-admin
- whether common tools are installed
- whether expected directories exist

The script must not create users or change system settings.
```

## Prompt 1B—Generate bootstrap script for the agent-lab user

Run this one after you have manually created the user or decided how you’ll create it.

```markdown
Create a bootstrap script intended to be run while logged in as the non-admin `agent-lab` Mac user.

Create:
- `scripts/bootstrap/bootstrap-agent-lab.sh`
- `docs/setup/bootstrap-agent-lab.md`

The bootstrap script should:
- Use safe shell options.
- Create `~/workspaces`, `~/workspaces/repos`, `~/workspaces/runs`, `~/workspaces/reports`.
- Create `~/.codex` if missing.
- Create `~/.config/tsd-agent-lab`.
- Check for required tools: git, gh, node, npm, python3, jq.
- Check for optional tools: codex, claude, gemini, docker, colima, opencode.
- Print missing tools with install guidance but do not force install anything.
- Avoid sudo.
- Avoid writing credentials.
- Avoid modifying global Git config unless explicitly approved.
- Be idempotent.

Also create:
- `docs/setup/tool-installation-notes.md`

Do not assume Homebrew is available, but mention it as one possible route.
```

### Outcome

```
ryordan@ryordan-mac tsd-agent-lab % ./scripts/macos/check-agent-lab-user.sh
=== Agent Lab User Check ===

Current User:
  Logged in as: ryordan
  ℹ Not running as agent-lab (this is fine for inspection)

User Existence:
  ✓ User 'agent-lab' exists
  User ID: 502
  Group ID: 20
  Shell: /bin/zsh
  Home: /Users/agent-lab

Admin Status:
  ✓ User 'agent-lab' is NOT an administrator (correct)

Home Directory:
  ✓ Home directory exists: /Users/agent-lab
  ✓ Owned by agent-lab

Expected Directories:
  ○ /Users/agent-lab/workspaces (not yet created)
  ○ /Users/agent-lab/workspaces/repos (not yet created)
  ○ /Users/agent-lab/workspaces/runs (not yet created)
  ○ /Users/agent-lab/workspaces/reports (not yet created)
  ○ /Users/agent-lab/.codex (not yet created)
  ○ /Users/agent-lab/.config/tsd-agent-lab (not yet created)

Tool Availability:
  Required tools:
  ✓ git (git version 2.50.1)
  ✓ gh (gh version 2.94.0)
  ✓ node (v22.22.3)
  ✓ npm (10.9.8)
  ✓ python3 (Python 3.14.5)
  ✓ jq (jq-1.7.1-apple)

  Optional tools:
  ✓ claude (2.1.175 (Claude Code))
  ✓ podman (podman version 5.8.2)
  ✓ code (1.124.2)

=== Summary ===

✓ User 'agent-lab' is properly configured as a non-admin user

Next steps:
  1. Log in as agent-lab user
  2. Run: ./scripts/bootstrap/bootstrap-agent-lab.sh
```

And you can see the notes in the repo's `docs/setup/macos-agent-lab-user.md` and `bootstrap-agent-lab.md` files.

## Further Questions

```
ryordan tsd-agent-lab % claude
❯ i'm working on this plan : /Users/ryordan/Obsidian/WorkVault/TSD Lab/TSD Lab.md
  And I've implemented phase 0, I'm on phase 1. I created the Mac user and the tsd-agent-lab repo, which is this current directly.  You can check the docs for the next steps for the agent user. However, I'm confused–do I need to set everything up again for the agent user?
  What git username would I use? What about my SSH keys? I dread to think I will need to set all of this up again for the agent user. Also, I do not have access to my notes and the github repo from the Mac user because it's not set up git or anything yet. Could I Screen Share into the agent user environment from here to finish any remaining steps, or SSH? What is the easiest way to get this going without compromising everything?

⏺ Good news! You don't need to duplicate your entire git setup. Here's the situation:

  The Short Answer

  You do NOT need to:
  - Copy your personal SSH keys to the agent-lab user
  - Recreate your entire git configuration
  - Set up your Obsidian vault on the agent user
  - Give the agent user access to all your personal repos

  You DO need:
  - Basic git config (just name/email for commits made by agents)
  - GitHub CLI authentication with a scoped token (not your main credentials)
  - To clone just the tsd-agent-lab repo to the agent user

  The Easiest Path Forward

  Option 1: Fast User Switching (Recommended)

  This is the easiest. You can switch between users without logging out:

  1. Click your username in the macOS menu bar
  2. Select the agent-lab user
  3. Both sessions stay active - you can switch back anytime

  This lets you work in your main account (where you have this repo, your notes, etc.) and just pop over to the agent user when needed.

  Option 2: Screen Sharing

  You can enable Screen Sharing for the agent-lab user:
  - System Settings → General → Sharing → Screen Sharing
  - Then connect via Screen Sharing.app from your main user

  Option 3: SSH (overkill for local)

  Technically possible but unnecessary since both users are on the same machine.

  What to Actually Do on the Agent User

  Based on the docs, you only need this minimal setup:

  # 1. Basic git identity (for agent commits)
  git config --global user.name "Agent Lab"
  git config --global user.email "agent-lab@tsd.example.com"

  # 2. Clone ONLY the lab repo
  mkdir -p ~/workspaces/repos
  cd ~/workspaces/repos
  git clone https://github.com/YOUR-ORG/tsd-agent-lab.git

  # 3. GitHub CLI with scoped token
  gh auth login
  # Choose: minimal scopes, just what agents need for lab repos

  # 4. Claude Code (if you're using it for agent execution)
  claude auth login

  What Git Username to Use?

  Use something like:
  - Name: "Agent Lab" or "TSD Agent Lab"
  - Email: "agent-lab@tsd.example.com" (doesn't need to be real)

  This makes it obvious in git logs when commits came from the agent user vs. you personally.

  About SSH Keys

  Don't copy your personal SSH keys. Instead:

  Option A (Recommended): Use HTTPS + GitHub CLI tokens
  - Run gh auth login on the agent user
  - Creates a scoped token for just that user
  - No SSH keys needed

  Option B: Generate new SSH keys for agent-lab (if you prefer SSH)
  - Generate fresh keys on agent user: ssh-keygen -t ed25519
  - Add as a deploy key or separate GitHub account SSH key
  - Keeps them isolated from your personal keys

  Current Situation

  You're at Phase 1. From your main user (ryordan), you already have:
  - ✅ The tsd-agent-lab repo cloned and set up
  - ✅ The agent-lab Mac user created
  - ✅ Your plan in Obsidian (stays in your main account)

  Just switch to the agent user via Fast User Switching and do the minimal setup above. You can keep working on the plan from your main account and just use the agent account for running agent experiments.
```

More frustrations..

```
sudo -iu agent-lab
```

``


---
