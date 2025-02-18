#!/bin/bash
set -euo pipefail

# Rate limit SSH connections to prevent brute force attacks.
ufw limit ssh

# Allow incoming connections on port 80 (HTTP).
ufw allow http

# Allow incoming connections on port 443 (HTTPS).
ufw allow https

# Enable the firewall. The --force flag prevents confirmation prompts.
ufw --force enable

# Display the firewall status in verbose mode to confirm the rules.
ufw status verbose