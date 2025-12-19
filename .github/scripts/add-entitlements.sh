#!/bin/bash

pushd "$(dirname "$0")/../.." > /dev/null || exit

ldid -Sentitlements.plist "$GITHUB_WORKSPACE/build/MASTestApp.xcarchive/Products/Applications/MASTestApp.app/MASTestApp"

popd > /dev/null || exit
