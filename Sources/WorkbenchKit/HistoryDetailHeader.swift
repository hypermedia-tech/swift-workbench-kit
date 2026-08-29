import SwiftUI

public struct HistoryDetailHeader<Leading: View>: View {
    private let title: String
    private let badge: String?
    private let timestamp: Date?
    private let leading: Leading

    public init(
        title: String,
        badge: String?,
        timestamp: Date?,
        @ViewBuilder leading: () -> Leading
    ) {
        self.title = title
        self.badge = badge
        self.timestamp = timestamp
        self.leading = leading()
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            leading
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(2)
                    if let badge {
                        // The SAME badge styling as HistoryRow (caption2 monospaced in a .quaternary
                        // capsule) so the row and its popover read as one object.
                        Text(badge)
                            .font(.caption2.monospaced())
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.quaternary, in: .capsule)
                    }
                }
                if let timestamp {
                    Text(timestamp, format: .relative(presentation: .named))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
    }
}
