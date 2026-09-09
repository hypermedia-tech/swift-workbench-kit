import SwiftUI

/// A ranked row for the gallery: a mark, what the thing is, and the readings that decide whether
/// it is worth opening. Internal — it exists so `WorkbenchGalleryFoldSpecimen` has a closed line
/// with real trailing content to prove the fold can carry one.
///
/// The words are the gallery's own. The kit knows no product's vocabulary, so a consumer writes
/// its own row and hands it over; this is only the specimen.
struct WorkbenchGalleryIssueRow: View {
    let title: String
    let readings: String
    let tone: WorkbenchPalette.Tone

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: WorkbenchMetrics.blockHInset) {
            WorkbenchStatusMark(tone)
                .alignmentGuide(.firstTextBaseline) { $0.height - 2 }
            Text(title)
                .font(WorkbenchTypography.blockTitle)
                .foregroundStyle(WorkbenchPalette.textPrimary.color)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: WorkbenchMetrics.blockHInset)
            Text(readings)
                // The register whole — condensed, uppercased, tracked — but not its colour: on
                // this row the rank IS the reading, so it overrides what the register sets.
                .labelRegister()
                .foregroundStyle(WorkbenchPalette.color(tone))
                .layoutPriority(1)
        }
    }
}
