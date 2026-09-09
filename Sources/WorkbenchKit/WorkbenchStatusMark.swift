import SwiftUI

/// A small ranked mark in one of the palette's tones — the thing that lets a row say how bad it is
/// before a word of it is read.
///
/// It exists so colour is never the only channel. The tone carries the reading, and the mark's
/// fixed position at the head of a row carries it again for anyone who cannot use the colour, which
/// is what Differentiate Without Colour asks for and what a coloured word alone does not give.
public struct WorkbenchStatusMark: View {
    private let tone: WorkbenchPalette.Tone

    public init(_ tone: WorkbenchPalette.Tone) {
        self.tone = tone
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(WorkbenchPalette.color(tone))
            .frame(width: 3, height: 14)
            .accessibilityHidden(true)
    }
}
