#!/bin/bash

# Build and test using any available iPhone simulator
# Usage: ./build-for-testing.sh [scheme]
# Example: ./build-for-testing.sh "MASTestApp"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
pushd "$SCRIPT_DIR/../.." > /dev/null || exit
source "$SCRIPT_DIR/common.sh"

echo "Building for testing..."

# Find device (xcrun xctrace returns via stderr)
DEVICE=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | head -1 | awk '{$1=$1;print}' | sed -e "s/ Simulator$//")
echo "Device: $DEVICE"

detect_xcode_project
detect_scheme "${1:-}"
copy_ci_config

# Build for testing
xcodebuild build-for-testing \
  -scheme "$APP_NAME" \
  -"$FILETYPE_PARAMETER" "$FILE_TO_BUILD" \
  -destination "platform=iOS Simulator,name=$DEVICE"

echo "Build for testing completed successfully"

popd > /dev/null || exit