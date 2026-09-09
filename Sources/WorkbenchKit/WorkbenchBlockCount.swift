import SwiftUI

/// A count on a block header's trailing edge — the label register with tabular figures, so a
/// column of blocks keeps its numbers in line and none of them shouts.
public struct WorkbenchBlockCount: View {
    private let count: Int

    public init(_ count: Int) {
        self.count = count
    }

    public var body: some View {
        Text(count, format: .number)
            .monospacedDigit()
            .labelRegister()
    }
}
