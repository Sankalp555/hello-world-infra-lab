#!/usr/bin/env bash
set -eo pipefail

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

# 3. Fetch secrets from AWS Secrets Manager using Ruby (since we have the gem)
echo "Fetching database credentials from AWS Secrets Manager..."
DB_SECRETS=$($RVM_DO ruby -e "
require 'aws-sdk-secretsmanager'
require 'json'
begin
  client = Aws::SecretsManager::Client.new(region: 'ap-south-1')
  resp = client.get_secret_value(secret_id: 'production/rails-app/db-creds')
  puts resp.secret_string
rescue => e
  STDERR.puts \"Error: #{e.message}\"
  exit 1
end
")

DATABASE_HOST=$(echo $DB_SECRETS | $RVM_DO ruby -e "require 'json'; puts JSON.parse(STDIN.read)['host']")
DATABASE_USERNAME=$(echo $DB_SECRETS | $RVM_DO ruby -e "require 'json'; puts JSON.parse(STDIN.read)['username']")
HELLO_WORLD_DATABASE_PASSWORD=$(echo $DB_SECRETS | $RVM_DO ruby -e "require 'json'; puts JSON.parse(STDIN.read)['password']")

# 4. Perform backup using pg_dump
echo "Creating backup: ${BACKUP_FILE}"
PGPASSWORD="${HELLO_WORLD_DATABASE_PASSWORD}" pg_dump -h "${DATABASE_HOST}" -U "${DATABASE_USERNAME}" "${DATABASE_NAME}" > "$BACKUP_FILE"

echo "Backup completed successfully."

# 5. List latest backups
echo "Latest backups in ${BACKUP_PATH}:"
ls -lh "$BACKUP_PATH" | tail -n 5
