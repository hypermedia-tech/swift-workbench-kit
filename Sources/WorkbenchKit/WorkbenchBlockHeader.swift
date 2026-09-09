import SwiftUI

/// The top of a block: a small uppercase kicker, the block's name, and on the trailing edge its
/// count or its one control.
///
/// The kicker is what makes a stack of blocks scannable — it says what KIND of thing this block
/// is before you read what it is about. It is optional because some blocks are their own kind.
public struct WorkbenchBlockHeader<Trailing: View>: View {
    private let kicker: String?
    private let title: String
    private let trailing: Trailing

    public init(kicker: String? = nil, title: String, @ViewBuilder trailing: () -> Trailing) {
        self.kicker = kicker
        self.title = title
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: WorkbenchMetrics.blockHInset) {
            VStack(alignment: .leading, spacing: 2) {
                if let kicker {
                    Text(kicker)
                        .labelRegister()
                }
                Text(title)
                    .font(WorkbenchTypography.blockTitle)
                    .foregroundStyle(WorkbenchPalette.textPrimary.color)
            }
            Spacer(minLength: 0)
            trailing
        }
        .padding(.horizontal, WorkbenchMetrics.blockHInset)
        .padding(.vertical, WorkbenchMetrics.blockRowVInset)
    }
}

extension WorkbenchBlockHeader where Trailing == EmptyView {
    /// A header with nothing on its trailing edge.
    public init(kicker: String? = nil, title: String) {
        self.init(kicker: kicker, title: title) { EmptyView() }
    }
}

extension WorkbenchBlockHeader where Trailing == WorkbenchBlockCount {
    /// A header whose trailing edge carries a count.
    public init(kicker: String? = nil, title: String, count: Int) {
        self.init(kicker: kicker, title: title) {
            WorkbenchBlockCount(count)
        }
    }
}
