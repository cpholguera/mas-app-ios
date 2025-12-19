#!/bin/bash

# Find the built .app file in DerivedData or build directory
# Usage: ./find-built-app.sh [search_path]
# Example: ./find-built-app.sh "DerivedData"
# Returns: Path to the .app file (stdout)

set -e

SEARCH_PATH="${1:-$HOME/Library/Developer/Xcode/DerivedData}"

echo "Searching for .app in: $SEARCH_PATH" >&2

APP_PATH=$(find "$SEARCH_PATH" -name "*.app" 2>/dev/null | head -n 1)

if [ -z "$APP_PATH" ]; then
  echo "Error: Could not find the built .app file in $SEARCH_PATH" >&2
  exit 1
fi

echo "Found app at: $APP_PATH" >&2
echo "$APP_PATH"

