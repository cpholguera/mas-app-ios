#!/bin/bash

# Build app for iOS Simulator
# Usage: ./build-for-simulator.sh <simulator> [os_version] [scheme]
# Examples: ./build-for-simulator.sh "iPhone 17" "latest" "MASTestApp"
#           ./build-for-simulator.sh "iPhone 16e .1" "26.1"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
pushd "$SCRIPT_DIR/../.." > /dev/null || exit
source "$SCRIPT_DIR/common.sh"

SIMULATOR="${1}"
OS_VERSION="${2:-latest}"
BUILD_DIR="build/simulator"

echo "Building app for simulator..."
echo "Simulator: $SIMULATOR"
echo "OS version: $OS_VERSION"
echo "Build directory: $BUILD_DIR"

detect_xcode_project
detect_scheme "${3:-}"
copy_ci_config

# Build with consistent output directory
xcodebuild build \
  -scheme "$APP_NAME" \
  -"$FILETYPE_PARAMETER" "$FILE_TO_BUILD" \
  -destination "platform=iOS Simulator,OS=$OS_VERSION,name=$SIMULATOR" \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

echo "Build completed successfully"
echo "App location: $BUILD_DIR/Build/Products/Debug-iphonesimulator/*.app"

popd > /dev/null || exit