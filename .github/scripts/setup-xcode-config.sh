#!/bin/bash

# Setup Xcode configuration for CI builds
# Usage: ./setup-xcode-config.sh

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

echo "Setting up Xcode configuration for CI..."
cp .github/Local.xcconfig.ci Local.xcconfig
echo "Local.xcconfig copied successfully"

popd > /dev/null || exit

