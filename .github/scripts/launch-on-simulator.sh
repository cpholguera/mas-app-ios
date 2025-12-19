#!/bin/bash

# Launch app on iOS Simulator
# Usage: ./launch-app-simulator.sh [bundle_identifier] [simulator_name]
# Example: ./launch-app-simulator.sh "org.owasp.mastestapp.MASTestApp-iOS" "iPhone 17"

set -e

BUNDLE_IDENTIFIER="${1:-${BUNDLE_IDENTIFIER}}"
SIMULATOR="${2:-${SIMULATOR:-iPhone 17}}"

if [ -z "$BUNDLE_IDENTIFIER" ]; then
  echo "Error: BUNDLE_IDENTIFIER is required as first argument or environment variable"
  exit 1
fi

echo "Launching app on simulator: $SIMULATOR"
echo "Bundle identifier: $BUNDLE_IDENTIFIER"

xcrun simctl launch "$SIMULATOR" "$BUNDLE_IDENTIFIER"

echo "App launched successfully"

