import SwiftUI

/// One token in the gallery: its name in the label register, the colour drawn on the fill it is
/// checked against, the hex it resolves to in the current appearance, and the measured ratio.
///
/// The number is the point of the row. A palette tuned by eye alone drifts below the floor without
/// anyone noticing; a palette that shows its arithmetic while you tune it does not.
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
            Text(token.value(for: scheme).hexDescription)
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

    private var ratioText: String {
        let ratio = WorkbenchContrast.ratio(
            token.value(for: scheme), backdrop.value(for: scheme))
        return String(format: "%.2f", ratio)
    }
}
