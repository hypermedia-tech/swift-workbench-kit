import SwiftUI

/// The choice between `WorkbenchFactRows` and `WorkbenchLazyFactRows`, made visible: the same five
/// facts drawn both ways, measured column above and fixed column below.
///
/// It is here because the difference is the kind of thing a paragraph cannot settle. One block,
/// two mechanisms, and the gap between where the values start is the whole argument.
public struct WorkbenchGalleryAlignmentSpecimen: View {
    public init() {}

    public var body: some View {
        WorkbenchBlock {
            WorkbenchBlockHeader(
                kicker: "K-1 · measured column above, fixed column below, same facts",
                title: "Two alignments")
        } content: {
            VStack(alignment: .leading, spacing: 0) {
                WorkbenchFactRows(WorkbenchGallerySpecimenFacts.five)
                Rectangle()
                    .fill(WorkbenchPalette.hairline.color)
                    .frame(height: WorkbenchMetrics.hairlineWidth)
                WorkbenchLazyFactRows(WorkbenchGallerySpecimenFacts.five)
            }
        }
    }
}
