#!/usr/bin/env bash
set -euo pipefail

echo "Restarting Rails application (Puma)..."
sudo systemctl restart hello-world

echo "Restarting Nginx..."
sudo systemctl restart nginx

echo "Services restarted successfully."
