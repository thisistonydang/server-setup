#!/bin/bash
set -euo pipefail

echo "Installing LazyVim..."

# Load environment variables. Required so that the USERNAME variable is available.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../.env"

# Add LazyVim requirements if nvim is not already installed.
if [[ ! -d /root/.config/nvim ]]; then
	# Add PPA to get the latest version of Neovim.
	echo "Adding PPA for latest stable Neovim..."
	add-apt-repository --yes ppa:neovim-ppa/stable
	apt-get update
	echo ""

	# Install bare LazyVim requirements.
	echo "Installing LazyVim requirements..."
	apt-get install --yes neovim build-essential fd-find
	echo ""
fi

# Clone LazyVim starter for root.
if [[ ! -d /root/.config/nvim ]]; then
	git clone https://github.com/LazyVim/starter /root/.config/nvim
	rm -rf /root/.config/nvim/.git
	echo "✅ LazyVim starter cloned for root."
else
	echo "⚠️ Warning: LazyVim starter already cloned for root."
fi

# Clone LazyVim starter for user.
if [[ ! -d /home/${USERNAME}/.config/nvim ]]; then
	git clone https://github.com/LazyVim/starter "/home/${USERNAME}/.config/nvim"
	rm -rf "/home/${USERNAME}/.config/nvim/.git"
	chown --recursive "${USERNAME}:${USERNAME}" "/home/${USERNAME}/.config/nvim"
	echo "✅ LazyVim starter cloned for user '${USERNAME}'."
else
	echo "⚠️ Warning: LazyVim starter already cloned for user '${USERNAME}'."
fi

echo ""
