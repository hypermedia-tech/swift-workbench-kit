import SwiftUI

/// One ranked row as a fold's closed line, with facts behind it. The unit
/// `WorkbenchGalleryFoldSpecimen` repeats, so the specimen's body stays a list of three things
/// rather than three copies of the same construction.
struct WorkbenchGalleryRankedFold: View {
    let title: String
    let readings: String
    let tone: WorkbenchPalette.Tone
    var initiallyExpanded: Bool = false

    var body: some View {
        WorkbenchBlockFold(initiallyExpanded: initiallyExpanded) {
            WorkbenchGalleryIssueRow(title: title, readings: readings, tone: tone)
        } content: {
            WorkbenchLazyFactRows(WorkbenchGallerySpecimenFacts.five)
        }
    }
}
