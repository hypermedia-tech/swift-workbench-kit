import SwiftUI

/// A DETAIL pane's top bar — Xcode's editor bar, the workbench's second band: what is open on the
/// left, the pane controls on the right, sized to the committed band with a hairline under it.
///
/// This is the WHOLE bar, buttons included. The controls are not a slot a caller fills: they are
/// `EditorBarControls`, the same cluster in every pane, because a bar whose buttons differ from
/// pane to pane is not a shared bar — it is two bars that happen to be the same height. A pane
/// supplies its IDENTITY (a title, a breadcrumb) and what its flip DOES, and nothing else.
///
/// `flip` nil means this pane has nothing to flip right now; the button disables in place rather
/// than the cluster changing shape.
///
/// Distinct from `workbenchColumnChrome`, which is the COLUMN grammar (a band-sized bar that IS
/// the whole header, plus the scroll-edge effect and an optional footer). A detail bar has two
/// regions, a hairline, a wider leading inset, and never a footer.
///
/// The leading slot is deliberately NOT styled — it holds text and breadcrumbs whose own
/// treatments differ, and a blanket `imageScale(.large)` would inflate a crumb chevron. A leading
/// control that wants the bar grammar asks for it: `.workbenchEditorBarControlStyle()`.
public struct WorkbenchEditorBar<Leading: View>: ViewModifier {
    private let leading: Leading
    private let flip: (() -> Void)?

    public init(flip: (() -> Void)?, @ViewBuilder leading: () -> Leading) {
        self.flip = flip
        self.leading = leading()
    }

    public func body(content: Content) -> some View {
        content.safeAreaBar(edge: .top) {
            VStack(spacing: 0) {
                HStack(spacing: WorkbenchMetrics.editorBarSpacing) {
                    leading
                    Spacer(minLength: 0)
                    EditorBarControls(flip: flip)
                }
                .padding(.leading, WorkbenchMetrics.editorBarLeadingInset)
                .padding(.trailing, WorkbenchMetrics.bandHInset)
                .frame(
                    maxWidth: .infinity,
                    minHeight: WorkbenchMetrics.bandHeight,
                    alignment: .leading)
                Divider()
            }
        }
    }
}

public extension View {
    /// Detail-pane chrome: the editor bar across the top, controls included. See
    /// `WorkbenchEditorBar`. `flip` is what this pane's ⇄ does, or nil when it has nothing to flip.
    func workbenchEditorBar<Leading: View>(
        flip: (() -> Void)?,
        @ViewBuilder leading: () -> Leading
    ) -> some View {
        modifier(WorkbenchEditorBar(flip: flip, leading: leading))
    }

    /// The editor bar's control grammar, in one place: flat, borderless, secondary, large icons.
    /// The bar applies this to its own cluster; call it directly only for a bar control that lives
    /// in the leading slot.
    func workbenchEditorBarControlStyle() -> some View {
        buttonStyle(.borderless)
            .foregroundStyle(.secondary)
            .imageScale(.large)
    }
}

#Preview("WorkbenchEditorBar - reuse proof") {
    // Two consumers, one bar. Neither knows anything about a case, a report, or any app type —
    // this preview compiles inside the kit, with nothing but SwiftUI available, which is the
    // whole claim: a pane supplies its identity and what its flip DOES, and gets the same bar.
    @Previewable @State var left = "the report"
    @Previewable @State var right = "the marker"

    VStack(spacing: 32) {
        Text(left)
            .frame(width: 520, height: 80)
            .workbenchEditorBar(flip: { left = left == "the report" ? "the original file" : "the report" }) {
                EditorBarTitle("scan-report.json", systemImage: "curlybraces")
            }

        Text(right)
            .frame(width: 520, height: 80)
            .workbenchEditorBar(flip: { right = right == "the marker" ? "the document" : "the marker" }) {
                Text("Evidence").foregroundStyle(.secondary)
                Image(systemName: "chevron.compact.right").foregroundStyle(.tertiary)
                EditorBarTitle("20260525_Tanuki_Net_App_Perf.pdf", systemImage: "doc.richtext")
            }

        // Nothing to flip: the affordance stays, disabled, rather than the cluster changing shape.
        Text("no selection")
            .frame(width: 520, height: 80)
            .workbenchEditorBar(flip: nil) {
                EmptyView()
            }
    }
    .padding()
}
