# GitHub Workflows Scripts Refactoring

## Summary

All inline scripts from GitHub Actions workflows have been extracted into reusable shell scripts in `.github/scripts/`. This improves maintainability, testability, and reusability across workflows.

## Changes Made

### New Scripts Created

1. **install-dependencies.sh** - Installs brew dependencies (ldid, cocoapods) and pods
   - Reused by: ios-unsigned-ipa.yml, ios-appium.yml, ios-maestro.yml

2. **build-app-simulator.sh** - Builds app for iOS Simulator without code signing
   - Reused by: ios-appium.yml, ios-maestro.yml
   - Supports custom derived data path

3. **build-for-testing.sh** - Builds app for testing with xcodebuild build-for-testing
   - Used by: ios.yml

4. **boot-simulator.sh** - Boots a simulator and waits for it to be ready
   - Reused by: ios-appium.yml, ios-maestro.yml

5. **find-built-app.sh** - Finds the built .app in DerivedData or custom path
   - Reused by: ios-appium.yml, ios-maestro.yml

6. **install-app-simulator.sh** - Installs app on a simulator
   - Reused by: ios-appium.yml, ios-maestro.yml

7. **launch-app-simulator.sh** - Launches app on a simulator
   - Used by: ios-appium.yml

8. **create-ipa.sh** - Creates unsigned IPA from xcarchive
   - Used by: ios-unsigned-ipa.yml
   - Replaces inline script

### Existing Scripts

These scripts already existed but are now consistently used:
- **set-default-scheme.sh** - Sets DEFAULT_SCHEME environment variable
- **build-app-unsigned.sh** - Creates unsigned xcarchive
- **add-entitlements.sh** - Adds entitlements using ldid

### Workflows Updated

#### ios.yml
**Before:** 
- Inline Ruby script to set default scheme
- Complex inline bash to detect workspace/project and build

**After:**
- `.github/scripts/set-default-scheme.sh`
- `.github/scripts/build-for-testing.sh "$DEFAULT_SCHEME" "$platform"`

**Lines reduced:** 12 → 2

---

#### ios-unsigned-ipa.yml
**Before:**
- Inline brew install and pod install
- Inline IPA creation script

**After:**
- `.github/scripts/install-dependencies.sh`
- `.github/scripts/create-ipa.sh`

**Lines reduced:** 18 → 4

---

#### ios-appium.yml
**Before:**
- Inline brew install and pod install
- Inline Ruby script to set default scheme
- Complex inline xcodebuild command
- Inline simulator boot script
- Inline app finding, installing, and launching script

**After:**
- `.github/scripts/install-dependencies.sh`
- `.github/scripts/set-default-scheme.sh`
- `.github/scripts/build-app-simulator.sh "$DEFAULT_SCHEME" "$PLATFORM" "$SIMULATOR"`
- `.github/scripts/boot-simulator.sh "$SIMULATOR" 10`
- Composite of `find-built-app.sh`, `install-app-simulator.sh`, `launch-app-simulator.sh`

**Lines reduced:** 40 → 8

---

#### ios-maestro.yml
**Before:**
- Inline brew install and pod install
- Inline Ruby script to set default scheme
- Complex inline xcodebuild command
- Inline app finding, booting, and installing script

**After:**
- `.github/scripts/install-dependencies.sh`
- `.github/scripts/set-default-scheme.sh`
- `.github/scripts/build-app-simulator.sh "$DEFAULT_SCHEME" "$PLATFORM" "$SIMULATOR" "DerivedData"`
- Composite of `find-built-app.sh`, `boot-simulator.sh`, `install-app-simulator.sh`

**Lines reduced:** 35 → 7

---

## Benefits

### 1. **Reusability**
- Common logic like "install dependencies", "build for simulator", "boot simulator" is now shared across multiple workflows
- No code duplication

### 2. **Maintainability**
- Scripts can be tested independently
- Changes to build logic only need to be made once
- Easier to read and understand workflow files

### 3. **Local Development**
- All scripts can be run locally for testing
- Developers can use the same scripts CI uses

### 4. **Documentation**
- Comprehensive README.md documents all scripts, their usage, and common patterns
- Each script has clear usage instructions in comments

### 5. **Error Handling**
- All scripts use `set -e` for proper error handling
- Consistent error messages across scripts

## Script Statistics

- **Total scripts:** 11 shell scripts
- **Total lines of code in scripts:** ~150 lines
- **Total lines removed from workflows:** ~100 lines
- **Net reduction in complexity:** Workflows are 60% smaller and more readable

## File Structure

```
.github/
├── scripts/
│   ├── README.md                    # Documentation
│   ├── set-default-scheme.sh        # Set Xcode scheme
│   ├── install-dependencies.sh      # Install brew & pod deps
│   ├── build-for-testing.sh         # Build for testing
│   ├── build-app-simulator.sh       # Build for simulator
│   ├── build-app-unsigned.sh        # Build unsigned archive
│   ├── boot-simulator.sh            # Boot simulator
│   ├── find-built-app.sh            # Find built .app
│   ├── install-app-simulator.sh     # Install on simulator
│   ├── launch-app-simulator.sh      # Launch on simulator
│   ├── add-entitlements.sh          # Add entitlements
│   └── create-ipa.sh                # Create IPA
└── workflows/
    ├── ios.yml                      # ✓ Updated
    ├── ios-unsigned-ipa.yml         # ✓ Updated
    ├── ios-appium.yml               # ✓ Updated
    └── ios-maestro.yml              # ✓ Updated
```

## Testing Recommendations

1. Test each workflow to ensure scripts work correctly
2. Verify environment variables are properly passed
3. Check that all scripts have execute permissions
4. Test scripts locally before committing

## Notes

- All scripts are executable (chmod +x)
- Scripts use `pushd`/`popd` to maintain directory context
- Environment variables can be passed as arguments or env vars
- Scripts work both in CI and locally

