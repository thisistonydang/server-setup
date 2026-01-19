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
    apt-get update

    # Add PostgreSQL APT Repository.
    apt-get install --yes postgresql-common
    yes | /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

    # Install psql client.
    apt-get install --yes postgresql-client-${POSTGRES_VERSION}

    # Set up password file for passwordless authentication when running pg_dump.
    echo "${POSTGRES_HOST}:${POSTGRES_PORT}:${POSTGRES_DB}:${POSTGRES_USER}:${POSTGRES_PASS}" > /root/.pgpass
    chmod 0600 /root/.pgpass
    
    # Install rclone to backup the database to a remote server.
    curl https://rclone.org/install.sh | bash
    
    # Create the local backups directory.
    mkdir -parents "${POSTGRES_LOCAL_BACKUP_DIR}"

    BACKUP_SCRIPT_PATH="/root/scripts/backup-db.sh"
    CLEANUP_SCRIPT_PATH="/root/scripts/backup-db-cleanup.sh"
    # Ensure the backup and cleanup scripts are executable.
    chmod +x /root/scripts/backup-db.sh 
    chmod +x /root/scripts/backup-db-cleanup.sh

    
    echo "✅ Database backups set up for PostgreSQL."
else
    echo "🚧 Skipping database backups setup. psql client already installed or no backup directory specified."
fi

echo ""

