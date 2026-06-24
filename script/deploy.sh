#!/usr/bin/env bash
set -euo pipefail

# 1. Define variables
APP_PATH="/home/ubuntu/hello-world-infra-lab"

echo "--- Starting Deployment ---"

# 2. Go to app folder
cd "$APP_PATH"

# 3. Load environment variables if they exist
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

# 9. Health check
echo "Verifying deployment..."
./script/health_check.sh

echo "--- Deployment Complete! ---"
