#!/bin/bash

# Install app on iOS Simulator
# Usage: ./install-app-simulator.sh [app_path] [simulator_name]
# Example: ./install-app-simulator.sh "/path/to/App.app" "iPhone 17"

set -e

APP_PATH="${1}"
SIMULATOR="${2:-${SIMULATOR:-iPhone 17}}"

if [ -z "$APP_PATH" ]; then
  echo "Error: APP_PATH is required as first argument"
  exit 1
fi

if [ ! -d "$APP_PATH" ]; then
  echo "Error: App not found at: $APP_PATH"
  exit 1
fi

echo "Installing app on simulator: $SIMULATOR"
echo "App path: $APP_PATH"

xcrun simctl install "$SIMULATOR" "$APP_PATH"

echo "App installed successfully"

