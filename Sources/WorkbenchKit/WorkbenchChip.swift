import SwiftUI

/// One word on a ground of its own tone: the smallest thing a row can carry that is seen before it
/// is read.
///
/// The kit owns how a chip reads and nothing else. The consuming app supplies the word and picks the
/// tone, the bargain `SchemePill` already states — this package knows no product's vocabulary, so
/// "FIX" and "EXPLOIT" are a tenant's words and `affirm` and `warning` are its choices.
///
/// The tone is applied AFTER `labelRegister()`, which sets `textLabel`: on a chip the tone is the
/// reading, so it overrides what the register sets.
///
/// No width, no line limit and no `fixedSize` — a chip is as wide as its word, and how it behaves
/// when the row runs out of room is the row's decision, not the chip's.
public struct WorkbenchChip: View {
    private let word: String
    private let tone: WorkbenchPalette.Tone

    public init(_ word: String, tone: WorkbenchPalette.Tone) {
        self.word = word
        self.tone = tone
    }

    public var body: some View {
        Text(word)
            .labelRegister()
            .foregroundStyle(WorkbenchPalette.color(tone))
            .padding(.horizontal, WorkbenchMetrics.chipHInset)
            .padding(.vertical, WorkbenchMetrics.chipVInset)
            .background(
                WorkbenchPalette.chipWash(for: tone).color,
                in: .rect(cornerRadius: WorkbenchMetrics.chipCornerRadius))
            // Pins the spoken form to the word as given, whatever case the register renders it in.
            .accessibilityLabel(word)
    }
}
