#!/bin/bash
set -euo pipefail

echo "Cleaning up old database backups..."

# Load environment variables. Required so that the following variables are available:
# - POSTGRES_LOCAL_BACKUP_DIR
# - POSTGRES_REMOTE_BACKUP_DIR
# - POSTGRES_MIN_AGE_IN_DAYS
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../.env"

# Clean local backups.
find "${POSTGRES_LOCAL_BACKUP_DIR}" -type f -name "*.dump" -mtime "+${POSTGRES_MIN_AGE_IN_DAYS}" -delete

# Clean remote backups.
rclone delete "${POSTGRES_REMOTE_BACKUP_DIR}" --include "*.dump" --min-age "${POSTGRES_MIN_AGE_IN_DAYS}d" 

echo "✅ Database backups cleaned up."
echo ""