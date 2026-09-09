import CoreGraphics

/// Pure arithmetic for a cell grid's column count — the one piece of `WorkbenchCellGrid` that can
/// be reasoned about without drawing anything, so it is separated and tested like `SplitMath`.
///
/// The rule it encodes is a design decision, not a layout convenience: **a grid prefers a column
/// count that leaves no gap in its last row.** A grid of nine cells four-across reads as two rows
/// and an orphan with a dead gutter beside it; the same nine three-across reads as an instrument
/// cluster. So among the counts that fit, the widest one that divides the cells evenly wins, and
/// only if none divides evenly does the widest fitting count take it.
nonisolated public enum WorkbenchCellGridMath {

    /// Columns for `count` cells in `availableWidth`, honouring a minimum cell width.
    ///
    /// Always at least 1, never more than `count`. A width too small for even one cell still
    /// returns 1 — a cell narrower than its minimum is better than no grid.
    public static func columns(
        forCount count: Int,
        availableWidth: CGFloat,
        minimumCellWidth: CGFloat,
        spacing: CGFloat
    ) -> Int {
        guard count > 0 else { return 1 }
        let fitting = maximumColumns(
            availableWidth: availableWidth, minimumCellWidth: minimumCellWidth, spacing: spacing)
        let ceiling = min(fitting, count)
        guard ceiling > 1 else { return max(1, ceiling) }

        // The widest fitting count that leaves the last row full.
        for candidate in stride(from: ceiling, through: 2, by: -1) where count % candidate == 0 {
            return candidate
        }
        return ceiling
    }

    /// How many cells of at least `minimumCellWidth` fit across `availableWidth`, with `spacing`
    /// between them. At least 1.
    public static func maximumColumns(
        availableWidth: CGFloat,
        minimumCellWidth: CGFloat,
        spacing: CGFloat
    ) -> Int {
        guard minimumCellWidth > 0, availableWidth.isFinite, availableWidth > 0 else { return 1 }
        let stride = minimumCellWidth + spacing
        guard stride > 0 else { return 1 }
        return max(1, Int(((availableWidth + spacing) / stride).rounded(.down)))
    }

    /// Width of one cell once the columns and their gutters are taken out of the row.
    public static func cellWidth(
        availableWidth: CGFloat, columns: Int, spacing: CGFloat
    ) -> CGFloat {
        guard columns > 0 else { return availableWidth }
        let gutters = spacing * CGFloat(columns - 1)
        return max(0, (availableWidth - gutters) / CGFloat(columns))
    }
}
