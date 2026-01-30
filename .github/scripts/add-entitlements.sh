#!/bin/bash

# Add entitlements to built app using ldid
# Usage: ./add-entitlements.sh

set -e

APP_NAME="${APP_NAME:-MASTestApp}"
ARCHIVE_PATH="${ARCHIVE_PATH:-build/${APP_NAME}.xcarchive}"

pushd "$(dirname "$0")/../.." > /dev/null || exit

ldid -Sentitlements.plist "${ARCHIVE_PATH}/Products/Applications/${APP_NAME}.app/${APP_NAME}"

popd > /dev/null || exit
