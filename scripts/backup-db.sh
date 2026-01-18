#!/bin/bash
set -euo pipefail

# Load environment variables. Required so that the PostgreSQL related variables are available:
# - POSTGRES_BACKUP_DIR
# - POSTGRES_HOST
# - POSTGRES_PORT
# - POSTGRES_DB
# - POSTGRES_USER
source .env

# Generate filename for the backup.
DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILENAME="${DATE}.dump"
BACKUP_PATH="/root/db_backups/${FILENAME}"

echo "Backing up database to: ${BACKUP_PATH}..."

pg_dump \
  --host="${POSTGRES_HOST}" \
  --port="${POSTGRES_PORT}" \
  --dbname="${POSTGRES_DB}" \
  --username="${POSTGRES_USER}" \
  --no-password \
  --format=custom \
  > "${BACKUP_PATH}"

rclone copy "${BACKUP_PATH}" remote:db_backups

echo "✅ Database backup completed and uploaded to Google Drive."
echo ""