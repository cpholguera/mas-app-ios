# GitHub Actions Scripts

This directory contains reusable shell scripts for building, testing, and packaging the iOS app. These scripts are used by various GitHub Actions workflows and can also be run locally.

## Available Scripts

### Core Build Scripts

#### `set-default-scheme.sh`
Sets the default Xcode scheme from the project and exports it to `$GITHUB_ENV`.

**Usage:**
```bash
./set-default-scheme.sh
```

**Environment Variables Set:**
- `DEFAULT_SCHEME` - The first target from the Xcode project

---

#### `build-for-testing.sh`
Builds the app for testing using any available iPhone simulator.

**Usage:**
```bash
./build-for-testing.sh [scheme] [platform]
```

**Arguments:**
- `scheme` (optional) - Xcode scheme to build. Defaults to `$DEFAULT_SCHEME`
- `platform` (optional) - Target platform. Defaults to "iOS Simulator"

**Example:**
```bash
./build-for-testing.sh "MASTestApp" "iOS Simulator"
```

---

#### `build-app-simulator.sh`
Builds the app for iOS Simulator without code signing.

**Usage:**
```bash
./build-app-simulator.sh [scheme] [platform] [simulator] [derived_data_path]
```

**Arguments:**
- `scheme` (optional) - Xcode scheme to build. Defaults to `$DEFAULT_SCHEME`
- `platform` (optional) - Target platform. Defaults to "iOS Simulator"
- `simulator` (optional) - Simulator device name. Defaults to "iPhone 17"
- `derived_data_path` (optional) - Custom derived data path

**Example:**
```bash
./build-app-simulator.sh "MASTestApp" "iOS Simulator" "iPhone 17" "DerivedData"
```

---

#### `build-app-unsigned.sh`
Creates an unsigned xcarchive of the app.

**Usage:**
```bash
./build-app-unsigned.sh
```

**Requirements:**
- `$DEFAULT_SCHEME` environment variable must be set

---

### Simulator Management Scripts

#### `boot-simulator.sh`
Boots an iOS Simulator and waits for it to be ready.

**Usage:**
```bash
./boot-simulator.sh [simulator_name] [wait_seconds]
```

**Arguments:**
- `simulator_name` (optional) - Name of simulator to boot. Defaults to `$SIMULATOR` or "iPhone 17"
- `wait_seconds` (optional) - Seconds to wait after booting. Defaults to 10

**Example:**
```bash
./boot-simulator.sh "iPhone 17" 10
```

---

#### `find-built-app.sh`
Finds the built .app file in DerivedData or a specified directory.

**Usage:**
```bash
./find-built-app.sh [search_path]
```

**Arguments:**
- `search_path` (optional) - Directory to search in. Defaults to `~/Library/Developer/Xcode/DerivedData`

**Returns:**
Prints the path to the found .app file to stdout

**Example:**
```bash
APP_PATH=$(./find-built-app.sh "DerivedData")
echo "Found app at: $APP_PATH"
```

---

#### `install-app-simulator.sh`
Installs an app on an iOS Simulator.

**Usage:**
```bash
./install-app-simulator.sh <app_path> [simulator_name]
```

**Arguments:**
- `app_path` (required) - Path to the .app bundle
- `simulator_name` (optional) - Name of simulator. Defaults to `$SIMULATOR` or "iPhone 17"

**Example:**
```bash
./install-app-simulator.sh "/path/to/App.app" "iPhone 17"
```

---

#### `launch-app-simulator.sh`
Launches an app on an iOS Simulator using its bundle identifier.

**Usage:**
```bash
./launch-app-simulator.sh [bundle_identifier] [simulator_name]
```

**Arguments:**
- `bundle_identifier` (optional) - App bundle identifier. Can also use `$BUNDLE_IDENTIFIER` env var
- `simulator_name` (optional) - Name of simulator. Defaults to `$SIMULATOR` or "iPhone 17"

**Example:**
```bash
./launch-app-simulator.sh "org.owasp.mastestapp.MASTestApp-iOS" "iPhone 17"
```

---

### Packaging Scripts

#### `add-entitlements.sh`
Adds entitlements to the built app using ldid.

**Usage:**
```bash
./add-entitlements.sh
```

**Requirements:**
- `ldid` must be installed
- `entitlements.plist` must exist in project root
- `$GITHUB_WORKSPACE` environment variable must be set

---

#### `create-ipa.sh`
Creates an unsigned IPA from an xcarchive.

**Usage:**
```bash
./create-ipa.sh [archive_path] [output_path]
```

**Arguments:**
- `archive_path` (optional) - Path to .xcarchive. Defaults to `$GITHUB_WORKSPACE/build/MASTestApp.xcarchive`
- `output_path` (optional) - Output directory for IPA. Defaults to `$GITHUB_WORKSPACE/output`

**Example:**
```bash
./create-ipa.sh "build/MASTestApp.xcarchive" "output"
```

---

### Dependency Management Scripts

#### `install-dependencies.sh`
Installs all required dependencies for building and testing.

**Usage:**
```bash
./install-dependencies.sh
```

**Installs:**
- ldid (for code signing)
- cocoapods (if not already installed)
- Pod dependencies (if Podfile exists)

---

## Common Workflow Patterns

### Building and Testing on Simulator

```bash
# 1. Set default scheme
./set-default-scheme.sh

# 2. Install dependencies
./install-dependencies.sh

# 3. Build for simulator (outputs to build/simulator/)
./build-for-simulator.sh "$DEFAULT_SCHEME" "iOS Simulator" "iPhone 17"

# 4. Boot simulator
./boot-simulator.sh "iPhone 17" 10

# 5. Install app (from known build location)
APP_PATH=$(find build/simulator/Build/Products/Debug-iphonesimulator -name "*.app" | head -n 1)
./install-on-simulator.sh "$APP_PATH" "iPhone 17"

# 6. Launch app
./launch-on-simulator.sh "org.owasp.mastestapp.MASTestApp-iOS" "iPhone 17"
```

### Creating Unsigned IPA

```bash
# 1. Set default scheme
./set-default-scheme.sh

# 2. Install dependencies
./install-dependencies.sh

# 3. Build unsigned archive
./build-for-unsigned.sh

# 4. Add entitlements
./add-entitlements.sh

# 5. Create IPA
./create-ipa.sh
```

## Environment Variables

Common environment variables used by these scripts:

- `DEFAULT_SCHEME` - The Xcode scheme to build
- `SIMULATOR` - The simulator device name to use
- `BUNDLE_IDENTIFIER` - The app's bundle identifier
- `PLATFORM` - The target platform (usually "iOS Simulator")
- `GITHUB_WORKSPACE` - GitHub Actions workspace directory
- `GITHUB_ENV` - GitHub Actions environment file

## Notes

- All scripts use `set -e` to exit on error
- Most scripts use `pushd`/`popd` to navigate to the project root
- Scripts are designed to work both in GitHub Actions and locally
- When running locally, some environment variables may need to be set manually

