#!/bin/bash

# Build an unsigned archive of the app
# Usage:   ./build-unsigned.sh [scheme]
# Example: ./build-unsigned.sh
#          ./build-unsigned.sh "MASTestApp"

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
pushd "$SCRIPT_DIR/../.." > /dev/null || exit
source "$SCRIPT_DIR/common.sh"

detect_xcode_project
detect_scheme "${1:-}"
copy_ci_config

xcodebuild archive \
  -scheme "$APP_NAME" \
  -"$FILETYPE_PARAMETER" "$FILE_TO_BUILD" \
  -archivePath "build/$APP_NAME.xcarchive" \
  -configuration Release \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

popd > /dev/null || exit