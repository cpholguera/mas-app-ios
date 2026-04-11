#!/bin/bash

# Shared utilities for CI build scripts
# Source this file from other scripts: source "$(dirname "$0")/common.sh"

# Detect whether the repo uses an xcworkspace or xcodeproj.
# Sets: FILETYPE_PARAMETER, FILE_TO_BUILD
detect_xcode_project() {
  local match
  for match in *.xcworkspace; do
    if [ -e "$match" ]; then
      FILETYPE_PARAMETER="workspace"
      FILE_TO_BUILD="$match"
      echo "Building $FILETYPE_PARAMETER: $FILE_TO_BUILD"
      return
    fi
  done

  for match in *.xcodeproj; do
    if [ -e "$match" ]; then
      FILETYPE_PARAMETER="project"
      FILE_TO_BUILD="$match"
      echo "Building $FILETYPE_PARAMETER: $FILE_TO_BUILD"
      return
    fi
  done

  echo "Error: No .xcworkspace or .xcodeproj found in $(pwd)" >&2
  return 1
}

# Determine the Xcode scheme to build.
# Uses $1 if provided, otherwise auto-detects from the project, falling back to MASTestApp.
# Requires: FILETYPE_PARAMETER, FILE_TO_BUILD (call detect_xcode_project first)
# Sets: APP_NAME
detect_scheme() {
  local scheme_arg="$1"
  local xcodebuild_output

  if [ -n "$scheme_arg" ]; then
    APP_NAME="$scheme_arg"
  else
    if ! xcodebuild_output=$(xcodebuild -list -"$FILETYPE_PARAMETER" "$FILE_TO_BUILD" 2>&1); then
      echo "Error: Failed to list schemes from $FILE_TO_BUILD" >&2
      echo "$xcodebuild_output" >&2
      return 1
    fi

    APP_NAME=$(printf '%s\n' "$xcodebuild_output" | \
      awk '/Schemes:/{flag=1;next} /^$/{flag=0} flag' | head -n 1 | awk '{$1=$1;print}')
    if [ -z "$APP_NAME" ]; then
      APP_NAME="MASTestApp"
    fi
  fi

  echo "Scheme: $APP_NAME"
}

# Copy the CI-specific xcconfig into place.
copy_ci_config() {
  cp .github/Local.xcconfig.ci Local.xcconfig
}