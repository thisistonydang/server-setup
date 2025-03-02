#!/bin/bash
set -euo pipefail

echo "Configuring SSH..."

# Verify PasswordAuthentication setting is recognized by sshd (in case the setting was deprecated).
if ! sshd -T | grep --quiet "^passwordauthentication\s\+" ; then
    echo "Warning: PasswordAuthentication setting not recognized by sshd"
    exit 1
fi

# Change PasswordAuthentication setting to `no` if it exists. 
sed --in-place 's/^#*\(PasswordAuthentication\) .*/\1 no/' /etc/ssh/sshd_config

# If PasswordAuthentication setting doesn't exist yet, add it to the file.
grep --quiet '^PasswordAuthentication no' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

# Verify PermitRootLogin setting is recognized by sshd (in case the setting was deprecated).
if ! sshd -T | grep --quiet "^permitrootlogin\s\+" ; then
    echo "Warning: PermitRootLogin setting not recognized by sshd"
    exit 1
fi

# Change PermitRootLogin setting to prohibit-password if it exists.
sed --in-place 's/^#*\(PermitRootLogin\) .*/\1 prohibit-password/' /etc/ssh/sshd_config

# If PermitRootLogin setting doesn't exist yet, add it to the file.
grep --quiet '^PermitRootLogin prohibit-password' /etc/ssh/sshd_config || echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config

# Restart SSH service.
systemctl restart ssh

echo "SSH configured!"

# Verify settings were applied.
sshd -T | grep --extended-regexp --ignore-case 'PasswordAuthentication|PermitRootLogin'
echo ""

# Reference:
# https://man.openbsd.org/sshd_config
