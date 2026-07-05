#!/usr/bin/env bash
set -eo pipefail

# 1. Define variables
APP_PATH="/home/ubuntu/hello-world-infra-lab"
RVM_DO="/home/ubuntu/.rvm/bin/rvm 3.3.4 do"

echo "--- Starting Deployment ---"

# 2. Go to app folder
cd "$APP_PATH"

# 3. Pull latest code FIRST
echo "Pulling latest code from GitHub..."
git pull

# 4. Load environment variables for the script's own use (like backup)
if [ -f .env.production ]; then
  echo "Loading environment variables from .env.production..."
  export $(grep -v '^#' .env.production | xargs)
else
  echo "ERROR: .env.production not found!"
  exit 1
fi

# 5. Perform pre-deployment backup
echo "Taking pre-deployment backup..."
./script/backup_db.sh

# 6. Install dependencies
echo "Installing gems..."
$RVM_DO bundle install

# 7. Database migrations
echo "Running migrations..."
$RVM_DO env RAILS_ENV=production bundle exec rails db:migrate

# 8. Precompile assets
echo "Precompiling assets..."
$RVM_DO env RAILS_ENV=production bundle exec rails assets:precompile

# 9. Restart services
echo "Restarting services..."
./script/restart_services.sh

# 10. Wait for app to boot
echo "Waiting 5 seconds for application to boot..."
sleep 5

# 11. Health check
echo "Verifying deployment..."
./script/health_check.sh

echo "--- Deployment Complete! ---"
