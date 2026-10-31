<p align="center">
  <img src="docs/assets/hoop/hoop-logo-dark.png" alt="HOOP" width="96">
</p>

<h1 align="center">HOOP</h1>

<p align="center"><b>Your strap, your data, your phone. Free, offline, no subscription.</b></p>

HOOP is a free, on-device companion app for WHOOP 4.0 and 5.0/MG straps on iPhone, Mac and
Android. It pairs with the strap over Bluetooth, keeps everything in a local database on your
device, and works out recovery, strain, HRV and sleep itself, with no account and no cloud.

> **Not affiliated with WHOOP.** HOOP is an independent, unofficial app. "WHOOP" is used only to name
> the hardware it talks to. HOOP is **not a medical device**: every score is an estimate. See
> [DISCLAIMER.md](DISCLAIMER.md).

## What's different in HOOP

- HOOP name, logo, app icons and a monochrome + cool blue look across iPhone, Mac and Android
- A clearer Bluetooth-off screen that shows what's wrong and how to fix it
- Everything else (pairing, scores, sleep, trends, imports) is the upstream app's

## Build and run

- **iPhone:** see [docs/IOS.md](docs/IOS.md). Set your own `BUNDLE_ID_PREFIX` and team in
  `Config/BundleIdSecrets.xcconfig`, run `xcodegen generate`, then build the `NOOPiOS` scheme.
- **Mac:** see [docs/BUILD.md](docs/BUILD.md).
- **Android:** `cd android && ./gradlew assembleFullDebug`.

The full feature tour, architecture notes and privacy details are in
[docs/OVERVIEW.md](docs/OVERVIEW.md). Contributor rules are in [AGENTS.md](AGENTS.md).

## Credits and license

HOOP is based on [NOOP by NoopApp](https://github.com/ryanbr/noop). The original NOOP code remains
Copyright 2026 NoopApp, and HOOP's modifications are Copyright 2026 Sri Ganesh Shiramshetty.

The whole project is licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE): free to
use, change and share for **non-commercial** purposes only. Third-party components keep their own
licenses; see [NOTICE](NOTICE) and [ATTRIBUTION.md](ATTRIBUTION.md).
