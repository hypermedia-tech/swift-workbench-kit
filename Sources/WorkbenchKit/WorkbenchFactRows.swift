import SwiftUI

/// A block's body as label-and-value rows whose value column aligns down the whole block.
///
/// A `Grid`, not a stack of rows: rows laid out independently each choose their own label width,
/// so the values start at a different x on every line and the block reads as typeset by accident.
/// One grid means one label column, and the alignment is a property of the block rather than a
/// coincidence between its rows.
public struct WorkbenchFactRows: View {
    private let facts: [WorkbenchFact]

    public init(_ facts: [WorkbenchFact]) {
        self.facts = facts
    }

    public var body: some View {
        Grid(alignment: .leadingFirstTextBaseline,
             horizontalSpacing: WorkbenchMetrics.blockHInset,
             verticalSpacing: 0) {
            ForEach(facts.enumerated(), id: \.element.id) { index, fact in
                GridRow {
                    Text(fact.label)
                        .labelRegister()
                        .gridColumnAlignment(.leading)
                    Text(fact.value)
                        .font(WorkbenchTypography.value)
                        .foregroundStyle(colour(for: fact))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, WorkbenchMetrics.blockRowVInset)

                // Always emitted, so every row keeps one structural identity; the last one is
                // given no height rather than being branched away.
                Rectangle()
                    .fill(WorkbenchPalette.hairlineSoft.color)
                    .frame(height: index == facts.count - 1 ? 0 : WorkbenchMetrics.hairlineWidth)
                    .gridCellColumns(2)
            }
        }
        .padding(.horizontal, WorkbenchMetrics.blockHInset)
    }

    private func colour(for fact: WorkbenchFact) -> Color {
        guard let tone = fact.tone else { return WorkbenchPalette.textPrimary.color }
        return WorkbenchPalette.color(tone)
    }
}
