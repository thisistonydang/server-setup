#!/bin/bash
set -euo pipefail

echo "Creating user..."

# Load environment variables. Required so that the USERNAME variable is available.
source .env

# Only create a new user if one doesn't already exist.
if id "${USERNAME}" &>/dev/null; then
    echo "User '${USERNAME}' already exists. 🚧"
else
    # Create a new user with home directory, and sudo privileges.
    useradd --create-home --groups sudo ${USERNAME}
    echo "User '${USERNAME}' created with sudo privileges."

    # Set the password to expire immediately, forcing the user to create a new
    # password on next login. Note: Only SSH key authentication will be allowed
    # for connecting to the server, but the password is still required for sudo.
    passwd --delete --expire ${USERNAME}
    echo "User '${USERNAME}' will need to create a new password on first login."

    # Copy SSH key folder from root to new user to allow SSH access. The SSH
    # folder contains the authorized_keys file, which contains the public key
    # that should have been added via the hosting provider on server creation.
    rsync --archive --chown=${USERNAME}:${USERNAME} /root/.ssh /home/${USERNAME}
    echo "SSH public key copied from root to new user '${USERNAME}'."

    echo "User '${USERNAME}' created. ✅"
fi

echo ""