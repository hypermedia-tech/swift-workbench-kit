import Foundation

/// One reading in a cell grid: a number and what it counts, with an optional status tone.
///
/// The value is a `String` rather than a number because a cell shows readings a formatter has
/// already settled — "12 of 13", "1.2 GB", "—" — and a kit that took an `Int` would push every
/// consumer into a second, parallel formatting decision.
public struct WorkbenchCell: Identifiable, Sendable, Equatable {
    public let id: String
    public let value: String
    public let label: String
    public let tone: WorkbenchPalette.Tone?

    public init(value: String, label: String, tone: WorkbenchPalette.Tone? = nil) {
        self.id = label
        self.value = value
        self.label = label
        self.tone = tone
    }
}
