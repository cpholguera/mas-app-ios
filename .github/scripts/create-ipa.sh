#!/bin/bash

# Create IPA from xcarchive
# Usage: ./create-ipa.sh [ipa_name] [app_name]
# Example: ./create-ipa.sh "MyApp-unsigned.ipa" "MyApp"
#
# Arguments:
#   ipa_name  - Name of the output IPA file (default: <app_name>-unsigned.ipa)
#   app_name  - Name of the app/scheme (default: MASTestApp)

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit
REPO_ROOT="$(pwd)"

APP_NAME="${2:-MASTestApp}"
IPA_NAME="${1:-$APP_NAME-unsigned.ipa}"

echo "Creating IPA from archive..."
echo "App name: $APP_NAME"
echo "IPA name: $IPA_NAME"

cd "build/$APP_NAME.xcarchive/Products" || exit

# Create Payload directory
if [ -d "Applications" ]; then
  mv Applications Payload
fi

# Create IPA
echo "Creating IPA archive..."
zip -r9q "$APP_NAME.zip" Payload
mv "$APP_NAME.zip" "$APP_NAME.ipa"

# Move to output directory at repo root
mkdir -p "$REPO_ROOT/output"
mv "$APP_NAME.ipa" "$REPO_ROOT/output/$IPA_NAME"

echo "IPA created successfully at: output/$IPA_NAME"

popd > /dev/null || exit

