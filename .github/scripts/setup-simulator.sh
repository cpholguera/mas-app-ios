#!/bin/bash

# Setup simulator: boot and install app
# Usage: ./setup-simulator.sh <app_path> [simulator_name] [wait_seconds]
# Example: ./setup-simulator.sh "build/simulator/Build/Products/Debug-iphonesimulator/App.app" "iPhone 17" 10

set -e

APP_PATH="${1}"
SIMULATOR="${2}"
WAIT_SECONDS="${3:-10}"

if [ -z "$APP_PATH" ]; then
  echo "Error: APP_PATH is required as first argument"
  exit 1
fi

if [ ! -d "$APP_PATH" ]; then
  echo "Error: App not found at: $APP_PATH"
  exit 1
fi

echo "Setting up simulator: $SIMULATOR"
echo "App path: $APP_PATH"

# Boot the selected simulator if not already booted
xcrun simctl boot "$SIMULATOR" || echo "Simulator already booted"

# Wait for simulator to boot
if [ "$WAIT_SECONDS" -gt 0 ]; then
  echo "Waiting $WAIT_SECONDS seconds for simulator to boot..."
  sleep "$WAIT_SECONDS"
fi

# Install app on simulator
echo "Installing app on simulator..."
xcrun simctl install "$SIMULATOR" "$APP_PATH"

echo "Simulator setup complete"

