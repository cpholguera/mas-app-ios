#!/bin/bash

# Build app for iOS Simulator
# Usage: ./build-for-simulator.sh [simulator]
# Example: ./build-for-simulator.sh "iPhone 17"

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

SIMULATOR="${1}"
BUILD_DIR="build/simulator"

echo "Building app for simulator..."
echo "Simulator: $SIMULATOR"
echo "Build directory: $BUILD_DIR"

# Determine if we have a workspace or project
if ls -A | grep -iq "\.xcworkspace$"; then
  filetype_parameter="workspace"
  file_to_build=$(ls -A | grep -i "\.xcworkspace$")
else
  filetype_parameter="project"
  file_to_build=$(ls -A | grep -i "\.xcodeproj$")
fi

file_to_build=$(echo "$file_to_build" | awk '{$1=$1;print}')

echo "Building $filetype_parameter: $file_to_build"

# Copy CI config
.github/scripts/setup-xcode-config.sh

# Build with consistent output directory
xcodebuild build \
  -scheme "MASTestApp" \
  -"$filetype_parameter" "$file_to_build" \
  -destination "platform=iOS Simulator,name=$SIMULATOR" \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

echo "Build completed successfully"
echo "App location: $BUILD_DIR/Build/Products/Debug-iphonesimulator/*.app"

popd > /dev/null || exit

