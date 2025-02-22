#!/bin/bash
set -euo pipefail

# Load environment variables
source .env

# Configure ufw firewall
ssh root@${IP} bash < ./scripts/configure-firewall.sh