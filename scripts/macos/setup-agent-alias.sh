#!/bin/bash
#
# Setup shell alias for easy switching to agent-lab user
#
set -e

SHELL_CONFIG=""

# Detect shell and config file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    echo "⚠️  Unknown shell. Please add the alias manually."
    echo ""
    echo "Add this to your shell config:"
    echo "  alias agent='sudo su - agent-lab'"
    exit 1
fi

echo "Setting up agent-lab alias..."
echo ""
echo "Shell config: $SHELL_CONFIG"

# Check if alias already exists
if grep -q "alias agent=" "$SHELL_CONFIG" 2>/dev/null; then
    echo "✅ Alias 'agent' already exists in $SHELL_CONFIG"
    echo ""
    echo "Current definition:"
    grep "alias agent=" "$SHELL_CONFIG"
else
    echo "Adding alias to $SHELL_CONFIG..."

    # Add with comment
    cat >> "$SHELL_CONFIG" << 'EOF'

# Agent Lab - Quick switch to agent-lab user
alias agent='sudo su - agent-lab'
EOF

    echo "✅ Alias added!"
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
echo ""
echo "Testing alias (requires sudo password)..."
if alias agent='sudo su - agent-lab' 2>/dev/null; then
    echo "✅ Alias syntax is valid"
else
    echo "❌ Alias syntax error - please check manually"
    exit 1
fi

echo ""
echo "🎉 Setup complete! Run 'source $SHELL_CONFIG' or open a new terminal."
