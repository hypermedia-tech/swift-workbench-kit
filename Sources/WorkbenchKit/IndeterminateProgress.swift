import SwiftUI

public struct IndeterminateProgress: View {
    private let label: String

    public init(label: String) {
        self.label = label
    }

    public var body: some View {
        HStack(spacing: 6) {
            ProgressView().controlSize(.small)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
    }
}
