#!/bin/bash
set -euo pipefail

echo "Installing LazyVim..."

# Load environment variables. Required so that the USERNAME variable is available.
source .env

# Add LazyVim requirements if nvim is not already installed.
if [[ ! -d ~/.config/nvim ]]; then
    # Add PPA to get the latest version of Neovim.
    echo "Adding PPA for latest stable Neovim..."
    add-apt-repository --yes ppa:neovim-ppa/stable
    apt-get update
    echo ""

    # Install bare LazyVim requirements.
    echo "Installing LazyVim requirements..."
    apt-get install --yes neovim build-essential
    echo ""
fi

