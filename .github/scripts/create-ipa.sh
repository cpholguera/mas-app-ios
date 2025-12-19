#!/bin/bash

# Create IPA from xcarchive
# Usage: ./create-ipa.sh [ipa_name]
# Example: ./create-ipa.sh "MyApp.ipa"

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

IPA_NAME="${1:-MASTestApp-unsigned.ipa}"

echo "Creating IPA from archive..."
echo "IPA name: $IPA_NAME"

cd "build/MASTestApp.xcarchive/Products" || exit

# Create Payload directory
mv Applications Payload

# Create IPA
echo "Creating IPA archive..."
zip -r9q MASTestApp.zip Payload
mv MASTestApp.zip MASTestApp.ipa

# Move to output directory
mkdir -p "output"
mv MASTestApp.ipa "output/$IPA_NAME"

echo "IPA created successfully at: output/$IPA_NAME"

popd > /dev/null || exit

