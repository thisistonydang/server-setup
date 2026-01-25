#!/bin/bash
set -euo pipefail

echo "Upgrading packages..."

# Retrieves the latest package lists.
# NOTE: `apt-get` is used instead of `apt` because it has a stable CLI API and
# guaranteed backward compatibility.
apt-get update

# Upgrades all installed packages. The --yes flag avoid manual confirmation.
apt-get upgrade --yes

echo "✅ Packages upgraded."
echo ""
