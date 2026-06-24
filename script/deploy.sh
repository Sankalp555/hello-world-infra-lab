#!/usr/bin/env bash
set -euo pipefail

# 1. Define variables
APP_PATH="/home/ubuntu/hello-world-infra-lab"

# 2. Load RVM (Required for non-interactive shells like GitHub Actions)
if [ -f "$HOME/.rvm/scripts/rvm" ]; then
  echo "Loading RVM..."
  source "$HOME/.rvm/scripts/rvm"
fi

echo "--- Starting Deployment ---"

# 2. Go to app folder
cd "$APP_PATH"

# 3. Perform pre-deployment backup
echo "Taking pre-deployment backup..."
./script/backup_db.sh

# 4. Load environment variables if they exist
if [ -f .env.production ]; then
  echo "Loading environment variables from .env.production..."
  export $(grep -v '^#' .env.production | xargs)
fi

# 4. Pull latest code
echo "Pulling latest code from GitHub..."
git pull

# 5. Install dependencies
echo "Installing gems..."
bundle install

# 6. Database migrations
echo "Running migrations..."
RAILS_ENV=production bin/rails db:migrate

# 7. Precompile assets
echo "Precompiling assets..."
RAILS_ENV=production bin/rails assets:precompile

# 8. Restart services
echo "Restarting services..."
./script/restart_services.sh

# 9. Wait for app to boot
echo "Waiting 5 seconds for application to boot..."
sleep 5

# 10. Health check
echo "Verifying deployment..."
./script/health_check.sh

echo "--- Deployment Complete! ---"
