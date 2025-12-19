#!/bin/bash

# Build app for iOS Simulator
# Usage: ./build-for-simulator.sh [scheme] [platform] [simulator]
# Example: ./build-for-simulator.sh "MASTestApp" "iOS Simulator" "iPhone 17"

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

SCHEME="${1:-$DEFAULT_SCHEME}"
PLATFORM="${2:-iOS Simulator}"
SIMULATOR="${3:-iPhone 17}"
BUILD_DIR="build/simulator"

if [ -z "$SCHEME" ]; then
  echo "Error: SCHEME is not set. Either pass it as argument or set DEFAULT_SCHEME environment variable."
  exit 1
fi

echo "Building app for simulator..."
echo "Scheme: $SCHEME"
echo "Platform: $PLATFORM"
echo "Simulator: $SIMULATOR"
echo "Build directory: $BUILD_DIR"

# Copy CI config
cp .github/Local.xcconfig.ci Local.xcconfig

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

# Build with consistent output directory
xcodebuild build \
  -scheme "$SCHEME" \
  -"$filetype_parameter" "$file_to_build" \
  -destination "platform=$PLATFORM,name=$SIMULATOR" \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

echo "Build completed successfully"
echo "App location: $BUILD_DIR/Build/Products/Debug-iphonesimulator/*.app"

popd > /dev/null || exit

