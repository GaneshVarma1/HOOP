import SwiftUI
import StrandDesign
#if os(iOS)
import UIKit
#endif

/// Shown on connection screens while the device's Bluetooth radio is off. A leaf view, so the
/// Bluetooth state can update without making an entire screen observe LiveState.
///
/// The card pairs a slow "searching" signal (rings breathing out from a Bluetooth-off glyph) with the
/// three steps that fix it. The rings only move when motion is allowed (Reduce Motion, Low Power,
/// Quiet Motion and an obscured window all hold them still), and the card disappears by itself the
/// moment the radio comes back on.
struct BluetoothOffNotice: View {
    @EnvironmentObject private var live: LiveState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openURL) private var openURL
    @ObservedObject private var motion = NoopMotionState.shared
    @State private var pulse = false

    private var poseStill: Bool { motion.poseStill(reduceMotion) }

    var body: some View {
        if live.bluetoothPoweredOff {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center, spacing: 16) {
                    signal
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bluetooth is off")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("HOOP can't reach your band until it's back on.")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                }

                VStack(alignment: .leading, spacing: 10) {
                    #if os(iOS)
                    step(1, "Swipe down from the top-right corner to open Control Center.")
                    step(2, "Tap the Bluetooth button so it turns blue.")
                    #else
                    step(1, "Open the Bluetooth settings on this Mac.")
                    step(2, "Turn Bluetooth on.")
                    #endif
                    step(3, "Keep your band nearby. HOOP reconnects by itself.")
                }

                Button(action: openBluetoothSettings) {
                    Label(settingsButtonTitle, systemImage: "gearshape")
                        .font(StrandFont.headline)
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .tint(StrandPalette.accent)
            }
            .padding(18)
            .background(NoopPanelSurface(tint: StrandPalette.accent, elevated: true))
            .accessibilityElement(children: .contain)
            .transition(.opacity.combined(with: .scale(scale: 0.97)))
            .onAppear { pulse = !poseStill }
            .onChange(of: poseStill) { still in pulse = !still }
        }
    }

    // MARK: Signal

    /// A Bluetooth-off glyph in an accent disc, with two rings breathing outward behind it.
    private var signal: some View {
        ZStack {
            ForEach(0..<2, id: \.self) { i in
                Circle()
                    .strokeBorder(StrandPalette.accent.opacity(0.55), lineWidth: 1.5)
                    .scaleEffect(pulse ? 1.55 : 1.0)
                    .opacity(pulse ? 0 : 0.8)
                    .animation(
                        pulse
                            ? .easeOut(duration: 2.4).repeatForever(autoreverses: false).delay(Double(i) * 1.2)
                            : .default,
                        value: pulse
                    )
            }
            Circle()
                .fill(StrandPalette.accentMuted)
            Circle()
                .strokeBorder(StrandPalette.accent.opacity(0.35), lineWidth: 1)
            Image(systemName: "bluetooth.slash")
                .font(StrandFont.title2)
                .foregroundStyle(StrandPalette.accent)
        }
        .frame(width: 56, height: 56)
        .accessibilityHidden(true)
    }

    // MARK: Steps

    private func step(_ number: Int, _ text: LocalizedStringKey) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(verbatim: "\(number)")
                .font(StrandFont.caption.weight(.bold))
                .foregroundStyle(StrandPalette.accent)
                .frame(width: 22, height: 22)
                .background(Circle().fill(StrandPalette.accentMuted))
                .accessibilityHidden(true)
            Text(text)
                .font(StrandFont.subhead)
                .foregroundStyle(StrandPalette.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Settings

    private var settingsButtonTitle: String {
        #if os(iOS)
        String(localized: "Open Settings")
        #else
        String(localized: "Open Bluetooth Settings")
        #endif
    }

    private func openBluetoothSettings() {
        #if os(iOS)
        // iOS has no public link to the Bluetooth page, so this opens Settings at the app's own page.
        if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
        #else
        if let url = URL(string: "x-apple.systempreferences:com.apple.BluetoothSettings") { openURL(url) }
        #endif
    }
}
