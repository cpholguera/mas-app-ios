#!/bin/bash

pushd "$(dirname "$0")/../.." > /dev/null || exit

default=$(xcodebuild -list -json | jq -r '.project.targets[0]')

echo "DEFAULT_SCHEME=$default" >> "$GITHUB_ENV"
echo "Using default scheme: $default"

popd > /dev/null || exit
