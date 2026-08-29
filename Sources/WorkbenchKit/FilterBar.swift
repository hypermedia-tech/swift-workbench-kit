import SwiftUI

/// A column footer's content: a pill filter field with optional trailing controls.
/// Owns its own height (footers are free) and shares the chrome's horizontal inset.
public struct FilterBar<Leading: View, Trailing: View>: View {
    @Binding private var text: String
    private let prompt: String
    private let leading: Leading
    private let trailing: Trailing
    
    public init(
        text: Binding<String>,
        prompt: String = "Filter",
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self._text = text
        self.prompt = prompt
        self.leading = leading()
        self.trailing = trailing()
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            leading.foregroundStyle(.secondary)
            
            HStack(spacing: 6) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.secondary)
                TextField(prompt, text: $text)
                    .textFieldStyle(.plain)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .glassEffect(in: Capsule())
            
            trailing
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, WorkbenchMetrics.bandHInset)
        .padding(.vertical, 6)
    }
}

// Convenience: trailing-only (preserves existing `FilterBar(text:) { trailing }` call sites)
public extension FilterBar where Leading == EmptyView {
    init(text: Binding<String>, prompt: String = "Filter", @ViewBuilder trailing: () -> Trailing) {
        self.init(text: text, prompt: prompt, leading: { EmptyView() }, trailing: trailing)
    }
}

public extension FilterBar where Leading == EmptyView, Trailing == EmptyView {
    init(text: Binding<String>, prompt: String = "Filter") {
        self.init(text: text, prompt: prompt, leading: { EmptyView() }, trailing: { EmptyView() })
    }
}
