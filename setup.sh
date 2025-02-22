#!/bin/bash
set -euo pipefail

# Load environment variables.
source .env

# Configure ufw firewall.
ssh root@${IP} bash < ./scripts/configure-firewall.sh

# Create non-root user with sudo privileges.
ssh root@${IP} bash < ./scripts/create-user.sh

# Update and upgrade packages.
ssh root@${IP} bash < ./scripts/update-packages.sh