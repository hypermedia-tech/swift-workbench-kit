import SwiftUI

public struct HistoryDetailPopover<Leading: View, Actions: View>: View {
    private let title: String
    private let badge: String?
    private let timestamp: Date?
    private let bodyText: String?
    private let isLoadingBody: Bool
    private let hasActions: Bool
    private let leading: Leading
    private let actions: Actions

    public init(
        title: String,
        badge: String? = nil,
        timestamp: Date?,
        bodyText: String?,
        isLoadingBody: Bool = false,
        hasActions: Bool = true,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.badge = badge
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.isLoadingBody = isLoadingBody
        self.hasActions = hasActions
        self.leading = leading()
        self.actions = actions()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HistoryDetailHeader(title: title, badge: badge, timestamp: timestamp) { leading }
            Divider()
            HistoryDetailBody(text: bodyText, isLoading: isLoadingBody)
            // Two guards, both needed: `hasActions` is the caller's runtime intent (a lone `if` in a
            // ViewBuilder lowers to Optional, which the type-check below CANNOT read as empty — U8.1 §0);
            // the EmptyView type-check still spares a caller that structurally passes no actions.
            if hasActions && Actions.self != EmptyView.self {
                Divider()
                VStack(alignment: .leading, spacing: 2) { actions }
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .frame(width: WorkbenchMetrics.detailPopoverWidth)
    }
}

#Preview("HistoryDetailPopover — FL and git shapes (reuse proof)") {
    // Consumer #1: FL / analysis — symbol avatar, analyst headline, analysis-id badge, analysis body.
    HistoryDetailPopover(
        title: "Runner controller healthy but idle",
        badge: "ee9b581",
        timestamp: .now,
        bodyText: "No indicators of compromise in the supplied window. The controller reports "
            + "healthy; queue depth 0; last heartbeat within tolerance.",
        isLoadingBody: false
    ) {
        AvatarCircle(symbol: "checkmark.seal.fill", tint: .green)
    } actions: {
        Button("Promote to Finding", systemImage: "checkmark.seal") {}
    }
    .padding()

    // Consumer #2: git commit — monogram author avatar, hash badge, commit-message body, git actions.
    HistoryDetailPopover(
        title: "Bruno Watt",
        badge: "5feed02",
        timestamp: .now.addingTimeInterval(-3600),
        bodyText: "ok starting to look right",
        isLoadingBody: false
    ) {
        AvatarCircle(monogram: "Bruno Watt", tint: .indigo)
    } actions: {
        Button("Show Commit", systemImage: "arrow.triangle.branch") {}
        Button("Open in Code Review", systemImage: "arrow.left.arrow.right") {}
        Button("Email Author", systemImage: "envelope") {}
    }
    .padding()
}
