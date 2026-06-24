#!/usr/bin/env bash
set -euo pipefail

# 1. Define variables
APP_PATH="/home/ubuntu/hello-world-infra-lab"
RVM_DO="/home/ubuntu/.rvm/bin/rvm 3.3.4 do"
BACKUP_PATH="${APP_PATH}/backups"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
DATABASE_NAME="hello_world_production"
BACKUP_FILE="${BACKUP_PATH}/${DATABASE_NAME}_${TIMESTAMP}.sql"

echo "--- Starting Database Backup ---"

# 2. Ensure backup directory exists
mkdir -p "$BACKUP_PATH"

# 3. Load environment variables for DB password
if [ -f "${APP_PATH}/.env.production" ]; then
  echo "Loading environment variables..."
  export $(grep -v '^#' "${APP_PATH}/.env.production" | xargs)
fi

# 4. Perform backup using pg_dump
echo "Creating backup: ${BACKUP_FILE}"
PGPASSWORD="${HELLO_WORLD_DATABASE_PASSWORD}" pg_dump -h localhost -U hello_world "$DATABASE_NAME" > "$BACKUP_FILE"

echo "Backup completed successfully."

# 5. List latest backups
echo "Latest backups in ${BACKUP_PATH}:"
ls -lh "$BACKUP_PATH" | tail -n 5
