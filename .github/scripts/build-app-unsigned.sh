#!/bin/bash

pushd "$(dirname "$0")/../.." > /dev/null || exit

cp .github/Local.xcconfig.ci Local.xcconfig
xcodebuild archive \
  -project "MASTestApp.xcodeproj" \
  -scheme "$DEFAULT_SCHEME" \
  -archivePath "/build/MASTestApp.xcarchive" \
  -configuration Release \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

popd > /dev/null || exit
