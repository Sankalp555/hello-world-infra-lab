#!/usr/bin/env bash
set -euo pipefail

APP_URL="${APP_URL:-http://localhost}"

echo "Checking health endpoint: ${APP_URL}/health"

status_code="$(curl -s -o /tmp/health_check_response.txt -w "%{http_code}" "${APP_URL}/health")"

if [ "$status_code" = "200" ]; then
  echo "Health check passed"
  exit 0
fi

echo "Health check failed with status: ${status_code}"
echo "Response body:"
cat /tmp/health_check_response.txt
exit 1
