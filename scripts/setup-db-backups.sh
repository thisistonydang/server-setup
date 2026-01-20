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
    mkdir --parents "${POSTGRES_LOCAL_BACKUP_DIR}"

    BACKUP_SCRIPT_PATH="/root/scripts/backup-db.sh"
    CLEANUP_SCRIPT_PATH="/root/scripts/backup-db-cleanup.sh"
    CRON_SCHEDULE="0 2 * * *" # Run daily at 2 AM.

    # Ensure the backup and cleanup scripts are executable.
    chmod +x "${BACKUP_SCRIPT_PATH}"
    chmod +x "${CLEANUP_SCRIPT_PATH}"

    # Add cron job for backup script if it doesn't already exist.
    if crontab -l 2>/dev/null | grep -F "${BACKUP_SCRIPT_PATH}" > /dev/null; then
        echo "🚧 Cron job for ${BACKUP_SCRIPT_PATH} already exists. Skipping."
    else
        (crontab -l 2>/dev/null; echo "${CRON_SCHEDULE} ${BACKUP_SCRIPT_PATH}") | crontab -
    fi

    # Add cron job for cleanup script if it doesn't already exist.
    if crontab -l 2>/dev/null | grep -F "${CLEANUP_SCRIPT_PATH}" > /dev/null; then
        echo "🚧 Cron job for ${CLEANUP_SCRIPT_PATH} already exists. Skipping."
    else
        (crontab -l 2>/dev/null; echo "${CRON_SCHEDULE} ${CLEANUP_SCRIPT_PATH}") | crontab -
    fi

    # Display the status of the cron jobs.
    crontab -l
    
    echo "✅ Database backups set up for PostgreSQL."
else
    echo "🚧 Skipping database backups setup. psql client already installed or no backup directory specified."
fi

echo ""

