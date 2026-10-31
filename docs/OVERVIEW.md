# HOOP overview

HOOP is an independent companion for compatible WHOOP straps. It connects over Bluetooth, stores data locally, and computes recovery, effort, rest, heart rate, HRV and sleep views on your device. It is not affiliated with WHOOP, Inc. and is not a medical device.

## What you can do

- Pair a WHOOP 4.0 or 5.0/MG strap and view live heart rate.
- Review daily scores, sleep, workouts and trends. Some WHOOP 5.0/MG history and deeper metrics are experimental.
- Import supported health exports and export your own records.
- Use optional Apple Health or Android Health Connect features with permission.
- See a clear Bluetooth-off notice with steps to reconnect your strap.

HOOP works offline by default. Optional integrations are documented in [Privacy and security](PRIVACY_SECURITY.md).

## Platforms

| Platform | How to build |
| --- | --- |
| iPhone | Follow the [iOS guide](IOS.md) and build with Xcode. |
| Mac | Follow the [build guide](BUILD.md). |
| Android | Follow the [Android guide](ANDROID.md), or run `cd android && ./gradlew assembleFullDebug`. |

There is no published HOOP binary in this repository yet. The [AltStore source](../altstore-source.json) does not list a downloadable app until a HOOP release is available.

## How it works

- `Packages/WhoopProtocol` decodes strap messages.
- `Packages/WhoopStore` persists local records in SQLite.
- `Packages/StrandAnalytics` computes on-device metrics.
- `Packages/StrandImport` imports supported exports.
- `Packages/StrandDesign` provides the Apple design components.
- `Strand/`, `StrandiOS/`, and `android/` contain the app interfaces.

The [architecture guide](ARCHITECTURE.md) and [protocol notes](PROTOCOL.md) provide more detail. The [scope guide](SCOPE.md) explains supported and experimental behavior.

## Source, license and safety

The original source and third-party contributions are credited in [LICENSE](../LICENSE), [NOTICE](../NOTICE) and [ATTRIBUTION.md](../ATTRIBUTION.md). HOOP modifications are Copyright 2026 Sri Ganesh Shiramshetty. The source is available for non-commercial use under the [PolyForm Noncommercial License 1.0.0](../LICENSE).

Read the [disclaimer](../DISCLAIMER.md) before using the app for health insights. Measurements and scores are estimates and should not guide medical decisions.
