#!/bin/bash
set -euo pipefail

echo "Running server setup scripts..."
echo ""

# Load environment variables. Required so that the IP variable is available.
source .env

# Copy the .env file to the server so that it can be used by below scripts.
echo "Copying .env file to server..."
rsync -avLP .env root@${IP}:/root
echo ""

# Copy the setup scripts to the server.
echo "Copying setup scripts to server..."
rsync -avLP scripts root@${IP}:/root
echo ""

# Execute all setup scripts in a single SSH session
ssh root@${IP} 'bash -s' << 'EOF'
    bash /root/scripts/configure-firewall.sh
    bash /root/scripts/configure-ssh.sh
    bash /root/scripts/create-user.sh
    bash /root/scripts/upgrade-packages.sh
EOF
