import SwiftUI

/// The name of what is open, as an editor bar draws it: secondary, one line, elided in the MIDDLE
/// so both the start and the extension survive, with the full string on hover.
///
/// Middle truncation is the point. A bar is the one place a long name must not push the controls
/// off the end, and the two halves a reader recognises a file by — its stem and its extension —
/// are the two the middle-eliding keeps.
///
/// The ONE leaf renderer: `EditorBarPath` draws its last component through this rather than
/// building its own label, so a bare name and the end of a path cannot look different. They did,
/// briefly — the path gained a kind glyph and this did not — which is what collapsing them fixes.
public struct EditorBarTitle: View {
    private let text: String
    private let systemImage: String

    public init(_ text: String, systemImage: String) {
        self.text = text
        self.systemImage = systemImage
    }

    public var body: some View {
        Label(text, systemImage: systemImage)
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .truncationMode(.middle)
            .help(text)
    }
}
