import SwiftUI

/// A titled group of swatches — the gallery's own use of the blocking vocabulary it is showing
/// off: a block with a header, rows divided by lines rather than gaps.
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
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .labelRegister()
                .padding(.horizontal, WorkbenchMetrics.blockHInset)
                .padding(.vertical, WorkbenchMetrics.blockRowVInset)
            Rectangle()
                .fill(WorkbenchPalette.hairline.color)
                .frame(height: WorkbenchMetrics.hairlineWidth)
            ForEach(rows.enumerated(), id: \.element.id) { index, row in
                WorkbenchGallerySwatchRow(name: row.name, token: row.token, backdrop: backdrop)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(WorkbenchPalette.hairlineSoft.color)
                            .frame(height: WorkbenchMetrics.hairlineWidth)
                            .opacity(index == rows.count - 1 ? 0 : 1)
                    }
            }
        }
        .background(WorkbenchPalette.block.color)
        .clipShape(.rect(cornerRadius: WorkbenchMetrics.blockCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: WorkbenchMetrics.blockCornerRadius)
                .strokeBorder(WorkbenchPalette.hairline.color, lineWidth: WorkbenchMetrics.hairlineWidth)
        }
    }
}
