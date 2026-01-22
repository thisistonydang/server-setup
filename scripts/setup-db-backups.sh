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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../.env"

# Set up db backups if POSTGRES_LOCAL_BACKUP_DIR is set in the .env file.
if [[ -n "${POSTGRES_LOCAL_BACKUP_DIR}" ]]; then
    apt-get update

    # Add PostgreSQL APT Repository.
    apt-get install --yes postgresql-common
    echo | /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

    # Install psql client.
    apt-get install --yes "postgresql-client-${POSTGRES_VERSION}"

    # Set up password file for passwordless authentication when running pg_dump.
    echo "${POSTGRES_HOST}:${POSTGRES_PORT}:${POSTGRES_DB}:${POSTGRES_USER}:${POSTGRES_PASS}" > /root/.pgpass
    chmod 0600 /root/.pgpass
    
    # Install rclone to backup the database to a remote server.
    if ! command -v rclone &> /dev/null; then
        curl -fsSL https://rclone.org/install.sh -o /tmp/rclone-install.sh
        bash /tmp/rclone-install.sh
        rm /tmp/rclone-install.sh
    fi
    
    # Create the local backups directory.
    mkdir --parents "${POSTGRES_LOCAL_BACKUP_DIR}"

    BACKUP_SCRIPT_PATH="/root/scripts/backup-db.sh"
    CLEANUP_SCRIPT_PATH="/root/scripts/backup-db-cleanup.sh"

    # Ensure the backup and cleanup scripts are executable.
    chmod +x "${BACKUP_SCRIPT_PATH}"
    chmod +x "${CLEANUP_SCRIPT_PATH}"

    # Add cron job for backup script if it doesn't already exist.
    if crontab -l 2>/dev/null | grep --fixed-strings "${BACKUP_SCRIPT_PATH}" > /dev/null; then
        echo "⚠️ Warning: Cron job for ${BACKUP_SCRIPT_PATH} already exists. Skipping."
    else
        (crontab -l 2>/dev/null; echo "0 1 * * * ${BACKUP_SCRIPT_PATH} >> ${POSTGRES_LOCAL_BACKUP_DIR}/backup.log 2>&1") | crontab -
    fi

    # Add cron job for cleanup script if it doesn't already exist.
    if crontab -l 2>/dev/null | grep --fixed-strings "${CLEANUP_SCRIPT_PATH}" > /dev/null; then
        echo "⚠️ Warning: Cron job for ${CLEANUP_SCRIPT_PATH} already exists. Skipping."
    else
        (crontab -l 2>/dev/null; echo "0 2 * * * ${CLEANUP_SCRIPT_PATH} >> ${POSTGRES_LOCAL_BACKUP_DIR}/cleanup.log 2>&1") | crontab -
    fi

    # Display the status of the cron jobs.
    echo ""
    echo "Cron jobs:"
    crontab -l
    echo ""
    
    echo "✅ Database backups set up for PostgreSQL."
else
    echo "⚠️ Warning: Skipping database backups setup. psql client already installed or no backup directory specified."
fi

echo ""

