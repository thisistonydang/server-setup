#!/bin/bash
set -euo pipefail

# Load environment variables. Required so that the PostgreSQL related variables are available:
# - POSTGRES_HOST
# - POSTGRES_PORT
# - POSTGRES_DB
# - POSTGRES_USER
source .env

DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILENAME="${DATE}.dump"
BACKUP_PATH="/root/db_backups/${FILENAME}"

echo "Backing up database to: ${BACKUP_PATH}..."

