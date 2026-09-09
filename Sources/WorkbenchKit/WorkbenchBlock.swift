import SwiftUI

/// A bounded region of the content layer: a fill one step above the ground, a hairline border, a
/// small radius, and a header divided from the body by a rule rather than by a gap.
///
/// Every section of a document-shaped surface is one of these. That is the whole change that ends
/// a wall of left-aligned text: the reader gets edges to navigate by.
///
/// This is not glass. Per HY-ADR-018 §0.1 the content layer is fills, hairlines and standard
/// materials; glass belongs to the controls that float over it.
public struct WorkbenchBlock<Header: View, Content: View>: View {
    private let header: Header
    private let content: Content

    public init(@ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self.header = header()
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Rectangle()
                .fill(WorkbenchPalette.hairline.color)
                .frame(height: WorkbenchMetrics.hairlineWidth)
            content
        }
        .background(WorkbenchPalette.block.color)
        .clipShape(.rect(cornerRadius: WorkbenchMetrics.blockCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: WorkbenchMetrics.blockCornerRadius)
                .strokeBorder(WorkbenchPalette.hairline.color,
                              lineWidth: WorkbenchMetrics.hairlineWidth)
        }
    }
}
