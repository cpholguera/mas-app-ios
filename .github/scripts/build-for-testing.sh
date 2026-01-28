#!/bin/bash

# Build and test using any available iPhone simulator
# Usage: ./build-for-testing.sh

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

echo "Building for testing..."

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

# Determine scheme: prefer CLI argument, then auto-detect, then fall back to MASTestApp
if [ -n "$1" ]; then
  scheme="$1"
else
  scheme=$(xcodebuild -list -"$filetype_parameter" "$file_to_build" 2>/dev/null | \
    awk '/Schemes:/{flag=1;next} /^$/{flag=0} flag' | head -n 1 | awk '{$1=$1;print}')
  if [ -z "$scheme" ]; then
    scheme="MASTestApp"
  fi
fi

echo "Scheme: $scheme"

# Copy CI config
cp .github/Local.xcconfig.ci Local.xcconfig

# Build for testing
xcodebuild build-for-testing \
  -scheme "$scheme" \
  -"$filetype_parameter" "$file_to_build" \
  -destination "platform=iOS Simulator,name=$device"

echo "Build for testing completed successfully"

popd > /dev/null || exit

