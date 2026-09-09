import SwiftUI

/// A block's body as label-and-value rows, realised lazily, aligned by a fixed label column.
///
/// The twin of `WorkbenchFactRows`, and the choice between them is a real one. That view aligns by
/// putting every row in one `Grid`, so the value column starts after the widest label in the
/// block — the better alignment, and it builds every row to get it. This one keeps the rows lazy,
/// which is what a fold holding a package inventory needs: thousands of facts, of which a reader
/// sees twenty. A lazily-realised row cannot know how wide the widest label is, so it is given a
/// column instead, and labels wrap inside that column rather than truncating.
///
/// Alignment for a handful, laziness for thousands. Reach for `WorkbenchFactRows` by default and
/// for this one when the list is unbounded.
public struct WorkbenchLazyFactRows: View {
    private let facts: [WorkbenchFact]

    /// The column grows with the reader's text size, for the same reason `WorkbenchCellGrid`'s
    /// minimum does: a fixed column while the labels inside it grow is a column that crowds.
    @ScaledMetric private var labelWidth: CGFloat = WorkbenchMetrics.factLabelWidth

    public init(_ facts: [WorkbenchFact]) {
        self.facts = facts
    }

    public var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            // Keyed by position: a fact's label is not unique (see `WorkbenchFact`).
            ForEach(facts.enumerated(), id: \.offset) { index, fact in
                HStack(alignment: .firstTextBaseline, spacing: WorkbenchMetrics.blockHInset) {
                    Text(fact.label)
                        .labelRegister()
                        .frame(width: labelWidth, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(fact.value)
                        .font(WorkbenchTypography.value)
                        .foregroundStyle(colour(for: fact))
                        .textSelection(.enabled)
                    Spacer(minLength: 0)
                }
                .padding(.vertical, WorkbenchMetrics.blockRowVInset)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(WorkbenchPalette.hairlineSoft.color)
                        .frame(height: WorkbenchMetrics.hairlineWidth)
                        .opacity(index == facts.count - 1 ? 0 : 1)
                }
            }
        }
        .padding(.horizontal, WorkbenchMetrics.blockHInset)
    }

    private func colour(for fact: WorkbenchFact) -> Color {
        guard let tone = fact.tone else { return WorkbenchPalette.textPrimary.color }
        return WorkbenchPalette.color(tone)
    }
}
