import SwiftUI

/// A pressable row that opens more of the same block underneath it.
///
/// **A fold opens inside its block; it does not become a second block.** A second surface for
/// content that belongs to the first is the thing that needs glass to read at all, and it puts a
/// reader's eye somewhere the reading was not. So the body appears on the inset fill, under the
/// row that was pressed, inside the same border — one step of nesting, and the vocabulary stops
/// there.
///
/// The fold owns whether it is open. That is a presentation fact — true because the reader asked
/// to see more, not because anything in the world changed — and HY-ADR-015 puts those on the view.
public struct WorkbenchBlockFold<Content: View>: View {
    private let title: String
    private let content: Content

    @State private var isExpanded = false
    @State private var isHovering = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// `initiallyExpanded` is the state the fold takes on first appearance — a fold whose content
    /// is the reason the block exists should not make every reader press it once.
    public init(title: String, initiallyExpanded: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        _isExpanded = State(initialValue: initiallyExpanded)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: toggle) {
                HStack(spacing: WorkbenchMetrics.blockHInset) {
                    Image(systemName: "chevron.right")
                        .font(WorkbenchTypography.label)
                        .foregroundStyle(WorkbenchPalette.textLabel.color)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .accessibilityHidden(true)
                    Text(title)
                        .labelRegister()
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, WorkbenchMetrics.blockHInset)
                .padding(.vertical, WorkbenchMetrics.blockRowVInset)
                .background(isHovering ? WorkbenchPalette.hoverTint.color : .clear)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .onHover { isHovering = $0 }
            // There is no `isExpanded` accessibility trait; a disclosure's state is its value.
            // `.isSelected` would say something else entirely — that this row is chosen in a list.
            .accessibilityValue(Text(isExpanded ? "expanded" : "collapsed"))

            if isExpanded {
                Rectangle()
                    .fill(WorkbenchPalette.hairlineSoft.color)
                    .frame(height: WorkbenchMetrics.hairlineWidth)
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(WorkbenchPalette.inset.color)
            }
        }
    }

    private func toggle() {
        withAnimation(reduceMotion ? nil : .snappy(duration: 0.22)) {
            isExpanded.toggle()
        }
    }
}
