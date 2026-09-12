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
    /// scales its minimum. Its THICKNESS does not scale: it is a rule, like a hairline.
    @ScaledMetric private var length: CGFloat

    /// `length` and `textStyle` default to the row case — a 14pt bar scaling with `.headline`,
    /// the register of the title it stands beside — so every existing call is unchanged. A caller
    /// standing the mark against a different register passes both, because scaling relative to a
    /// larger style does not itself make the bar longer: it only changes how it grows.
    public init(
        _ tone: WorkbenchPalette.Tone,
        length: CGFloat = 14,
        relativeTo textStyle: Font.TextStyle = .headline
    ) {
        self.tone = tone
        self._length = ScaledMetric(wrappedValue: length, relativeTo: textStyle)
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(WorkbenchPalette.color(tone))
            .frame(width: 3, height: length)
            .accessibilityHidden(true)
    }
}
