#!/bin/bash
set -euo pipefail

# Retrieves the latest package lists.
apt-get update

# Upgrades all installed packages. The --yes flag avoid manual confirmation.
apt-get upgrade --yes

# Reboot server. Some updates require a reboot to take effect.
reboot