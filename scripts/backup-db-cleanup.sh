#!/bin/bash
set -euo pipefail

echo "Cleaning up old database backups..."

# Load environment variables. Required so that the following variables are available:
# - POSTGRES_LOCAL_BACKUP_DIR
# - POSTGRES_REMOTE_BACKUP_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../.env"

MIN_AGE_IN_DAYS=30

# Clean local backups.
find "${POSTGRES_LOCAL_BACKUP_DIR}" -type f -name "*.dump" -mtime +${MIN_AGE_IN_DAYS} -delete

# Clean remote backups.
rclone delete "${POSTGRES_REMOTE_BACKUP_DIR}" --include "*.dump" --min-age ${MIN_AGE_IN_DAYS}d 

echo "✅ Database backups cleaned up."
echo ""