import SwiftUI

/// A pressable row that opens more of the same block underneath it.
///
/// **A fold opens inside its block; it does not become a second block.** A second surface for
/// content that belongs to the first is the thing that needs glass to read at all, and it puts a
/// reader's eye somewhere the reading was not. So the body appears on the inset fill, under the
/// row that was pressed, inside the same border — one step of nesting, and the vocabulary stops
/// there. The arithmetic behind that limit is the palette's: there are three fills, `ground`,
/// `block` and `inset`, so a fold inside a fold would draw `inset` on `inset` and disappear.
///
/// **The closed line is a view.** It began as a `String`, which was right while every fold named
/// itself with words. It is not right for a fold whose closed line is the row a reader scans —
/// a rank mark, a title, and the readings that decide whether to open it. `WorkbenchFoldTitle`
/// keeps the words case a one-liner.
///
/// The fold owns whether it is open. That is a presentation fact — true because the reader asked
/// to see more, not because anything in the world changed — and HY-ADR-015 puts those on the view.
public struct WorkbenchBlockFold<Label: View, Content: View>: View {
    private let label: Label
    private let content: Content

    @State private var isExpanded = false
    @State private var isHovering = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// `initiallyExpanded` is the state the fold takes on first appearance — a fold whose content
    /// is the reason the block exists should not make every reader press it once.
    public init(
        initiallyExpanded: Bool = false,
        @ViewBuilder label: () -> Label,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label()
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
                    // The label takes the rest of the row rather than the fold placing a spacer
                    // after it, so a closed line with its own trailing cluster puts that cluster
                    // on the row's trailing edge.
                    label
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
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

extension WorkbenchBlockFold where Label == WorkbenchFoldTitle {
    /// The words case: a fold that names itself, in the label register.
    public init(title: String, initiallyExpanded: Bool = false, @ViewBuilder content: () -> Content) {
        self.init(initiallyExpanded: initiallyExpanded, label: { WorkbenchFoldTitle(title) }, content: content)
    }
}
