#!/bin/bash

# Setup simulator: boot and install app
# Usage: ./setup-simulator.sh <simulator_name> [app_path] [wait_seconds]
# Example: ./setup-simulator.sh "iPhone 17"
#          ./setup-simulator.sh "iPhone 17" "path/to/app.app"
#          ./setup-simulator.sh "iPhone 17" "path/to/app.app" 15

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

SIMULATOR="${1}"
APP_PATH="${2}"
WAIT_SECONDS="${3:-10}"

if [ -z "$APP_PATH" ]; then
  APP_PATH=$(find build/simulator/Build/Products/Debug-iphonesimulator -name "*.app" | head -n 1)
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

popd > /dev/null || exit
