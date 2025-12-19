#!/bin/bash

# Build and test using any available iPhone simulator
# Usage: ./build-for-testing.sh [scheme] [platform]
# Example: ./build-for-testing.sh "MASTestApp" "iOS Simulator"

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

SCHEME="${1:-$DEFAULT_SCHEME}"
PLATFORM="${2:-iOS Simulator}"

if [ -z "$SCHEME" ]; then
  echo "Error: SCHEME is not set. Either pass it as argument or set DEFAULT_SCHEME environment variable."
  exit 1
fi

echo "Building for testing..."
echo "Scheme: $SCHEME"
echo "Platform: $PLATFORM"

# Find device (xcrun xctrace returns via stderr)
device=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+' | head -1 | awk '{$1=$1;print}' | sed -e "s/ Simulator$//")
echo "Device: $device"

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
cp .github/Local.xcconfig.ci Local.xcconfig

# Build for testing
xcodebuild build-for-testing \
  -scheme "$SCHEME" \
  -"$filetype_parameter" "$file_to_build" \
  -destination "platform=$PLATFORM,name=$device"

echo "Build for testing completed successfully"

popd > /dev/null || exit

