import Foundation

/// One reading in a cell grid: a number and what it counts, with an optional status tone.
///
/// The value is a `String` rather than a number because a cell shows readings a formatter has
/// already settled — "12 of 13", "1.2 GB", "—" — and a kit that took an `Int` would push every
/// consumer into a second, parallel formatting decision.
///
/// **Deliberately not `Identifiable`**, for the reason `WorkbenchFact` gives: a label is not
/// unique. Two dependency files of the same name in different directories produce two cells
/// labelled the same, and identity by label silently made them one.
///
/// `nonisolated` for the reason `WorkbenchColorValue` carries it: this is an immutable value, and
/// the module's default `MainActor` isolation would otherwise put it — and its `Equatable`
/// conformance, which `InferIsolatedConformances` would bind to the main actor with it — out of
/// reach of any caller that is not on the main actor.
nonisolated public struct WorkbenchCell: Sendable, Equatable {
    public let value: String
    public let label: String
    public let tone: WorkbenchPalette.Tone?

    public init(value: String, label: String, tone: WorkbenchPalette.Tone? = nil) {
        self.value = value
        self.label = label
        self.tone = tone
    }
}
