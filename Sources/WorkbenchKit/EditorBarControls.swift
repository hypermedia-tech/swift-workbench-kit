import SwiftUI

/// The editor bar's trailing controls — the SAME cluster in every detail pane, because a bar whose
/// buttons change from pane to pane is not a shared bar. The kit owns them; a pane owns only what
/// its flip DOES.
///
/// The flip (⇄) cycles the centre between the pane's two displays: the file and its vault marker
/// in the case pane, the report and the original in Reporter. A pane with nothing to flip passes
/// no action and the button disables — the affordance stays in place rather than the cluster
/// changing shape underneath the reader.
///
/// Split and + are placeholders, and deliberately still placeholders here rather than quietly
/// dropped for one pane: they are the case bar's shipped shape, and one bar means one shape.
struct EditorBarControls: View {
    let flip: (() -> Void)?

    var body: some View {
        HStack(spacing: WorkbenchMetrics.editorBarControlSpacing) {
            // Title + icon drawn icon-only, so VoiceOver and the tooltip say "Flip View" —
            // the EditorBarHistoryControl pattern. The deployed cluster was a bare Image with
            // no label at all; sharing it fixes that for both panes at once.
            Button("Flip View", systemImage: "arrow.left.arrow.right") { flip?() }
                .disabled(flip == nil)
                .help("Flip View")

            Button {} label: { Image(systemName: "rectangle.split.2x1") }
            Divider().frame(height: 16)
            Button {} label: { Image(systemName: "plus") }
        }
        .labelStyle(.iconOnly)
        .workbenchEditorBarControlStyle()
    }
}
