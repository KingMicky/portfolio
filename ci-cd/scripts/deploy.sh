#!/bin/bash

APP_NAME="your_app_name"
DEPLOY_DIR="/var/www/$APP_NAME"
REPO_URL="your_repo_url"
BRANCH="main"

# Stop the current application (if running)
echo "Stopping the current application..."
# Replace with your application's stop command
# Example:
# systemctl stop $APP_NAME
# docker stop $APP_NAME
echo "Current application stopped."


echo "Removing the old deployment directory..."
sudo rm -rf $DEPLOY_DIR
echo "Old deployment directory removed."

echo "Cloning the latest code from the repository..."
sudo git clone -b $BRANCH $REPO_URL $DEPLOY_DIR
echo "Latest code cloned."

echo "Installing dependencies..."
cd $DEPLOY_DIR
pip install -r requirements.txt
echo "Dependencies installed."

# Build the application (if necessary)
echo "Building the application..."
# Replace with your application's build command
# Example:
# npm run build
echo "Application built."

# Start the application
echo "Starting the application..."
# Replace with your application's start command
# Example:
# systemctl start $APP_NAME
# or
# docker-compose up -d
echo "Application started."

echo "Deployment complete!"