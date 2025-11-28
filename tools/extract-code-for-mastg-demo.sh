#!/bin/bash

pushd "$(dirname "$0")/.." > /dev/null || exit

xcodebuild -project MASTestApp.xcodeproj -scheme MASTestApp -configuration Release -destination 'generic/platform=iOS' -archivePath ./MASTestApp.xcarchive archive CODE_SIGNING_ALLOWED=NO

mkdir -p output

cp MASTestApp.xcarchive/Products/Applications/MASTestApp.app/Info.plist ./output
plutil -convert xml1 ./output/Info.plist
cp MASTestApp.xcarchive/Products/Applications/MASTestApp.app/MASTestApp ./output

rm -fr MASTestApp.xcarchive
rm DistributionSummary.plist Packaging.log

popd > /dev/null || exit