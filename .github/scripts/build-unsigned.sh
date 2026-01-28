#!/bin/bash

# Build an unsigned archive of the app
# Usage: ./build-unsigned.sh

set -e

pushd "$(dirname "$0")/../.." > /dev/null || exit

# Copy CI config
cp .github/Local.xcconfig.ci Local.xcconfig

# Determine whether to build using a workspace or a project.
# Prefer a workspace if one exists; otherwise fall back to a project.
if compgen -G "*.xcworkspace" > /dev/null; then
  # Use the first workspace found in the current directory
  WORKSPACE_FILE=$(ls *.xcworkspace | head -n 1)
  PROJECT_SPECIFIER=(-workspace "$WORKSPACE_FILE")
elif compgen -G "*.xcodeproj" > /dev/null; then
  # Use the first project found in the current directory
  PROJECT_FILE=$(ls *.xcodeproj | head -n 1)
  PROJECT_SPECIFIER (-project "$PROJECT_FILE")
else
  # Fallback to the original hardcoded project name for backwards compatibility
  PROJECT_SPECIFIER=(-project "MASTestApp.xcodeproj")
fi

xcodebuild archive \
  "${PROJECT_SPECIFIER[@]}" \
  -scheme "MASTestApp" \
  -archivePath "build/MASTestApp.xcarchive" \
  -configuration Release \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

popd > /dev/null || exit
