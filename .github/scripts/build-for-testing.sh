#!/bin/bash

# Build for tests using any available iPhone simulator
# Usage:   ./build-for-testing.sh [simulator] [os_version]
# Example: ./build-for-testing.sh
#          ./build-for-testing.sh "iPhone 17"
#          ./build-for-testing.sh "iPhone 17" "26.2"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
pushd "$SCRIPT_DIR/../.." > /dev/null || exit
source "$SCRIPT_DIR/common.sh"

echo "Building for testing..."

SIMULATOR="${1:-}"
OS_VERSION="${2:-}"

if [ -z "$SIMULATOR" ]; then
  # Find device (xcrun xctrace returns via stderr)
  DEVICE=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | head -1 | awk '{$1=$1;print}' | sed -e "s/ Simulator$//")
  SIMULATOR="$DEVICE"
fi
echo "Simulator: $SIMULATOR"
if [ -n "$OS_VERSION" ]; then
  echo "OS version: $OS_VERSION"
fi

detect_xcode_project
detect_scheme
copy_ci_config

# Build for testing
BUILD_DESTINATION="platform=iOS Simulator,name=$SIMULATOR"
if [ -n "$OS_VERSION" ]; then
  BUILD_DESTINATION="$BUILD_DESTINATION,OS=$OS_VERSION"
fi

xcodebuild build-for-testing \
  -scheme "$APP_NAME" \
  -"$FILETYPE_PARAMETER" "$FILE_TO_BUILD" \
  -destination "$BUILD_DESTINATION"

echo "Build for testing completed successfully"

popd > /dev/null || exit