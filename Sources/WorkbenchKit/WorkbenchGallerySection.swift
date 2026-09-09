import SwiftUI

/// A titled group of swatches — now nothing but a `WorkbenchBlock` with a header and hairline-
/// divided rows, which is the point: the block chrome this view used to carry verbatim (and
/// carried a second time in `WorkbenchGalleryTypeSpecimen`) lives in one place.
public struct WorkbenchGallerySection: View {
    private let title: String
    private let rows: [WorkbenchGalleryEntry]
    private let backdrop: WorkbenchColorToken

    public init(title: String, rows: [WorkbenchGalleryEntry], backdrop: WorkbenchColorToken) {
        self.title = title
        self.rows = rows
        self.backdrop = backdrop
    }

    public var body: some View {
        WorkbenchBlock {
            WorkbenchBlockHeader(kicker: "Tokens", title: title)
        } content: {
            WorkbenchRows(rows) { row in
                WorkbenchGallerySwatchRow(name: row.name, token: row.token, backdrop: backdrop)
            }
        }
    }
}
