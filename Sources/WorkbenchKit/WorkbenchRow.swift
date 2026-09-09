import SwiftUI

/// One row's chrome inside a block: the standard insets, and nothing else. Rows are divided from
/// each other by `WorkbenchRows`, never by gaps and never by a modifier a call site can forget.
public struct WorkbenchRow<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, WorkbenchMetrics.blockHInset)
            .padding(.vertical, WorkbenchMetrics.blockRowVInset)
    }
}
