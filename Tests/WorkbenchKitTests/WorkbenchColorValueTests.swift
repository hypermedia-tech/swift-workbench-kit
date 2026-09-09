import Testing
@testable import WorkbenchKit

/// The value type the palette is written in: how a hex becomes components, how a tint composites
/// over an opaque backdrop, and where a colour sits on the hue circle. `WorkbenchContrast` and
/// every design assertion in `WorkbenchPaletteTests` are built on these, so they are guarded here
/// on their own — when a palette assertion fails it should be about a colour, not about the ruler.
@Suite("WorkbenchColorValue")
struct WorkbenchColorValueTests {

    @Test("A hex round-trips through its description", arguments: [
        (hex: UInt32(0x0A1020), text: "0A1020"),
        (hex: UInt32(0xFFFFFF), text: "FFFFFF"),
        (hex: UInt32(0x000000), text: "000000"),
        (hex: UInt32(0xFF8589), text: "FF8589"),
    ])
    func hexRoundTrips(hex: UInt32, text: String) {
        #expect(WorkbenchColorValue(hex: hex).hexDescription == text)
    }

    @Test func hexUnpacksEachChannelInOrder() {
        let value = WorkbenchColorValue(hex: 0xFF8000)
        #expect(value.red == 1)
        #expect(abs(value.green - 128.0 / 255) < 0.0001, "green was \(value.green)")
        #expect(value.blue == 0)
        #expect(value.alpha == 1, "a hex with no alpha given is opaque")
    }

    @Test func aFullyOpaqueTintReplacesItsBackdrop() {
        let tint = WorkbenchColorValue(hex: 0xFF0000, alpha: 1)
        #expect(tint.composited(over: WorkbenchColorValue(hex: 0xFFFFFF))
                == WorkbenchColorValue(hex: 0xFF0000))
    }

    @Test func aFullyTransparentTintLeavesItsBackdrop() {
        let backdrop = WorkbenchColorValue(hex: 0x000000)
        let tint = WorkbenchColorValue(hex: 0xFF0000, alpha: 0)
        #expect(tint.composited(over: backdrop) == backdrop)
    }

    @Test("Compositing lands between tint and backdrop, and the result is opaque")
    func compositingLandsBetween() {
        let half = WorkbenchColorValue(hex: 0xFFFFFF, alpha: 0.5)
        let composited = half.composited(over: WorkbenchColorValue(hex: 0x000000))
        #expect(abs(composited.red - 0.5) < 0.0001, "red was \(composited.red)")
        #expect(composited.alpha == 1, "a composite over an opaque backdrop is opaque")
    }

    @Test("Hue reads off the colour wheel", arguments: [
        (hex: UInt32(0xFF0000), degrees: 0.0),
        (hex: UInt32(0x00FF00), degrees: 120.0),
        (hex: UInt32(0x0000FF), degrees: 240.0),
    ])
    func hueOfEachPrimary(hex: UInt32, degrees: Double) {
        let hue = WorkbenchColorValue(hex: hex).hueDegrees
        #expect(abs(hue - degrees) < 0.01, "hue was \(hue), expected \(degrees)")
    }

    @Test("A grey has no hue", arguments: [UInt32(0x000000), 0x808080, 0xFFFFFF])
    func greysHaveNoHue(hex: UInt32) {
        #expect(WorkbenchColorValue(hex: hex).hueDegrees == 0)
    }

    @Test func luminanceRunsFromBlackToWhite() {
        #expect(WorkbenchColorValue(hex: 0x000000).relativeLuminance == 0)
        #expect(abs(WorkbenchColorValue(hex: 0xFFFFFF).relativeLuminance - 1) < 0.0001)
    }
}
