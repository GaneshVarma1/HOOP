import SwiftUI

// MARK: - BrandMark — the HOOP logo mark
//
// The app's identity glyph, rendered natively for onboarding, "about" and empty states:
// a rounded square tile holding a solid block with the H cut out of it as negative space
// (a notch from the top and one from the bottom). It matches the app icon and the logo files
// in docs/assets/hoop. Flat by design: no glow or shadow. Everything scales off one `size`,
// so the mark stays crisp from a 28pt list avatar up to a 120pt hero.
public struct BrandMark: View {
    /// Edge length of the square mark; everything scales from this.
    public var size: CGFloat
    public init(size: CGFloat = 120) {
        self.size = size
    }

    // Proportions on the logo's 200-unit grid: tile radius 44, block 92 with radius 12,
    // notches 24 wide by 36 tall.
    private var unit: CGFloat { size / 200 }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 44 * unit, style: .continuous)
                .fill(NoopVisualStyle.brandTile)
                .overlay(
                    RoundedRectangle(cornerRadius: 44 * unit, style: .continuous)
                        .strokeBorder(StrandPalette.hairline, lineWidth: max(1, size * 0.008))
                )
            HoopGlyph()
                .fill(NoopVisualStyle.brandInk, style: FillStyle(eoFill: true))
                .frame(width: 92 * unit, height: 92 * unit)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("HOOP"))
        .accessibilityAddTraits(.isImage)
    }
}

/// The H glyph on its own: a rounded block minus a top and a bottom notch, filled even-odd.
/// Usable bare (no tile) wherever the wordmark needs a small inline mark.
public struct HoopGlyph: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 92
        let origin = CGPoint(x: rect.midX - 46 * s, y: rect.midY - 46 * s)
        var p = Path()
        p.addRoundedRect(
            in: CGRect(x: origin.x, y: origin.y, width: 92 * s, height: 92 * s),
            cornerSize: CGSize(width: 12 * s, height: 12 * s),
            style: .continuous
        )
        p.addRect(CGRect(x: origin.x + 34 * s, y: origin.y, width: 24 * s, height: 36 * s))
        p.addRect(CGRect(x: origin.x + 34 * s, y: origin.y + 56 * s, width: 24 * s, height: 36 * s))
        return p
    }
}

#if DEBUG
#Preview("BrandMark — sizes") {
    VStack(spacing: 40) {
        BrandMark(size: 120)
        HStack(spacing: 28) {
            BrandMark(size: 72)
            BrandMark(size: 44)
            BrandMark(size: 28)
        }
    }
    .padding(48)
    .frame(width: 420, height: 460)
    .background(StrandPalette.surfaceBase)
    .preferredColorScheme(.dark)
}
#endif
