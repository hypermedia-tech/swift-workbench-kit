import SwiftUI

/// Places a cell grid: one column count for the whole grid, one height for every row, and a final
/// row whose cells share the full width so the block never ends in a dead gutter.
///
/// A `Layout` rather than a `LazyVGrid` because three of those properties are unreachable from the
/// grid APIs. `.adaptive(minimum:)` picks its own column count and will happily leave an orphan
/// row; nothing there can be asked how many columns it chose, so nothing can complete the last
/// row; and a grid row sizes to its tallest cell while the *other* cells keep their own heights,
/// which is what makes one two-line label push a single tile taller than its neighbours.
struct WorkbenchCellGridLayout: Layout {
    let minimumCellWidth: CGFloat
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = resolvedWidth(proposal)
        let plan = plan(width: width, subviews: subviews)
        return CGSize(width: width, height: plan.height)
    }

    func placeSubviews(
        in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
    ) {
        guard subviews.isEmpty == false else { return }
        let plan = plan(width: bounds.width, subviews: subviews)
        let rows = Int((Double(subviews.count) / Double(plan.columns)).rounded(.up))

        for index in subviews.indices {
            let row = index / plan.columns
            let column = index % plan.columns
            // The final row shares the full width between however many cells it has, so an
            // incomplete row stretches instead of leaving a tail of separator colour.
            let inLastRow = row == rows - 1
            let countInRow = inLastRow ? subviews.count - row * plan.columns : plan.columns
            let width = WorkbenchCellGridMath.cellWidth(
                availableWidth: bounds.width, columns: countInRow, spacing: spacing)
            let x = bounds.minX + (width + spacing) * CGFloat(column)
            let y = bounds.minY + (plan.rowHeight + spacing) * CGFloat(row)
            subviews[index].place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(width: width, height: plan.rowHeight))
        }
    }

    private func resolvedWidth(_ proposal: ProposedViewSize) -> CGFloat {
        guard let width = proposal.width, width.isFinite, width > 0 else { return minimumCellWidth }
        return width
    }

    private func plan(width: CGFloat, subviews: Subviews) -> (columns: Int, rowHeight: CGFloat, height: CGFloat) {
        guard subviews.isEmpty == false else { return (1, 0, 0) }
        let columns = WorkbenchCellGridMath.columns(
            forCount: subviews.count, availableWidth: width,
            minimumCellWidth: minimumCellWidth, spacing: spacing)
        let cellWidth = WorkbenchCellGridMath.cellWidth(
            availableWidth: width, columns: columns, spacing: spacing)
        // One height for the whole grid, measured at the width every cell will actually get.
        let rowHeight = subviews
            .map { $0.sizeThatFits(ProposedViewSize(width: cellWidth, height: nil)).height }
            .max() ?? 0
        let rows = Int((Double(subviews.count) / Double(columns)).rounded(.up))
        let height = CGFloat(rows) * rowHeight + CGFloat(max(0, rows - 1)) * spacing
        return (columns, rowHeight, height)
    }
}
