import SwiftUI

/// The name of what is open, as an editor bar draws it: secondary, one line, elided in the MIDDLE
/// so both the start and the extension survive, with the full string on hover.
///
/// Middle truncation is the point of the written form. A bar is the one place a long name must not
/// push the controls off the end, and the two halves a reader recognises a file by — its stem and
/// its extension — are the two the middle-eliding keeps.
///
/// It GIVES WAY. `named` false draws the kind glyph alone, for the tightest form of the path; the
/// name stays as the tooltip and as what VoiceOver reads. Truncation shrinks this but never to
/// nothing, so without the second form the narrowest the bar could be still moved with whatever
/// was open.
///
/// The ONE leaf renderer: `EditorBarPath` draws its last component through this rather than
/// building its own label, so a bare name and the end of a path cannot look different.
public struct EditorBarTitle: View {
    private let text: String
    private let systemImage: String
    private let named: Bool

    /// `named` false is the glyph alone. It defaults to true, so a caller drawing a bare title in
    /// a bar of its own is unaffected.
    public init(_ text: String, systemImage: String, named: Bool = true) {
        self.text = text
        self.systemImage = systemImage
        self.named = named
    }

    public var body: some View {
        if named {
            Label(text, systemImage: systemImage)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)
                .help(text)
        } else {
            Label(text, systemImage: systemImage)
                .labelStyle(.iconOnly)
                .foregroundStyle(.secondary)
                .help(text)
                .accessibilityLabel(text)
        }
    }
}
