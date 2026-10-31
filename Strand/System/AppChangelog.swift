import Foundation

/// Single source of truth for the in-app "What's New" screen and the expectation-setting copy used
/// in onboarding. The Android app carries the same HOOP baseline notes.
enum AppChangelog {

    /// Bump this when you add a release below. The "What's New" sheet shows automatically when the
    /// stored last-seen version is behind this. (Decoupled from the bundle version on purpose.)
    static let currentVersion = "12.0.0"

    struct Release: Identifiable {
        let version: String
        let title: String
        let date: String
        let items: [String]
        var id: String { version }
    }

    /// HOOP release notes begin with this app's baseline.
    static let releases: [Release] = [
        Release(
            version: "12.0.0",
            title: "HOOP baseline",
            date: "October 2026",
            items: [
                "HOOP has its own name, icon and blue-accented interface across iPhone, Mac and Android.",
                "When Bluetooth is off, HOOP explains how to turn it on and reconnect your strap.",
                "Your strap data and computed scores stay on your device.",
            ]),
    ]

    struct Expectation: Identifiable {
        let icon: String      // SF Symbol
        let title: String
        let body: String
        var id: String { title }
    }

    static let expectations: [Expectation] = [
        Expectation(
            icon: "flask",
            title: String(localized: "Independent, and experimental"),
            body: String(localized: "HOOP is a personal, open project: not the WHOOP app, and not affiliated with WHOOP. It reads a strap you own, on your own device. Treat it as a capable work-in-progress rather than a finished product.")),
        Expectation(
            icon: "checkmark.seal",
            title: String(localized: "WHOOP 4.0 is the supported path"),
            body: String(localized: "WHOOP 4.0 is tested and works end to end. WHOOP 5.0/MG is newer: live heart rate works today, but deeper metrics (recovery, strain, sleep) for 5/MG are still being figured out. HOOP always tells you what's live versus still building.")),
        Expectation(
            icon: "hourglass",
            title: String(localized: "Your scores build over a few nights"),
            body: String(localized: "Live heart rate is instant. Recovery, strain and sleep sharpen as HOOP learns your baseline over your first nights of wear. Want your history now? Import your WHOOP export in Data Sources and it backfills in about a minute.")),
        Expectation(
            icon: "lock.shield",
            title: String(localized: "Everything stays on your device"),
            body: String(localized: "No account, no cloud, no sync. HOOP talks only to your strap and keeps everything local. Your data is yours alone.")),
    ]
}
