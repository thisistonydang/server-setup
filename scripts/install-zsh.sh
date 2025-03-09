#!/bin/bash
set -euo pipefail

echo "Installing ZSH..."

# Load environment variables. Required so that the USERNAME variable is available.
source .env

# Install ZSH if not already installed.
if ! command -v zsh &> /dev/null; then
    apt-get update
    apt-get install --yes zsh
fi

# Change default shell to ZSH for user.
chsh --shell $(which zsh) ${USERNAME}

echo ""
echo "Default shell set to ZSH for user '${USERNAME}'. ✅"
echo ""