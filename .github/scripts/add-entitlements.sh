#!/bin/bash

# Add entitlements to built app using ldid
# Usage: ./add-entitlements.sh [extra-entitlements.plist]
#   Optional: pass a plist file to merge with the default entitlements.plist

set -e

APP_NAME="${APP_NAME:-MASTestApp}"
ARCHIVE_PATH="${ARCHIVE_PATH:-build/${APP_NAME}.xcarchive}"
EXTRA_PLIST="$1"

pushd "$(dirname "$0")/../.." > /dev/null || exit

BASE_PLIST="entitlements.plist"
TARGET_PLIST="$BASE_PLIST"

if [ -n "$EXTRA_PLIST" ]; then
    /usr/libexec/PlistBuddy -c "Merge $BASE_PLIST" "$EXTRA_PLIST"
    TARGET_PLIST="$EXTRA_PLIST"
fi

ldid -S"${TARGET_PLIST}" "${ARCHIVE_PATH}/Products/Applications/${APP_NAME}.app/${APP_NAME}"

popd > /dev/null || exit
