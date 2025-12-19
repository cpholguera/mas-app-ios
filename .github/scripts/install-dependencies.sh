#!/bin/bash

# Install dependencies for building and testing iOS app
# Usage: ./install-dependencies.sh

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

echo "Installing dependencies..."

# Install ldid for signing
brew install ldid || true
# Install cocoapods if needed
brew install cocoapods || true
# Install pods if Podfile exists
if [ -f Podfile ]; then
  echo "Installing CocoaPods dependencies..."
  pod install --repo-update || true
fi

echo "Dependencies installed successfully"

popd > /dev/null || exit

