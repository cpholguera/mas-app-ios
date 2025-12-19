#!/bin/bash

# Build an unsigned archive of the app
# Usage: ./build-unsigned.sh

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

# Copy CI config
.github/scripts/setup-xcode-config.sh

xcodebuild archive \
  -project "MASTestApp.xcodeproj" \
  -scheme "MASTestApp" \
  -archivePath "build/MASTestApp.xcarchive" \
  -configuration Release \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

popd > /dev/null || exit
