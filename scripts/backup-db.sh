#!/bin/bash
set -euo pipefail

# Load environment variables. Required so that the following variables are available:
# - POSTGRES_LOCAL_BACKUP_DIR
# - POSTGRES_REMOTE_BACKUP_DIR
# - POSTGRES_HOST
# - POSTGRES_PORT
# - POSTGRES_DB
# - POSTGRES_USER
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../.env"

# Generate filename for the backup.
DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILENAME="${DATE}.dump"
BACKUP_PATH="${POSTGRES_LOCAL_BACKUP_DIR}/${FILENAME}"

echo "Backing up database to: ${BACKUP_PATH}..."

pg_dump \
  --host="${POSTGRES_HOST}" \
  --port="${POSTGRES_PORT}" \
  --dbname="${POSTGRES_DB}" \
  --username="${POSTGRES_USER}" \
  --no-password \
  --format=custom \
  --file="${BACKUP_PATH}"

if rclone copy "${BACKUP_PATH}" "${POSTGRES_REMOTE_BACKUP_DIR}"; then
  echo "✅ Database backup completed and uploaded to remote."
else
  echo "‼️ Error: pg_dump ran but rclone copy to remote failed!"
  exit 1
fi

echo ""