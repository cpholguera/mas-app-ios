#!/bin/bash

# Build app for iOS Simulator
# Usage: ./build-for-simulator.sh <simulator> [os_version] [scheme]
# Examples: ./build-for-simulator.sh "iPhone 17"
#           ./build-for-simulator.sh "iPhone 17" "26.1"
#           ./build-for-simulator.sh "iPhone 17" "26.1" "MASTestApp"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
pushd "$SCRIPT_DIR/../.." > /dev/null || exit
source "$SCRIPT_DIR/common.sh"

SIMULATOR="${1}"
OS_VERSION="${2}"
BUILD_DIR="build/simulator"

echo "Building app for simulator..."
echo "Simulator: $SIMULATOR"
if [ -n "$OS_VERSION" ]; then
  echo "OS version: $OS_VERSION"
fi
echo "Build directory: $BUILD_DIR"

detect_xcode_project
detect_scheme "${3:-}"
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

popd > /dev/null || exit