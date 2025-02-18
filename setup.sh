#!/bin/bash
set -euo pipefail

# Load environment variables
source .env

# Set up firewall
ssh root@${IP} bash < firewall.sh