#!/bin/bash
set -euo pipefail

echo "Cleaning up old database backups..."

# Load environment variables. Required so that the following variables are available:
# - POSTGRES_LOCAL_BACKUP_DIR
# - POSTGRES_REMOTE_BACKUP_DIR
source .env
