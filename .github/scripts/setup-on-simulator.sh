#!/bin/bash

# Setup simulator: boot and install app
# Usage:   ./setup-on-simulator.sh <simulator_name> [app_path] [wait_seconds]
# Example: ./setup-on-simulator.sh "iPhone 17"
#          ./setup-on-simulator.sh "iPhone 17" "path/to/app.app"
#          ./setup-on-simulator.sh "iPhone 17" "path/to/app.app" 15

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

SIMULATOR="${1}"
APP_PATH="${2}"
WAIT_SECONDS="${3:-10}"

if [ -z "$SIMULATOR" ]; then
  echo "Error: Simulator name is required as the first argument."
  exit 1
fi

if [ -z "$APP_PATH" ]; then
  APP_PATH=$(find build/simulator/Build/Products/Debug-iphonesimulator -name "*.app" | head -n 1)
fi

echo "Setting up simulator: $SIMULATOR"
echo "App path: $APP_PATH"

# Boot the selected simulator if not already booted
boot_error=$(xcrun simctl boot "$SIMULATOR" 2>&1) && boot_result=0 || boot_result=$?

if [ "$boot_result" -eq 0 ]; then
  echo "Simulator $SIMULATOR booted successfully"
  # Wait for simulator to fully boot
  if [ "$WAIT_SECONDS" -gt 0 ]; then
    echo "Waiting $WAIT_SECONDS seconds for simulator to boot..."
    sleep "$WAIT_SECONDS"
  fi
elif [ "$boot_result" -eq 149 ]; then
  echo "Simulator $SIMULATOR already booted"
else
  echo "Error: Failed to boot simulator, reason: $boot_error" >&2
  echo "Available simulators:"
  xcrun simctl list devices
  exit 1
fi

# Install app on simulator
echo "Installing app on simulator..."
xcrun simctl install "$SIMULATOR" "$APP_PATH"

echo "Simulator setup complete"

popd > /dev/null || exit
