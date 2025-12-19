#!/bin/bash

# Create IPA from xcarchive
# Usage: ./create-ipa.sh [archive_path] [output_path]
# Example: ./create-ipa.sh "build/MASTestApp.xcarchive" "output"

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

ARCHIVE_PATH="${1:-${GITHUB_WORKSPACE}/build/MASTestApp.xcarchive}"
OUTPUT_PATH="${2:-${GITHUB_WORKSPACE}/output}"

echo "Creating IPA from archive..."
echo "Archive path: $ARCHIVE_PATH"
echo "Output path: $OUTPUT_PATH"

cd "$ARCHIVE_PATH/Products" || exit

# Create Payload directory
mv Applications Payload

# Create IPA
echo "Creating IPA archive..."
zip -r9q MASTestApp.zip Payload
mv MASTestApp.zip MASTestApp.ipa

# Move to output directory
mkdir -p "$OUTPUT_PATH"
mv MASTestApp.ipa "$OUTPUT_PATH/MASTestApp-unsigned.ipa"

echo "IPA created successfully at: $OUTPUT_PATH/MASTestApp-unsigned.ipa"

popd > /dev/null || exit

