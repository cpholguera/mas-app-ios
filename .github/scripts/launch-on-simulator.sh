#!/bin/bash

# Launch app on iOS Simulator
# Usage: ./launch-app-simulator.sh [simulator_name] [bundle_identifier]
# Example: ./launch-app-simulator.sh "iPhone 17" "org.owasp.mastestapp.MASTestApp-iOS"

set -e

SIMULATOR="${1}"
BUNDLE_ID="${2:-${BUNDLE_ID:-org.owasp.mastestapp.MASTestApp-iOS}}"

if [ -z "$SIMULATOR" ]; then
  echo "Error: No simulator specified." >&2
  echo "Usage: $0 \"simulator_name\"" >&2
  echo "Example: $0 \"iPhone 17\"" >&2
  exit 1
fi
echo "Launching app on simulator: $SIMULATOR"

xcrun simctl launch "$SIMULATOR" "$BUNDLE_ID"

echo "App launched successfully"

