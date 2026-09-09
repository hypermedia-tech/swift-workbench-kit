import CoreGraphics
import Testing
@testable import WorkbenchKit

/// The grid's column choice is a design rule expressed as arithmetic — prefer a count that leaves
/// no gap in the last row — so it is guarded here rather than judged by eye in a running app.
@Suite("WorkbenchCellGridMath")
struct WorkbenchCellGridMathTests {

    // A width that fits exactly four 120pt cells with 1pt gutters: 4*120 + 3*1 = 483.
    private static let fourWide: CGFloat = 483

    @Test("Nine cells go three across rather than four-four-one")
    func prefersAFullLastRow() {
        let columns = WorkbenchCellGridMath.columns(
            forCount: 9, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1)
        #expect(columns == 3, "nine cells chose \(columns) columns, leaving an orphan row")
    }

    /// The example above is one case of a rule, so the rule itself is checked across every count a
    /// head block might plausibly carry: whatever column count is chosen either divides the cells
    /// evenly, or no count that fits could have.
    @Test("Whenever a full last row is possible, it is taken", arguments: 1...16)
    func theRuleHoldsAcrossCounts(count: Int) {
        let maximum = WorkbenchCellGridMath.maximumColumns(
            availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1)
        let chosen = WorkbenchCellGridMath.columns(
            forCount: count, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1)
        let ceiling = min(maximum, count)
        let divisorWasAvailable = (2...max(2, ceiling)).contains { $0 <= ceiling && count % $0 == 0 }
        if divisorWasAvailable {
            #expect(count % chosen == 0,
                    "\(count) cells chose \(chosen) columns although a full last row was possible")
        } else {
            #expect(chosen == ceiling,
                    "\(count) cells had no fitting divisor, so it should take the widest \(ceiling)")
        }
    }

    @Test("A count that divides by the widest fitting column count keeps it")
    func takesTheWidestEvenDivisor() {
        #expect(WorkbenchCellGridMath.columns(
            forCount: 8, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1) == 4)
        #expect(WorkbenchCellGridMath.columns(
            forCount: 12, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1) == 4)
    }

    @Test("A prime count with no fitting divisor falls back to the widest that fits")
    func fallsBackWhenNothingDivides() {
        // 7 is prime: no candidate from 4 down to 2 divides it, so the widest fitting count wins
        // and the layout stretches that short row rather than padding it.
        let columns = WorkbenchCellGridMath.columns(
            forCount: 7, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1)
        #expect(columns == 4, "seven cells chose \(columns) columns")
    }

    @Test("Columns never exceed the number of cells")
    func neverMoreColumnsThanCells() {
        #expect(WorkbenchCellGridMath.columns(
            forCount: 2, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1) == 2)
        #expect(WorkbenchCellGridMath.columns(
            forCount: 1, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1) == 1)
    }

    @Test("A width too small for one cell still yields a single column", arguments: [CGFloat(0), 10, 60, 119])
    func neverFewerThanOneColumn(width: CGFloat) {
        #expect(WorkbenchCellGridMath.columns(
            forCount: 6, availableWidth: width, minimumCellWidth: 120, spacing: 1) == 1)
    }

    @Test func anEmptyGridIsOneColumn() {
        #expect(WorkbenchCellGridMath.columns(
            forCount: 0, availableWidth: Self.fourWide, minimumCellWidth: 120, spacing: 1) == 1)
    }

    @Test("An infinite proposal does not produce an absurd column count")
    func infiniteWidthIsRefused() {
        #expect(WorkbenchCellGridMath.maximumColumns(
            availableWidth: .infinity, minimumCellWidth: 120, spacing: 1) == 1)
    }

    @Test func cellWidthTakesOutTheGutters() {
        #expect(WorkbenchCellGridMath.cellWidth(availableWidth: 483, columns: 4, spacing: 1) == 120)
        #expect(WorkbenchCellGridMath.cellWidth(availableWidth: 100, columns: 1, spacing: 1) == 100)
    }

    @Test func cellWidthNeverGoesNegative() {
        #expect(WorkbenchCellGridMath.cellWidth(availableWidth: 2, columns: 4, spacing: 1) == 0)
    }
}
