#!/bin/bash

set -e

APP_NAME="High Availability Web App"
APP_URL="http://localhost:5000"

check_app_status() {
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")

    if [[ "$STATUS_CODE" -eq 200 ]]; then
        echo "Application is running and responding with HTTP 200 OK."
        return 0
    else
        echo "Application is not responding as expected. HTTP Status Code: $STATUS_CODE"
        return 1
    fi
}

check_app_content() {
    CONTENT=$(curl -s "$APP_URL")
    if [[ "$CONTENT" == *"$APP_NAME"* ]]; then
        echo "Application content test passed.  Found '$APP_NAME' in the response."
        return 0
    else
        echo "Application content test failed.  Could not find '$APP_NAME' in the response."
        return 1
    fi
}

echo "Starting tests for $APP_NAME"

check_app_status
STATUS_CHECK_RESULT=$?

check_app_content
CONTENT_CHECK_RESULT=$?

if [[ "$STATUS_CHECK_RESULT" -eq 0 && "$CONTENT_CHECK_RESULT" -eq 0 ]]; then
    echo "All tests passed!"
    exit 0
else
    echo "Some tests failed!"
    exit 1
fi
