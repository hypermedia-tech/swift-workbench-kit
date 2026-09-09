import SwiftUI

/// The blocking vocabulary demonstrating itself — and, deliberately, demonstrating the four
/// choices in it that only an eye can settle. Each block's kicker names the decision it is
/// evidence for, so the preview answers the story rather than merely looking nice.
public struct WorkbenchGalleryBlockSpecimen: View {
    public init() {}

    /// Nine readings: the head block's real shape, and the count that should choose three columns.
    /// Two of the labels wrap on purpose — that is the uniform-row-height claim under test.
    private static let nine: [WorkbenchCell] = [
        .init(value: "3", label: "Critical", tone: .alarm),
        .init(value: "11", label: "High", tone: .warning),
        .init(value: "24", label: "Medium", tone: .caution),
        .init(value: "6", label: "Low", tone: .notice),
        .init(value: "12 of 13", label: "Fixed", tone: .affirm),
        .init(value: "44", label: "Occurrences"),
        .init(value: "9", label: "Assets"),
        .init(value: "2", label: "Could not be checked"),
        .init(value: "1", label: "Distinct package@version"),
    ]

    /// Seven is prime, so no column count divides it and the last row has to stretch.
    private static let seven: [WorkbenchCell] = (1...7).map {
        WorkbenchCell(value: "\($0 * 3)", label: "Reading \($0)")
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: WorkbenchMetrics.blockSpacing) {
            WorkbenchBlock {
                WorkbenchBlockHeader(kicker: "Decisions 2 and 4 · nine cells, three columns, one row height",
                                     title: "At a glance")
            } content: {
                WorkbenchCellGrid(Self.nine)
            }

            WorkbenchBlock {
                WorkbenchBlockHeader(kicker: "Decision 3 · seven is prime, so the last row stretches",
                                     title: "Incomplete last row")
            } content: {
                WorkbenchCellGrid(Self.seven)
            }

            WorkbenchGalleryScanSpecimen(
                kicker: "Decisions 6 and 8 · one value column, fold shut", initiallyExpanded: false)

            WorkbenchGalleryScanSpecimen(
                kicker: "Decision 8 · the same fold, open, inside its own block", initiallyExpanded: true)

            WorkbenchGalleryFoldSpecimen()

            WorkbenchGalleryAlignmentSpecimen()
        }
    }
}
