#!/bin/bash

# Add entitlements to built app using ldid
# Usage: ./add-entitlements.sh

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

ldid -Sentitlements.plist "build/MASTestApp.xcarchive/Products/Applications/MASTestApp.app/MASTestApp"

popd > /dev/null || exit
