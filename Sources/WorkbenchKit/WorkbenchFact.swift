import Foundation

/// One label-and-value pair in a block: a scanner's name, a file's digest, a date, a count.
///
/// Strings, not a Domain type — this package renders facts and never knows what they mean. The
/// optional tone lets a value carry a status reading without the kit learning anyone's vocabulary.
public struct WorkbenchFact: Identifiable, Sendable, Equatable {
    public let id: String
    public let label: String
    public let value: String
    public let tone: WorkbenchPalette.Tone?

    public init(label: String, value: String, tone: WorkbenchPalette.Tone? = nil) {
        self.id = label
        self.label = label
        self.value = value
        self.tone = tone
    }
}
