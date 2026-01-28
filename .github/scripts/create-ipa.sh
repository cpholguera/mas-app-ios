#!/bin/bash

# Create IPA from xcarchive
# Usage: ./create-ipa.sh [ipa_name]
# Example: ./create-ipa.sh "MyApp.ipa"

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

APP_NAME="${APP_NAME:-MASTestApp}"
IPA_NAME="${1:-$APP_NAME-unsigned.ipa}"

echo "Creating IPA from archive..."
echo "IPA name: $IPA_NAME"

cd "build/$APP_NAME.xcarchive/Products" || exit

# Create Payload directory
mv Applications Payload

# Create IPA
echo "Creating IPA archive..."
zip -r9q "$APP_NAME.zip" Payload
mv "$APP_NAME.zip" "$APP_NAME.ipa"

# Move to output directory
mkdir -p "output"
mv "$APP_NAME.ipa" "output/$IPA_NAME"

echo "IPA created successfully at: output/$IPA_NAME"

popd > /dev/null || exit

