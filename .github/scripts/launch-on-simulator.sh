#!/bin/bash

# Launch app on iOS Simulator
# Usage: ./launch-app-simulator.sh [simulator_name]
# Example: ./launch-app-simulator.sh "iPhone 17"

set -e

SIMULATOR="${1}"

echo "Launching app on simulator: $SIMULATOR"

xcrun simctl launch "$SIMULATOR" "org.owasp.mastestapp.MASTestApp-iOS"

echo "App launched successfully"

