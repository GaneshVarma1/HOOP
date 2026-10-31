import SwiftUI

// MARK: - HOOP visual foundation
//
// These tokens describe the visual treatment used by HOOP's views. They deliberately
// contain no navigation, state, or domain semantics: screens keep their current hierarchy and data
// bindings, while cards, gauges, typography, and chrome share one maintainable source of truth.

public enum NoopVisualStyle {
    // Neutral, low-chroma surfaces sampled from the supplied dark-mode reference.
    // HOOP: monochrome surfaces (near-black / paper white) so the cool blue accent carries identity.
    public static let canvas = Color(light: "#F4F4F2", dark: "#0B0B0C")
    public static let surface = Color(light: "#FFFFFF", dark: "#161618")
    public static let surfaceTop = Color(light: "#FFFFFF", dark: "#1C1C1F")
    public static let surfaceBottom = Color(light: "#F7F7F5", dark: "#141416")
    public static let inset = Color(light: "#EBEBE8", dark: "#111113")

    public static let border = Color(light: "#DEDEDA", dark: "#2A2A2E")
    public static let borderHighlight = Color(light: "#FFFFFF", dark: "#3A3A40")
    public static let divider = Color(light: "#E6E6E2", dark: "#26262A")

    public static let primaryText = Color(light: "#0A0A0A", dark: "#F2F2EF")
    public static let secondaryText = Color(light: "#4F4F4A", dark: "#B9B9B4")
    public static let tertiaryText = Color(light: "#6B6B66", dark: "#8C8C87")

    // HOOP cool blue. The `mint` names are kept so stored accent choices and every existing call
    // site keep working; only the values changed. Light shades keep 4.5:1 on white.
    public static let mint = Color(light: "#2257D6", dark: "#7AA7FF")
    public static let mintDeep = Color(light: "#1A45AD", dark: "#3D74E0")
    public static let mintGlow = Color(light: "#5B8CFF", dark: "#9DBDFF")

    // HOOP logo colours: the mark's ink and the tile it sits on, for both appearances.
    public static let brandInk = Color(light: "#0A0A0A", dark: "#F2F2EF")
    public static let brandTile = Color(light: "#FFFFFF", dark: "#151515")

    public static let cardRadius: CGFloat = 22
    public static let compactRadius: CGFloat = 16
    public static let pillRadius: CGFloat = 999
    public static let pagePadding: CGFloat = 16
    public static let cardPadding: CGFloat = 16
    public static let itemGap: CGFloat = 12
    public static let sectionGap: CGFloat = 26
}

/// Shared card/panel treatment: a solid surface on iOS, gradient and soft elevation elsewhere.
/// `tint` is intentionally faint so metric identity never turns the whole card into a coloured tile.
public struct NoopPanelSurface: View {
    public var tint: Color?
    public var cornerRadius: CGFloat
    public var elevated: Bool
    public var surfaceOpacity: Double
    #if !os(iOS)
    @Environment(\.colorScheme) private var scheme
    #endif

    public init(
        tint: Color? = nil,
        cornerRadius: CGFloat = NoopVisualStyle.cardRadius,
        elevated: Bool = false,
        surfaceOpacity: Double = 1
    ) {
        self.tint = tint
        self.cornerRadius = cornerRadius
        self.elevated = elevated
        self.surfaceOpacity = surfaceOpacity
    }

    public var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        #if os(iOS)
        // Scrolling stacks contain many panels. Layered translucent gradients and blurred shadows
        // multiply their compositing work, so iOS uses one theme-aware fill and a thin tinted rim.
        // This changes decorative depth only; card geometry and the design-system colors stay the same.
        shape
            .fill(NoopVisualStyle.surface)
            .overlay(shape.strokeBorder(
                tint?.opacity(0.14) ?? NoopVisualStyle.borderHighlight.opacity(elevated ? 0.9 : 0.65),
                lineWidth: 0.8
            ))
            .opacity(surfaceOpacity)
        #else
        shape
            .fill(
                LinearGradient(
                    colors: [NoopVisualStyle.surfaceTop, NoopVisualStyle.surfaceBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay {
                if let tint {
                    shape.fill(
                        LinearGradient(
                            colors: [tint.opacity(0.055), tint.opacity(0.012), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }
            }
            .overlay(
                shape.strokeBorder(
                    LinearGradient(
                        colors: [NoopVisualStyle.borderHighlight.opacity(0.72), NoopVisualStyle.border.opacity(0.52)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 0.8
                )
            )
            .shadow(
                color: scheme == .dark ? .black.opacity(elevated ? 0.34 : 0.18) : .black.opacity(0.10),
                radius: elevated ? 18 : 9,
                x: 0,
                y: elevated ? 10 : 5
            )
            .opacity(surfaceOpacity)
        #endif
    }
}

/// Shared edge-to-edge chrome for sheet and split-view headers. Unlike a card it has no
/// rounded outline or elevation, but it uses the same top-lit surface ramp and divider token.
public struct NoopChromeSurface: View {
    public init() {}

    public var body: some View {
        LinearGradient(
            colors: [NoopVisualStyle.surfaceTop, NoopVisualStyle.surfaceBottom],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(NoopVisualStyle.divider)
                .frame(height: 0.5)
        }
    }
}

public extension View {
    func noopPanel(
        tint: Color? = nil,
        cornerRadius: CGFloat = NoopVisualStyle.cardRadius,
        elevated: Bool = false,
        surfaceOpacity: Double = 1
    ) -> some View {
        background {
            NoopPanelSurface(
                tint: tint,
                cornerRadius: cornerRadius,
                elevated: elevated,
                surfaceOpacity: surfaceOpacity
            )
        }
    }
}
