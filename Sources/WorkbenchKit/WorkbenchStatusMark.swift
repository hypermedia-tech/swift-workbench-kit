import SwiftUI

/// A small ranked mark in one of the palette's tones — the thing that lets a row say how bad it is
/// before a word of it is read.
///
/// It exists so colour is never the only channel. The tone carries the reading, and the mark's
/// fixed position at the head of a row carries it again for anyone who cannot use the colour, which
/// is what Differentiate Without Colour asks for and what a coloured word alone does not give.
public struct WorkbenchStatusMark: View {
    private let tone: WorkbenchPalette.Tone

    /// The mark's LENGTH tracks the line it marks, so it still reads as a rule beside the title at
    /// larger Dynamic Type instead of shrinking into a dot — the same reason `WorkbenchCellGrid`
    /// scales its minimum. Relative to `.headline` because that is the register of the title it
    /// stands beside. Its THICKNESS does not scale: it is a rule, like a hairline.
    @ScaledMetric(relativeTo: .headline) private var length: CGFloat = 14

    public init(_ tone: WorkbenchPalette.Tone) {
        self.tone = tone
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(WorkbenchPalette.color(tone))
            .frame(width: 3, height: length)
            .accessibilityHidden(true)
    }
}
