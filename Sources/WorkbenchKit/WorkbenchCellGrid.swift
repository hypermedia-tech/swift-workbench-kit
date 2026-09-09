import SwiftUI

/// A block's body as one instrument cluster: small cells divided by hairlines, no per-cell radius,
/// no per-cell shadow, no air between them.
///
/// The hairlines are the gaps. The grid's own background is the separator colour and every cell
/// paints the block fill over it, so a one-point gutter reads as a rule without a single divider
/// being placed. Nine readings become one thing to look at instead of nine things to hop between.
public struct WorkbenchCellGrid: View {
    private let cells: [WorkbenchCell]

    /// The minimum grows with the reader's text size. A fixed minimum means that at larger Dynamic
    /// Type the column count stays put while the text inside it does not, so the cluster crowds
    /// rather than dropping a column.
    @ScaledMetric private var minimumCellWidth: CGFloat = WorkbenchMetrics.cellMinWidth

    public init(_ cells: [WorkbenchCell]) {
        self.cells = cells
    }

    public var body: some View {
        WorkbenchCellGridLayout(
            minimumCellWidth: minimumCellWidth,
            spacing: WorkbenchMetrics.hairlineWidth
        ) {
            // Keyed by position: a cell's label is not unique (see `WorkbenchCell`).
            ForEach(cells.enumerated(), id: \.offset) { _, cell in
                WorkbenchCellView(cell)
            }
        }
        .background(WorkbenchPalette.hairlineSoft.color)
    }
}
