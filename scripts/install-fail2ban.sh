#!/bin/bash
set -euo pipefail

echo "Installing fail2ban..."

# Install fail2ban if not already installed.
if ! command -v fail2ban-client &> /dev/null; then
    # Install fail2ban. Note the service automatically starts on installation.
    # Ref: https://github.com/fail2ban/fail2ban/wiki/How-to-install-fail2ban-packages#debian--ubuntu
    apt-get update
    apt-get install --yes fail2ban

    # Create the local jail configuration file.
    touch /etc/fail2ban/jail.local

    # Enable the SSH jail.
    cat <<EOL >> /etc/fail2ban/jail.local
[sshd]
enabled = true
EOL

    # Restart fail2ban to apply the changes
    fail2ban-client reload
    
    echo ""
    echo "Fail2Ban installed. ✅"
    echo ""
else
    echo "Fail2Ban is already installed. 🚧"
    echo ""
fi

# Display the status of the fail2ban service.
systemctl status fail2ban

echo ""

