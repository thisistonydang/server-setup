#!/bin/bash
set -euo pipefail

echo "Installing ZSH..."

# Load environment variables. Required so that the USERNAME variable is available.
source .env

# Install ZSH if not already installed.
if ! command -v zsh &> /dev/null; then
    apt-get update
    apt-get install --yes zsh

    if [[ -n "${DOTFILES_REPO}" ]]; then
        git clone --depth=1 https://github.com/${DOTFILES_REPO}.git /home/${USERNAME}/repos/${DOTFILES_REPO}
        chown --recursive ${USERNAME}:${USERNAME} /home/${USERNAME}/repos/${DOTFILES_REPO}
        ln --symbolic /home/${USERNAME}/repos/${DOTFILES_REPO}/.zshrc /home/${USERNAME}/.zshrc
        ln --symbolic /home/${USERNAME}/repos/${DOTFILES_REPO}/.gitconfig /home/${USERNAME}/.gitconfig
    fi
fi

# Change default shell to ZSH for user.
chsh --shell $(which zsh) ${USERNAME}

echo ""
echo "Default shell set to ZSH for user '${USERNAME}'. ✅"
echo ""