#!/bin/bash

# Build app for simulator, boot the simulator, and install the app.
# Usage:   ./build-and-install-on-simulator.sh <simulator> [os_version] [wait_seconds]
# Example: ./build-and-install-on-simulator.sh "iPhone 17"
#          ./build-and-install-on-simulator.sh "iPhone 17" "26.1"
#          ./build-and-install-on-simulator.sh "iPhone 17" "26.1" 15

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
pushd "$SCRIPT_DIR/../.." > /dev/null || exit
source "$SCRIPT_DIR/common.sh"

SIMULATOR="${1}"
OS_VERSION="${2}"
WAIT_SECONDS="${3:-10}"
BUILD_DIR="build/simulator"

if [ -z "$SIMULATOR" ]; then
  echo "Error: Simulator name is required as the first argument."
  exit 1
fi

echo "Building app for simulator..."
echo "Simulator: $SIMULATOR"
if [ -n "$OS_VERSION" ]; then
  echo "OS version: $OS_VERSION"
fi
echo "Build directory: $BUILD_DIR"

detect_xcode_project
detect_scheme
copy_ci_config

# Build with consistent output directory
BUILD_DESTINATION="platform=iOS Simulator,name=$SIMULATOR"
if [ -n "$OS_VERSION" ]; then
  BUILD_DESTINATION="$BUILD_DESTINATION,OS=$OS_VERSION"
fi

xcodebuild build \
  -scheme "$APP_NAME" \
  -"$FILETYPE_PARAMETER" "$FILE_TO_BUILD" \
  -destination "$BUILD_DESTINATION" \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

echo "Build completed successfully"
echo "App location: $BUILD_DIR/Build/Products/Debug-iphonesimulator/$APP_NAME.app"

APP_PATH=$(find "$BUILD_DIR/Build/Products/Debug-iphonesimulator" -name "*.app" | head -n 1)
if [ ! -d "$APP_PATH" ]; then
  echo "Error: App not found at $APP_PATH" >&2
  exit 1
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
  xcrun simctl list devices available
  exit 1
fi

# Install app on simulator
echo "Installing app on simulator..."
xcrun simctl install "$SIMULATOR" "$APP_PATH"

echo "Simulator setup complete"

popd > /dev/null || exit
