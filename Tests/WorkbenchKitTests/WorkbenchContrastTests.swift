import Testing
@testable import WorkbenchKit

/// The ruler every design assertion is measured with. Guarded on its own so that when a palette
/// assertion fails, the failure is about a colour rather than about the arithmetic.
@Suite("WorkbenchContrast")
struct WorkbenchContrastTests {

    @Test func blackOnWhiteIsTheMaximum() {
        let ratio = WorkbenchContrast.ratio(
            WorkbenchColorValue(hex: 0x000000), WorkbenchColorValue(hex: 0xFFFFFF))
        #expect(abs(ratio - 21) < 0.01, "black on white measured \(ratio), expected 21")
    }

    @Test func aColourAgainstItselfIsOne() {
        let value = WorkbenchColorValue(hex: 0x1C2743)
        let ratio = WorkbenchContrast.ratio(value, value)
        #expect(abs(ratio - 1) < 0.0001, "a colour against itself measured \(ratio)")
    }

    @Test func ratioDoesNotDependOnOrder() {
        let one = WorkbenchColorValue(hex: 0xF4F7FF)
        let other = WorkbenchColorValue(hex: 0x101A2E)
        #expect(WorkbenchContrast.ratio(one, other) == WorkbenchContrast.ratio(other, one))
    }

    @Test("Hue separation takes the short way round the circle")
    func hueSeparationWrapsAtZero() {
        let nearlyZero = WorkbenchColorValue(hex: 0xFF0A00)     // ~2 degrees
        let nearly360 = WorkbenchColorValue(hex: 0xFF000A)      // ~358 degrees
        let separation = WorkbenchContrast.hueSeparation(nearlyZero, nearly360)
        #expect(separation < 10, "separation across zero measured \(separation)")
    }

    @Test func hueSeparationIsNeverMoreThanHalfTheCircle() {
        let red = WorkbenchColorValue(hex: 0xFF0000)
        let cyan = WorkbenchColorValue(hex: 0x00FFFF)
        #expect(abs(WorkbenchContrast.hueSeparation(red, cyan) - 180) < 0.01)
    }

    @Test func theFloorsAreTheOnesTheDesignIsWrittenAgainst() {
        #expect(WorkbenchContrast.textFloor == 4.5, "WCAG AA for normal text")
        #expect(WorkbenchContrast.lineFloor < WorkbenchContrast.lineCeiling)
    }
}
