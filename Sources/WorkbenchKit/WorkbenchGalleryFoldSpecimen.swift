import SwiftUI

/// The claim that a fold's closed line can be a view: three ranked rows, one of them open.
///
/// Open and shut together on purpose — the question a fold specimen exists to answer is what
/// pressing it does to the block around it, and one row in each state is the only way to see both
/// at once.
///
/// Ruled between, never spaced: the kit's grammar divides rows with hairlines, and three folds
/// running together with nothing between them is the defect this vocabulary exists to remove.
public struct WorkbenchGalleryFoldSpecimen: View {
    public init() {}

    public var body: some View {
        WorkbenchBlock {
            WorkbenchBlockHeader(
                kicker: "K-1 · a fold's closed line is a view, not a string", title: "Ranked rows")
        } content: {
            VStack(alignment: .leading, spacing: 0) {
                WorkbenchGalleryRankedFold(
                    title: "Heap-based buffer over-read in inflate()",
                    readings: "critical · 1 place · fix available", tone: .alarm)
                Rectangle()
                    .fill(WorkbenchPalette.hairline.color)
                    .frame(height: WorkbenchMetrics.hairlineWidth)
                WorkbenchGalleryRankedFold(
                    title: "Arbitrary code execution via cross-site scripting",
                    readings: "high · 2 places · fix available", tone: .warning,
                    initiallyExpanded: true)
                Rectangle()
                    .fill(WorkbenchPalette.hairline.color)
                    .frame(height: WorkbenchMetrics.hairlineWidth)
                WorkbenchGalleryRankedFold(
                    title: "Image user should not be 'root'",
                    readings: "medium · 1 place", tone: .caution)
            }
        }
    }
}
