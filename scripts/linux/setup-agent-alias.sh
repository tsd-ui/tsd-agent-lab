#!/bin/bash
#
# Setup shell alias for easy switching to agent-lab user (Linux)
#
set -e

SHELL_CONFIG=""

# Detect shell and config file
if [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "${BASH_VERSION:-}" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    # Default to .bashrc on Linux
    SHELL_CONFIG="$HOME/.bashrc"
fi

# If zsh is installed and the user has a .zshrc, prefer it
if command -v zsh &>/dev/null && [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
fi

echo "Setting up agent-lab alias..."
echo ""
echo "Shell config: $SHELL_CONFIG"

# Check if alias already exists
if grep -q "alias agent=" "$SHELL_CONFIG" 2>/dev/null; then
    echo "Alias 'agent' already exists in $SHELL_CONFIG"
    echo ""
    echo "Current definition:"
    grep "alias agent=" "$SHELL_CONFIG"
else
    echo "Adding alias to $SHELL_CONFIG..."

    cat >> "$SHELL_CONFIG" << 'EOF'

# Agent Lab - Quick switch to agent-lab user
alias agent='sudo su - agent-lab'
EOF

    echo "Alias added!"
fi

echo ""
echo "To activate the alias:"
echo "  source $SHELL_CONFIG"
echo ""
echo "Or simply open a new terminal."
echo ""
echo "Usage:"
echo "  agent        # Switch to agent-lab user"
echo "  exit         # Return to your account"
