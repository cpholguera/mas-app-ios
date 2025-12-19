#!/bin/bash

# Build app for iOS Simulator
# Usage: ./build-app-simulator.sh [scheme] [platform] [simulator] [derived_data_path]
# Example: ./build-app-simulator.sh "MASTestApp" "iOS Simulator" "iPhone 17" "DerivedData"

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

SCHEME="${1:-$DEFAULT_SCHEME}"
PLATFORM="${2:-iOS Simulator}"
SIMULATOR="${3:-iPhone 17}"
DERIVED_DATA_PATH="${4:-}"

if [ -z "$SCHEME" ]; then
  echo "Error: SCHEME is not set. Either pass it as argument or set DEFAULT_SCHEME environment variable."
  exit 1
fi

echo "Building app for simulator..."
echo "Scheme: $SCHEME"
echo "Platform: $PLATFORM"
echo "Simulator: $SIMULATOR"

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

# Build command
BUILD_CMD="xcodebuild build \
  -scheme \"$SCHEME\" \
  -\"$filetype_parameter\" \"$file_to_build\" \
  -destination \"platform=$PLATFORM,name=$SIMULATOR\""

# Add derived data path if specified
if [ -n "$DERIVED_DATA_PATH" ]; then
  BUILD_CMD="$BUILD_CMD -derivedDataPath \"$DERIVED_DATA_PATH\""
fi

# Add code signing settings
BUILD_CMD="$BUILD_CMD \
  CODE_SIGN_IDENTITY=\"\" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO"

eval "$BUILD_CMD"

echo "Build completed successfully"

popd > /dev/null || exit

