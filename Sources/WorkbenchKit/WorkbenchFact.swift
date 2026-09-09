import Foundation

/// One label-and-value pair in a block: a scanner's name, a file's digest, a date, a count.
///
/// Strings, not a Domain type — this package renders facts and never knows what they mean. The
/// optional tone lets a value carry a status reading without the kit learning anyone's vocabulary.
///
/// **Deliberately not `Identifiable`.** A fact's label is not unique and cannot be made unique by
/// the caller: these lists come from a scanner's own projection, so two rows may legitimately carry
/// the same label. Identity by label meant two such rows were one identity, and one of them was
/// dropped. A fact list is an ordered run rather than a set, so the components that draw one key by
/// position and this type carries no id at all.
///
/// `nonisolated` for the reason `WorkbenchColorValue` carries it: this is an immutable value, and
/// the module's default `MainActor` isolation would otherwise put it — and its `Equatable`
/// conformance, which `InferIsolatedConformances` would bind to the main actor with it — out of
/// reach of any caller that is not on the main actor.
nonisolated public struct WorkbenchFact: Sendable, Equatable {
    public let label: String
    public let value: String
    public let tone: WorkbenchPalette.Tone?

    public init(label: String, value: String, tone: WorkbenchPalette.Tone? = nil) {
        self.label = label
        self.value = value
        self.tone = tone
    }
}
