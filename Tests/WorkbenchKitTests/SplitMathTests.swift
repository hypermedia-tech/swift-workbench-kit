import CoreGraphics
import Testing
@testable import WorkbenchKit

@Suite("SplitMath")
struct SplitMathTests {

    @Test func clampHoldsTheSecondaryMinimum() {
        #expect(SplitMath.clamp(
            proposed: 50, container: 800, minPrimary: 160, minSecondary: 120) == 120)
    }
    
    @Test func clampHoldsThePrimaryMinimum() {
        #expect(SplitMath.clamp(
            proposed: 700, container: 800, minPrimary: 160, minSecondary: 120) == 640)
    }

    @Test func clampPassesAnInRangeProposalThrough() {
        #expect(SplitMath.clamp(
            proposed: 300, container: 800, minPrimary: 160, minSecondary: 120) == 300)
    }

    @Test func tinyContainerResolvesInThePrimarysFavour() {
        // Container smaller than both minimums: the ceiling pins at minSecondary,
        // the secondary holds there, the primary takes the remainder.
        #expect(SplitMath.clamp(
            proposed: 500, container: 200, minPrimary: 160, minSecondary: 120) == 120)
    }

    @Test func zeroContainerStillReturnsTheSecondaryMinimum() {
        #expect(SplitMath.clamp(
            proposed: 300, container: 0, minPrimary: 160, minSecondary: 120) == 120)
    }

    @Test func collapseSnapsBelowTheFractionOfMinimum() {
        #expect(SplitMath.shouldCollapse(proposed: 59, minSecondary: 120, snapFraction: 0.5))
        #expect(!SplitMath.shouldCollapse(proposed: 61, minSecondary: 120, snapFraction: 0.5))
        #expect(!SplitMath.shouldCollapse(proposed: 60, minSecondary: 120, snapFraction: 0.5))
    }
}
