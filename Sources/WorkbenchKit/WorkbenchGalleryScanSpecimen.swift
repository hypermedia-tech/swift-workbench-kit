import SwiftUI

/// A block of aligned fact rows with a fold beneath them — the shape the Reporter's scan block
/// takes in L-4. Rendered twice in the gallery, shut and open, because the fold's whole claim is
/// about what opening it does to the block around it.
public struct WorkbenchGalleryScanSpecimen: View {
    private let kicker: String
    private let initiallyExpanded: Bool

    public init(kicker: String, initiallyExpanded: Bool) {
        self.kicker = kicker
        self.initiallyExpanded = initiallyExpanded
    }

    private static let scanFacts: [WorkbenchFact] = [
        .init(label: "Vulnerability DB", value: "2026-09-08 12:00:04"),
        .init(label: "Java DB", value: "2026-09-01 04:11:20"),
        .init(label: "Schema", value: "2"),
    ]

    public var body: some View {
        WorkbenchBlock {
            WorkbenchBlockHeader(kicker: kicker, title: "Scan")
        } content: {
            VStack(alignment: .leading, spacing: 0) {
                WorkbenchFactRows(WorkbenchGallerySpecimenFacts.five)
                Rectangle()
                    .fill(WorkbenchPalette.hairline.color)
                    .frame(height: WorkbenchMetrics.hairlineWidth)
                WorkbenchBlockFold(title: "Scan facts", initiallyExpanded: initiallyExpanded) {
                    WorkbenchFactRows(Self.scanFacts)
                }
            }
        }
    }
}
