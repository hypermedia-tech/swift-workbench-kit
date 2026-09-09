import SwiftUI

/// A block's body as hairline-divided rows.
///
/// The separation lives here rather than on the row because separation is a fact about siblings:
/// a row cannot know whether it is the last one, and a call site that has to tell it will
/// eventually forget. The last row carries no rule, which is what makes the block's own border
/// read as the end of the list.
public struct WorkbenchRows<Item: Identifiable, Row: View>: View {
    private let items: [Item]
    private let row: (Item) -> Row

    public init(_ items: [Item], @ViewBuilder row: @escaping (Item) -> Row) {
        self.items = items
        self.row = row
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items.enumerated(), id: \.element.id) { index, item in
                row(item)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(WorkbenchPalette.hairlineSoft.color)
                            .frame(height: WorkbenchMetrics.hairlineWidth)
                            .opacity(index == items.count - 1 ? 0 : 1)
                    }
            }
        }
    }
}
