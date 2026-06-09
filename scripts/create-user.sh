#!/bin/bash
set -euo pipefail

echo "Creating user..."

# Load environment variables. Required so that the USERNAME variable is available.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../.env"

# Only create a new user if one doesn't already exist.
if id "${USERNAME}" &>/dev/null; then
	echo "⚠️ Warning: User '${USERNAME}' already exists."
else
	# Create a new user with home directory, and sudo privileges.
	useradd --create-home --groups sudo "${USERNAME}"
	echo "User '${USERNAME}' created with sudo privileges."

	# Set a strong random password (which is never revealed) and then expire it,
	# forcing the user to create a new password on next login. We avoid
	# `passwd --delete` because it leaves a blank password, which some PAM/sudo
	# configurations will accept, allowing a sudo-capable account to be used
	# without a real credential during the pre-first-login window. Note: Only SSH
	# key authentication is allowed for connecting to the server, but the password
	# is still required for sudo.
	RANDOM_PASSWORD="$(head --bytes=32 /dev/urandom | base64)"
	echo "${USERNAME}:${RANDOM_PASSWORD}" | chpasswd
	unset RANDOM_PASSWORD
	passwd --expire "${USERNAME}"
	echo "User '${USERNAME}' will need to create a new password on first login."

	# Copy SSH key folder from root to new user to allow SSH access. The SSH
	# folder contains the authorized_keys file, which contains the public key
	# that should have been added via the hosting provider on server creation.
	rsync --archive --chown="${USERNAME}:${USERNAME}" /root/.ssh "/home/${USERNAME}"
	echo "SSH public key copied from root to new user '${USERNAME}'."

	echo "✅ User '${USERNAME}' created."
fi

echo ""
