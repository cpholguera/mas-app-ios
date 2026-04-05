## 📝 Script Inventory

```
build-and-install-on-simulator.sh  # Build for simulator, boot it, and install the app
build-and-package.sh               # Build unsigned, sign with ldid, and package as IPA
build-for-testing.sh               # Build for testing (XCTest/UI tests)
common.sh                          # Common build functions
```

## iOS Simulator

**1. List available simulators:**

```bash
xcrun simctl list devices available
```

**2. Build, boot simulator and install app:** (scripts auto-copy Local.xcconfig.ci, no manual config needed)

```bash
.github/scripts/build-and-install-on-simulator.sh "iPhone 17"
```

**3. Launch it:**

```bash
open -a Simulator
xcrun simctl launch booted org.owasp.mastestapp.MASTestApp-iOS
```

## Physical Device (requires Apple Developer account)

**1. Configure signing:**

```bash
cp Local.xcconfig.example Local.xcconfig
# Edit Local.xcconfig: set DEVELOPMENT_TEAM to your Apple Developer Team ID
```

There's no script for a signed device build — use Xcode directly (`Cmd+R` with your device selected).

## Physical Device (unsigned / jailbroken)

```bash
brew install ldid
.github/scripts/build-and-package.sh     # builds xcarchive, signs with ldid, packages as IPA → output/MASTestApp-unsigned.ipa
```

Optionally, pass a custom entitlements plist to merge with the default one:

```bash
.github/scripts/build-and-package.sh "" path/to/extra-entitlements.plist
```

Then sideload with `ideviceinstaller` or a tool like Sideloadly.
