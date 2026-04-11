#!/bin/bash

# Build an unsigned archive, apply entitlements, and package as an IPA.
# Usage: ./build-and-package.sh [ipa_name] [extra-entitlements.plist]
#
# Arguments:
#   ipa_name                  - Name of the output IPA file (default: <app_name>-unsigned.ipa)
#   extra-entitlements.plist  - Optional plist to merge with the default entitlements.plist

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
pushd "$SCRIPT_DIR/../.." > /dev/null || exit
source "$SCRIPT_DIR/common.sh"
REPO_ROOT="$(pwd)"

IPA_NAME="$1"
EXTRA_PLIST="$2"
MERGED_PLIST=""

cleanup() {
  if [[ -n "${MERGED_PLIST:-}" && -f "$MERGED_PLIST" ]]; then
    rm -f "$MERGED_PLIST"
  fi
}

trap cleanup EXIT

if [[ -n "$IPA_NAME" && "$IPA_NAME" != *.ipa ]]; then
  echo "Error: ipa_name must end with .ipa (got: $IPA_NAME)" >&2
  exit 1
fi

# --- Detect project and scheme ---
detect_xcode_project
detect_scheme
copy_ci_config

IPA_NAME="${IPA_NAME:-$APP_NAME-unsigned.ipa}"

xcodebuild archive \
  -scheme "$APP_NAME" \
  -"$FILETYPE_PARAMETER" "$FILE_TO_BUILD" \
  -archivePath "build/$APP_NAME.xcarchive" \
  -configuration Release \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

# --- Apply entitlements ---
BASE_PLIST="entitlements.plist"
TARGET_PLIST="$BASE_PLIST"

if [ -n "$EXTRA_PLIST" ]; then
  MERGED_PLIST=$(mktemp "${TMPDIR:-/tmp}/entitlements.XXXXXX")
  cp "$EXTRA_PLIST" "$MERGED_PLIST"
  /usr/libexec/PlistBuddy -c "Merge $BASE_PLIST" "$MERGED_PLIST"
  TARGET_PLIST="$MERGED_PLIST"
fi

ldid -S"${TARGET_PLIST}" "build/${APP_NAME}.xcarchive/Products/Applications/${APP_NAME}.app/${APP_NAME}"

# --- Package as IPA ---
echo "Creating IPA from archive..."

cd "build/$APP_NAME.xcarchive/Products" || exit

if [ -d "Applications" ]; then
  mv Applications Payload
fi

zip -r9q "$APP_NAME.zip" Payload
mv "$APP_NAME.zip" "$APP_NAME.ipa"

mkdir -p "$REPO_ROOT/output"
mv "$APP_NAME.ipa" "$REPO_ROOT/output/$IPA_NAME"

echo "IPA created successfully at: output/$IPA_NAME"

popd > /dev/null || exit
