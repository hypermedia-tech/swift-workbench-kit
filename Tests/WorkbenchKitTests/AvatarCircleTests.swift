import Testing
@testable import WorkbenchKit

// `AvatarCircle.initials(of:)` is the reuse-spine's one piece of pure logic: the author monogram the
// coming git view keys on (Story U8 §0), first exercised by U8's §5.1 preview. It derives up-to-two
// uppercased leading initials from a name. The rest of the kit's popover chrome is declarative SwiftUI
// (verified by the gallery preview + the HostProbe harness, not by unit tests).

@Suite("AvatarCircle.initials")
struct AvatarCircleTests {

    @Test("Two-word names give both leading initials, uppercased", arguments: [
        (name: "Bruno Watt", expected: "BW"),
        (name: "bruno watt", expected: "BW"),       // lowercased source is uppercased
        (name: "ada Lovelace", expected: "AL"),
    ])
    func twoWordNames(name: String, expected: String) {
        #expect(AvatarCircle.initials(of: name) == expected)
    }

    @Test func singleWordGivesOneInitial() {
        #expect(AvatarCircle.initials(of: "Bruno") == "B")
    }

    @Test func capsAtTwoInitialsForLongerNames() {
        // prefix(2): a middle name (or more) never grows the monogram past two glyphs.
        #expect(AvatarCircle.initials(of: "Bruno Bevan Watt") == "BB")
    }

    @Test("Blank and whitespace-only names yield an empty monogram", arguments: ["", "   "])
    func blankNamesYieldEmpty(name: String) {
        #expect(AvatarCircle.initials(of: name).isEmpty)
    }

    @Test func collapsesRepeatedAndEdgeWhitespace() {
        // split omits empty subsequences, so padding and internal runs don't leak blank initials.
        #expect(AvatarCircle.initials(of: "  Bruno   Watt  ") == "BW")
    }
}
