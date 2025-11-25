# MASTestApp for iOS

## Overview

**MASTestApp** is an iOS application written in Swift. Contributors can easily create and test new MASTG demos, ensuring that the static and dynamic analysis processes are properly documented and reproducible.

The app is intentionally simple, offering three essential files:

1. `ContentView.swift` - Contains the default UI, which should not be modified.
2. `Info.plist` - Contains placeholders for additional things that may be needed.
3. `MastgTest.swift` - Contains one function. This file is intended to be modified by users to create new MASTG demos but should not be modified in the original repository.

Contributors must copy the final modified `MastgTest.swift` file to their demo folder in the OWASP MASTG repository under the corresponding `demos/ios/MASVS-XXXXX/MASTG-DEMO-XXXX/ folder`.

## Instructions

### Create a New Demo in the MASTG

Create a new folder in the MASTG repository under the corresponding `demos/MASTG-DEMO-XXXX` following the [guidelines](https://docs.google.com/document/d/1EMsVdfrDBAu0gmjWAUEs60q-fWaOmDB5oecY9d9pOlg/edit#heading=h.y294y561hx14)

### Clone the MASTestApp Repository

Clone the app repository and open it in Xcode.

```sh
git clone https://github.com/cpholguera/MASTestApp-iOS.git
```

### Add Your Demo Code

- Edit `MastgTest.swift` to implement your demo.
- If applicable, modify the `Info.plist` to add necessary permissions or components.
- Build the app and **test it** on the iOS simulator or a physical device.

### Run the Extraction Script

Run the provided script:

```sh
./tools/extract-code-for-mastg-demo.sh
```

The output will be:

```sh
output/
├── MASTestApp
├── Info.plist
└── MASTestApp.ipa
```

### If Your Demo Requires Static Analysis (Reverse Engineering)

Run your reverse-engineering scripts on the compiled app (IPA) and ensure everything works as expected.

### If Your Demo Requires Dynamic Analysis

Use the iOS simulator or a physical device and run your dynamic scripts.

## Finalize Your Demo

Once everything works fine, copy the relevant files from the output folder to the demo folder in the MASTG repository. It should look like this:

```sh
owasp-mastg/demos/MASTG-DEMO-XXXX/
├── MastgTest.swift
├── Info.plist
├── MASTG-DEMO-XXXX.md
├── MASTestApp
├── output.txt
└── run.sh
```

Finalize your demo by adding a `MASTG-DEMO-XXXX.md` file, tweaking the `run.sh` script, and adding the relevant output files.
