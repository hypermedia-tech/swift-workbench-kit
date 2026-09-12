import SwiftUI
import Testing
@testable import WorkbenchKit

/// The palette's design rules, as assertions. Every number in the design document is here, so a
/// tuning pass that walks a token below a floor fails a test rather than a review — which is the
/// only way a palette tuned by eye stays legible a year later.
@Suite("WorkbenchPalette")
struct WorkbenchPaletteTests {

    // MARK: - Fixtures

    /// Every fill text can end up sitting on, hovered states included. A hover is a tint over a
    /// fill, so its contrast is the composite's, not the tint's.
    private static func readingGrounds(_ scheme: ColorScheme) -> [(String, WorkbenchColorValue)] {
        let ground = WorkbenchPalette.ground.value(for: scheme)
        let block = WorkbenchPalette.block.value(for: scheme)
        let inset = WorkbenchPalette.inset.value(for: scheme)
        let hover = WorkbenchPalette.hoverTint.value(for: scheme)
        return [
            ("ground", ground),
            ("block", block),
            ("inset", inset),
            ("hovered block", hover.composited(over: block)),
            ("hovered inset", hover.composited(over: inset)),
        ]
    }

    /// `nonisolated` so `@Test(arguments:)` can read it — an arguments list is evaluated outside
    /// any actor. The tokens themselves stay `MainActor` like the module they come from.
    nonisolated static let readableTokenNames = [
        "textPrimary", "textSecondary", "textLabel", "action",
        "alarm", "warning", "caution", "notice", "affirm",
    ]

    nonisolated static let allTokenNames = readableTokenNames + [
        "ground", "block", "inset", "hoverTint", "hairline", "hairlineSoft",
    ]

    private static let readableTokens: [(String, WorkbenchColorToken)] = [
        ("textPrimary", WorkbenchPalette.textPrimary),
        ("textSecondary", WorkbenchPalette.textSecondary),
        ("textLabel", WorkbenchPalette.textLabel),
        ("action", WorkbenchPalette.action),
        ("alarm", WorkbenchPalette.alarm),
        ("warning", WorkbenchPalette.warning),
        ("caution", WorkbenchPalette.caution),
        ("notice", WorkbenchPalette.notice),
        ("affirm", WorkbenchPalette.affirm),
    ]

    private static let allTokens: [(String, WorkbenchColorToken)] = readableTokens + [
        ("ground", WorkbenchPalette.ground),
        ("block", WorkbenchPalette.block),
        ("inset", WorkbenchPalette.inset),
        ("hoverTint", WorkbenchPalette.hoverTint),
        ("hairline", WorkbenchPalette.hairline),
        ("hairlineSoft", WorkbenchPalette.hairlineSoft),
    ]

    // MARK: - Both appearances are real

    @Test("Every token carries a different value in each appearance",
          arguments: WorkbenchPaletteTests.allTokenNames)
    func lightAndDarkDiffer(name: String) throws {
        let token = try #require(Self.allTokens.first { $0.0 == name }?.1)
        #expect(token.light != token.dark, "\(name) has the same value in both appearances")
    }

    // MARK: - Text holds the floor everywhere it can sit

    /// One case per token per appearance, so a failure names the colour and the appearance in the
    /// test's own identity and not only in a message.
    @Test("Text and status clear WCAG AA on every fill it can sit on",
          arguments: WorkbenchPaletteTests.readableTokenNames, [ColorScheme.light, .dark])
    func readableTokensClearTheTextFloor(name: String, scheme: ColorScheme) throws {
        let token = try #require(Self.readableTokens.first { $0.0 == name }?.1)
        let foreground = token.value(for: scheme)
        for (groundName, ground) in Self.readingGrounds(scheme) {
            let ratio = WorkbenchContrast.ratio(foreground, ground)
            #expect(
                ratio >= WorkbenchContrast.textFloor,
                "\(name) on \(groundName) measured \(ratio), under \(WorkbenchContrast.textFloor)")
        }
    }

    /// The name lists drive the parameterised cases, so a token added to the palette without being
    /// added to a list would go untested. This is what notices.
    @Test func everyTokenInTheFixturesIsNamedInTheArgumentLists() {
        #expect(Self.readableTokens.count == Self.readableTokenNames.count)
        #expect(Self.allTokens.count == Self.allTokenNames.count)
    }

    // MARK: - Lines are seen without shouting

    /// Only the pairings the design allows. A soft line divides rows inside a block; the structural
    /// line borders a block, rules under a header, and divides rows inside an inset region. A soft
    /// line inside an inset region would be invisible, which is why that pairing is not one.
    @Test("Separators sit inside the visible-but-quiet band",
          arguments: [ColorScheme.light, .dark])
    func linesSitInTheirBand(scheme: ColorScheme) {
        let allowed: [(String, WorkbenchColorToken, WorkbenchColorToken)] = [
            ("hairline on ground", WorkbenchPalette.hairline, WorkbenchPalette.ground),
            ("hairline on block", WorkbenchPalette.hairline, WorkbenchPalette.block),
            ("hairline on inset", WorkbenchPalette.hairline, WorkbenchPalette.inset),
            ("hairlineSoft on block", WorkbenchPalette.hairlineSoft, WorkbenchPalette.block),
        ]
        for (name, line, fill) in allowed {
            let ratio = WorkbenchContrast.ratio(line.value(for: scheme), fill.value(for: scheme))
            #expect(
                ratio >= WorkbenchContrast.lineFloor && ratio <= WorkbenchContrast.lineCeiling,
                "\(scheme) \(name) is \(ratio), outside the band")
        }
    }

    // MARK: - The ladder steps

    @Test("Each fill is distinguishable from the fill it sits directly on",
          arguments: [ColorScheme.light, .dark])
    func adjacentFillsAreDistinct(scheme: ColorScheme) {
        let ground = WorkbenchPalette.ground.value(for: scheme)
        let block = WorkbenchPalette.block.value(for: scheme)
        let inset = WorkbenchPalette.inset.value(for: scheme)
        #expect(WorkbenchContrast.ratio(ground, block) >= 1.05)
        #expect(WorkbenchContrast.ratio(block, inset) >= 1.05)
    }

    // MARK: - Status never reads as an action

    @Test("Every status tone is a different colour from the action colour",
          arguments: [ColorScheme.light, .dark])
    func tonesAreSeparatedFromTheActionColour(scheme: ColorScheme) {
        let action = WorkbenchPalette.action.value(for: scheme)
        // STATUS tones only. `neutral` is supporting text and was never on the ramp; `spotlight`
        // IS the action colour, on purpose — a caller marking one reading as the headline. The rule
        // this test holds is that nothing a reader takes as a STATUS may read as a link.
        for tone in WorkbenchPalette.Tone.allCases where tone != .neutral && tone != .spotlight {
            let value = WorkbenchPalette.token(for: tone).value(for: scheme)
            let separation = WorkbenchContrast.hueSeparation(value, action)
            #expect(separation >= 30, "\(scheme) \(tone) is \(separation) degrees from action")
        }
    }

    @Test("Neighbouring tones are told apart by hue or by lightness",
          arguments: [ColorScheme.light, .dark])
    func neighbouringTonesAreDistinct(scheme: ColorScheme) {
        let ramp: [WorkbenchPalette.Tone] = [.alarm, .warning, .caution, .notice, .affirm]
        for (one, other) in zip(ramp, ramp.dropFirst()) {
            let a = WorkbenchPalette.token(for: one).value(for: scheme)
            let b = WorkbenchPalette.token(for: other).value(for: scheme)
            let byHue = WorkbenchContrast.hueSeparation(a, b) >= 25
            let byLightness = WorkbenchContrast.ratio(a, b) >= 1.1
            #expect(byHue || byLightness, "\(scheme) \(one) and \(other) are the same colour")
        }
    }

    // MARK: - The tone map

    /// `spotlight` is the action colour and that is the point — so it is pinned, because a future
    /// palette edit that quietly moved it off `action` would break a drawing without breaking a test.
    @Test("Spotlight is the action colour, deliberately", arguments: [ColorScheme.light, .dark])
    func spotlightIsTheActionColour(scheme: ColorScheme) {
        #expect(WorkbenchPalette.token(for: .spotlight).value(for: scheme)
            == WorkbenchPalette.action.value(for: scheme))
    }

    /// It is still text, so it still holds the text floor on every fill it can sit on — the same
    /// bar `action` itself is held to, and the reason it is not simply "the brand cyan".
    @Test("Spotlight clears the text floor on every ground", arguments: [ColorScheme.light, .dark])
    func spotlightClearsTheFloor(scheme: ColorScheme) {
        let value = WorkbenchPalette.token(for: .spotlight).value(for: scheme)
        for fill in [WorkbenchPalette.ground, WorkbenchPalette.block, WorkbenchPalette.inset] {
            let ratio = WorkbenchContrast.ratio(value, fill.value(for: scheme))
            #expect(ratio >= WorkbenchContrast.textFloor, "\(scheme) spotlight on \(fill) is \(ratio)")
        }
    }

    @Test func neutralReadsAsSupportingText() {
        #expect(WorkbenchPalette.token(for: .neutral).dark == WorkbenchPalette.textSecondary.dark)
        #expect(WorkbenchPalette.token(for: .neutral).light == WorkbenchPalette.textSecondary.light)
    }

    /// §5 tells the owner to change the hover tint and look again. A tint too weak to see is not a
    /// hover, and one strong enough to read as a selection is a different affordance — so the lift
    /// it produces over each fill it is drawn on is bounded, the same way the separators are.
    @Test("A hover lifts its fill perceptibly without reading as a selection",
          arguments: [ColorScheme.light, .dark])
    func theHoverTintLiftsWithinItsBand(scheme: ColorScheme) {
        let tint = WorkbenchPalette.hoverTint.value(for: scheme)
        for (name, fill) in [("block", WorkbenchPalette.block), ("inset", WorkbenchPalette.inset)] {
            let ground = fill.value(for: scheme)
            let lift = WorkbenchContrast.ratio(tint.composited(over: ground), ground)
            #expect(lift >= 1.05 && lift <= 1.35, "\(scheme) hover on \(name) lifts \(lift)")
        }
    }

    @Test func theHoverTintIsATintAndNotAFill() {
        #expect(WorkbenchPalette.hoverTint.dark.alpha < 1)
        #expect(WorkbenchPalette.hoverTint.light.alpha < 1)
    }

    // MARK: - Chips

    /// A chip's ground is not one of `readingGrounds`, because only ONE token is ever drawn on it:
    /// the tone whose wash it is. This is that rule, stated.
    ///
    /// One case per tone per appearance, for the reason the token sweep above gives: a failure
    /// should name the colour and the appearance in the test's own identity. Both fills a chip can
    /// sit on are checked, because the wash is a tint and the composite differs between them.
    @Test("Every tone's word clears the text floor on its own chip wash",
          arguments: WorkbenchPalette.Tone.allCases, [ColorScheme.light, .dark])
    func everyToneClearsTheFloorOnItsOwnWash(tone: WorkbenchPalette.Tone, scheme: ColorScheme) {
        let word = WorkbenchPalette.token(for: tone).value(for: scheme)
        let wash = WorkbenchPalette.chipWash(for: tone).value(for: scheme)
        for (name, fill) in [("block", WorkbenchPalette.block), ("inset", WorkbenchPalette.inset)] {
            let ground = wash.composited(over: fill.value(for: scheme))
            let ratio = WorkbenchContrast.ratio(word, ground)
            #expect(
                ratio >= WorkbenchContrast.textFloor,
                "\(tone) on its wash over \(name) measured \(ratio)")
        }
    }

    @Test("A chip's ground is a tint and not a fill",
          arguments: WorkbenchPalette.Tone.allCases)
    func theChipWashIsATintAndNotAFill(tone: WorkbenchPalette.Tone) {
        #expect(WorkbenchPalette.chipWash(for: tone).light.alpha < 1)
        #expect(WorkbenchPalette.chipWash(for: tone).dark.alpha < 1)
    }

    /// A wash too weak to see is not a chip, and one strong enough to read as a selection is a
    /// different affordance — the bound `hoverTint` is held to, for the same reason. The two bands
    /// overlap and that is not a mistake: a chip is bounded because it is a fill, not because it
    /// must out-shout a hover. Measured range at the shipped alphas is 1.113–1.266.
    @Test("A chip's ground is seen without reading as a selection",
          arguments: WorkbenchPalette.Tone.allCases, [ColorScheme.light, .dark])
    func theChipWashLiftsWithinItsBand(tone: WorkbenchPalette.Tone, scheme: ColorScheme) {
        let wash = WorkbenchPalette.chipWash(for: tone).value(for: scheme)
        let block = WorkbenchPalette.block.value(for: scheme)
        let lift = WorkbenchContrast.ratio(wash.composited(over: block), block)
        #expect(lift >= 1.10 && lift <= 1.40, "\(tone) wash lifts \(lift)")
    }
}
