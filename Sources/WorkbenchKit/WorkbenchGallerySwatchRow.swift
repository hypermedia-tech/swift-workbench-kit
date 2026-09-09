import SwiftUI

/// One token in the gallery: its name in the label register, the colour drawn on the fill it is
/// checked against, what it resolves to in the current appearance, and the measured ratio.
///
/// The numbers are the point of the row. A palette tuned by eye alone drifts below the floor
/// without anyone noticing; a palette that shows its arithmetic while you tune it does not — which
/// is also why a tint has to report the fill it produces rather than its own colour, a colour no
/// one ever sees at full strength.
public struct WorkbenchGallerySwatchRow: View {
    private let name: String
    private let token: WorkbenchColorToken
    private let backdrop: WorkbenchColorToken

    @Environment(\.colorScheme) private var scheme

    public init(name: String, token: WorkbenchColorToken, backdrop: WorkbenchColorToken) {
        self.name = name
        self.token = token
        self.backdrop = backdrop
    }

    public var body: some View {
        HStack(spacing: WorkbenchMetrics.blockHInset) {
            Text(name)
                .labelRegister()
                .frame(minWidth: 130, alignment: .leading)
            RoundedRectangle(cornerRadius: WorkbenchMetrics.insetCornerRadius)
                .fill(token.color)
                .frame(width: 44, height: 20)
                .overlay {
                    // Without an edge, a fill swatch drawn on its own fill reads as a missing
                    // swatch rather than as a match.
                    RoundedRectangle(cornerRadius: WorkbenchMetrics.insetCornerRadius)
                        .strokeBorder(WorkbenchPalette.hairline.color,
                                      lineWidth: WorkbenchMetrics.hairlineWidth)
                }
            Text(valueText)
                .font(WorkbenchTypography.value)
                .foregroundStyle(WorkbenchPalette.textSecondary.color)
            Spacer(minLength: 0)
            Text(ratioText)
                .font(WorkbenchTypography.value)
                .foregroundStyle(WorkbenchPalette.textLabel.color)
        }
        .padding(.horizontal, WorkbenchMetrics.blockHInset)
        .padding(.vertical, WorkbenchMetrics.blockRowVInset)
        .background(backdrop.color)
    }

    /// What the token resolves to here. An opaque token is its hex. A tint has no meaningful hex
    /// of its own — what matters is the fill it produces over this backdrop — so it reads as its
    /// own colour, the strength it is drawn at, and the result.
    private var valueText: String {
        let value = token.value(for: scheme)
        guard value.alpha < 1 else { return value.hexDescription }
        let composited = value.composited(over: backdrop.value(for: scheme))
        let percent = Int((value.alpha * 100).rounded())
        return "\(value.hexDescription) · \(percent)% → \(composited.hexDescription)"
    }

    /// Contrast against what is behind it. For a tint that is the composited result measured
    /// against the untinted fill — the lift a hover actually produces — because the tint's own
    /// colour is never seen at full strength and its ratio would be a number about nothing.
    private var ratioText: String {
        let value = token.value(for: scheme)
        let ground = backdrop.value(for: scheme)
        let front = value.alpha < 1 ? value.composited(over: ground) : value
        return String(format: "%.2f", WorkbenchContrast.ratio(front, ground))
    }
}
