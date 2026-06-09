#!/bin/bash
set -euo pipefail

echo "Configuring SSH..."

# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
	echo "Generating SSH host keys..."
	ssh-keygen -A
fi

# Write our hardening to a drop-in that is read BEFORE other drop-ins such as
# 50-cloud-init.conf. sshd uses the FIRST value it obtains for each keyword, and
# the main sshd_config Includes sshd_config.d/*.conf (in lexical order) near the
# top of the file. A "00-" prefix therefore takes precedence over both the
# cloud-init drop-in and any later lines, guaranteeing our values win.
HARDENING_CONF="/etc/ssh/sshd_config.d/00-hardening.conf"
mkdir --parents /etc/ssh/sshd_config.d
cat >"${HARDENING_CONF}" <<'EOF'
# Managed by server-setup.
# Disable password authentication (SSH keys only).
PasswordAuthentication no
# Allow root login via SSH key only (never password).
PermitRootLogin prohibit-password
EOF
chmod 0644 "${HARDENING_CONF}"

# Validate the full sshd config before restarting so a bad file can't break sshd.
sshd -t

# Restart SSH service.
systemctl restart ssh

# Verify the EFFECTIVE settings and FAIL loudly if they aren't what we set.
# `sshd -T` resolves all Includes, so this catches any drop-in (e.g. cloud-init)
# that might otherwise override us. This is the key safety net: the script must
# never report success while password auth is still enabled.
EFFECTIVE_CONFIG="$(sshd -T)"

if ! echo "${EFFECTIVE_CONFIG}" | grep --quiet --ignore-case '^passwordauthentication no$'; then
	echo "‼️ Error: PasswordAuthentication is not 'no' after configuration!"
	echo "${EFFECTIVE_CONFIG}" | grep --ignore-case '^passwordauthentication' || true
	exit 1
fi

if ! echo "${EFFECTIVE_CONFIG}" | grep --quiet --ignore-case '^permitrootlogin prohibit-password$'; then
	echo "‼️ Error: PermitRootLogin is not 'prohibit-password' after configuration!"
	echo "${EFFECTIVE_CONFIG}" | grep --ignore-case '^permitrootlogin' || true
	exit 1
fi

echo "✅ SSH configured and verified (password auth disabled, root key-only)."
echo ""

# Reference:
# https://man.openbsd.org/sshd_config
