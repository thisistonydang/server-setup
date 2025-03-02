#!/bin/bash
set -euo pipefail

# Load environment variables.
source .env

# Copy .env file to remote server.
rsync -avLP .env root@${IP}:/root
echo ".env file copied to remote server."

# Configure ufw firewall.
ssh root@${IP} bash < ./scripts/configure-firewall.sh

# Create non-root user with sudo privileges.
ssh root@${IP} bash < ./scripts/create-user.sh

# Upgrade packages and reboot system.
ssh root@${IP} bash < ./scripts/upgrade-packages.sh