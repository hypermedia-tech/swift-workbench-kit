import SwiftUI

public struct HistoryRow<Leading: View>: View {
    private let leading: Leading
    private let title: String
    private let badge: String?
    private let message: String
    private let timestamp: Date

    public init(
        title: String,
        badge: String? = nil,
        message: String,
        timestamp: Date,
        @ViewBuilder leading: () -> Leading
    ) {
        self.title = title
        self.badge = badge
        self.message = message
        self.timestamp = timestamp
        self.leading = leading()
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            leading
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Spacer(minLength: 6)
                    if let badge {
                        Text(badge)
                            .font(.caption2.monospaced())
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.quaternary, in: .capsule)
                    }
                }
                Text(message)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(timestamp, format: .relative(presentation: .named))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(.rect)
    }
}

#Preview("HistoryRow — the FL shapes") {
    List {
        HistoryRow(
            title: "Runner controller healthy but idle",
            badge: "ee9b581",
            message: "Composed from chat",
            timestamp: .now
        ) {
            AvatarCircle(symbol: "checkmark.seal.fill", tint: .green)
        }
        HistoryRow(
            title: "No IoCs in the provided window",
            badge: "a3f4d8b",
            message: "Composed from chat",
            timestamp: .now.addingTimeInterval(-3600)
        ) {
            AvatarCircle(symbol: "bubble.left.and.bubble.right.fill", tint: .blue)
        }
        HistoryRow(
            title: "Direct note on the audio timeline",
            badge: "77c0e12",
            message: "Direct entry",
            timestamp: .now.addingTimeInterval(-86_400)
        ) {
            AvatarCircle(symbol: "square.and.pencil", tint: .gray)
        }
    }
    .listStyle(.inset)
    .frame(width: 320, height: 240)
}
