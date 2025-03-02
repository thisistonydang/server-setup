#!/bin/bash
set -euo pipefail

# Load environment variables. Required so that the IP variable is available.
source .env

# Configure ufw firewall.
ssh root@${IP} bash < ./scripts/configure-firewall.sh

# Create non-root user with sudo privileges.
ssh root@${IP} bash < ./scripts/create-user.sh

# Upgrade packages and reboot system.
ssh root@${IP} bash < ./scripts/upgrade-packages.sh