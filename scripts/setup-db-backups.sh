#!/bin/bash
set -euo pipefail

echo "Setting up database backups..."

# Load environment variables. Required so that the following variables are available:
# - POSTGRES_LOCAL_BACKUP_DIR
# - POSTGRES_VERSION
# - POSTGRES_HOST
# - POSTGRES_PORT
# - POSTGRES_DB
# - POSTGRES_USER
# - POSTGRES_PASS
source .env

# Set up db backups if psql client is not already installed and a local Postgres
# backup directory is specified in the .env file.
if ! command -v psql &> /dev/null && [[ -n "${POSTGRES_LOCAL_BACKUP_DIR}" ]]; then

echo ""

