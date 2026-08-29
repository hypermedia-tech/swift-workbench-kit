import SwiftUI

public struct HistoryDetailBody: View {
    private let text: String?
    private let isLoading: Bool
    
    public init(text: String?, isLoading: Bool) {
        self.text = text
        self.isLoading = isLoading
    }
    
    public var body: some View {
        ScrollView {
            Group {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                } else if let text, !text.isEmpty {
                    Text(text)
                        .font(.callout)
                        .textSelection(.enabled)
                } else {
                    Text("No detail text.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: WorkbenchMetrics.detailPopoverBodyMaxHeight)
    }
}
