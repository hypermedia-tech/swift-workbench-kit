import SwiftUI

/// The product identity at the left of the toolbar principal — Xcode's scheme position. The
/// consuming app supplies its own name and glyph; the kit owns only how the pill reads.
public struct SchemePill: View {
    private let title: String
    private let systemImage: String

    public init(title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }

    public var body: some View {
        Label(title, systemImage: systemImage)
            .labelStyle(.titleAndIcon)
            .fontWeight(.medium)
    }
}
