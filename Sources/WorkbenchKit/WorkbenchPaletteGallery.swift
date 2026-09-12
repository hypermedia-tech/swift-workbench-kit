import SwiftUI

/// Every content-layer token and register, in one view, so the tuning pass is a build-and-look
/// rather than a hunt. Dev chrome: a consuming app wires it into a debug menu if it wants it.
///
/// Look at it in both appearances. The suite proves the arithmetic; only an eye can say whether a
/// dark ground reads as one product with its light twin.
public struct WorkbenchPaletteGallery: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: WorkbenchMetrics.blockSpacing) {
                WorkbenchGallerySection(title: "Fills", rows: [
                    WorkbenchGalleryEntry(name: "ground", token: WorkbenchPalette.ground),
                    WorkbenchGalleryEntry(name: "block", token: WorkbenchPalette.block),
                    WorkbenchGalleryEntry(name: "inset", token: WorkbenchPalette.inset),
                    WorkbenchGalleryEntry(name: "hoverTint", token: WorkbenchPalette.hoverTint),
                ], backdrop: WorkbenchPalette.block)

                WorkbenchGallerySection(title: "Lines", rows: [
                    WorkbenchGalleryEntry(name: "hairline", token: WorkbenchPalette.hairline),
                    WorkbenchGalleryEntry(name: "hairlineSoft", token: WorkbenchPalette.hairlineSoft),
                ], backdrop: WorkbenchPalette.block)

                WorkbenchGallerySection(title: "Text", rows: [
                    WorkbenchGalleryEntry(name: "textPrimary", token: WorkbenchPalette.textPrimary),
                    WorkbenchGalleryEntry(name: "textSecondary", token: WorkbenchPalette.textSecondary),
                    WorkbenchGalleryEntry(name: "textLabel", token: WorkbenchPalette.textLabel),
                    WorkbenchGalleryEntry(name: "action", token: WorkbenchPalette.action),
                ], backdrop: WorkbenchPalette.block)

                WorkbenchGallerySection(title: "Status on block", rows: Self.toneEntries,
                                        backdrop: WorkbenchPalette.block)

                WorkbenchGallerySection(title: "Status on inset", rows: Self.toneEntries,
                                        backdrop: WorkbenchPalette.inset)

                WorkbenchGalleryTypeSpecimen()

                WorkbenchGalleryBlockSpecimen()
            }
            .padding(WorkbenchMetrics.blockSpacing)
        }
        .background(WorkbenchPalette.ground.color)
    }

    /// The ramp does not change, so it is built once rather than on every pass through `body`.
    /// Filed under "Status on block" and "Status on inset" — so status tones only. `spotlight` is
    /// shown by `WorkbenchGalleryBlockSpecimen`, on a cell, which is the only place it belongs.
    private static let toneEntries: [WorkbenchGalleryEntry] = WorkbenchPalette.Tone.allCases
        .filter { $0 != .spotlight }
        .map { WorkbenchGalleryEntry(name: $0.rawValue, token: WorkbenchPalette.token(for: $0)) }
}

// Both appearances in one canvas, because the judgement a palette gallery exists to support is
// whether the pair reads as one product.
//
// `environment(\.colorScheme:)` and NOT `preferredColorScheme(_:)`. The latter asks a *window* to
// adopt an appearance; a preview canvas rendering a bare view, and `ImageRenderer`, have no window
// to ask, so a dynamic token resolves light in both halves and the dark preview quietly lies.
// Measured: with `preferredColorScheme(.dark)` the ground token renders `F6F7FA`; with
// `environment(\.colorScheme, .dark)` it renders `0A1020`.
#Preview("WorkbenchPaletteGallery — light beside dark") {
    HStack(spacing: 0) {
        WorkbenchPaletteGallery()
            .environment(\.colorScheme, .light)
        WorkbenchPaletteGallery()
            .environment(\.colorScheme, .dark)
    }
    .frame(width: 1120, height: 760)
}

#Preview("WorkbenchPaletteGallery — dark") {
    WorkbenchPaletteGallery()
        .environment(\.colorScheme, .dark)
        .frame(width: 560, height: 760)
}

#Preview("WorkbenchPaletteGallery — light") {
    WorkbenchPaletteGallery()
        .environment(\.colorScheme, .light)
        .frame(width: 560, height: 760)
}
