#!/bin/bash

# Boot an iOS Simulator
# Usage: ./boot-simulator.sh [simulator_name] [wait_seconds]
# Example: ./boot-simulator.sh "iPhone 17" 10

set -e

SIMULATOR="${1:-${SIMULATOR:-iPhone 17}}"
WAIT_SECONDS="${2:-10}"

echo "Booting simulator: $SIMULATOR"

# Boot the selected simulator if not already booted
xcrun simctl boot "$SIMULATOR" || echo "Simulator already booted"

# Allow time for the simulator to finish booting
echo "Waiting $WAIT_SECONDS seconds for simulator to boot..."
sleep "$WAIT_SECONDS"

echo "Simulator is ready"

