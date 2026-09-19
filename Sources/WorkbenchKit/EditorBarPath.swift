import SwiftUI

/// The jump bar's path: every component from the root down to what is open, each folder a menu you
/// can traverse, the leaf plain. Generic over the caller's own node type — the kit never learns
/// what a file is; the caller hands over two key paths, a glyph and an action.
///
/// Marking: a component's menu marks the child that is ON the current path, which the chain
/// already knows (it is the next component down). Only the top level of each menu can be on-path,
/// so deeper submenus carry no mark and that is correct rather than missing.
///
/// The path GIVES WAY. It has three forms and shows the first that fits the width it is given:
/// written out; folders on the way as glyphs only; and root, "…", what is open. A folder
/// component cannot shorten (a menu's label does not truncate), so without this the bar's
/// narrowest width was the sum of whatever folders led to the open file, and the column holding
/// the bar could not be narrower than that: a minimum that moved every time a different file was
/// opened. With it the narrowest width is the third form's, the same few components however deep
/// the path.
///
/// `trailing` is what follows the leaf at the path's own spacing: an `EditorBarPathChoice`, when
/// the open thing has views of its own to choose between. It brings its own separator.
public struct EditorBarPath<Node: Identifiable, Trailing: View>: View {
    private let chain: [Node]
    private let name: KeyPath<Node, String>
    private let children: KeyPath<Node, [Node]?>
    private let systemImage: (Node) -> String
    private let onOpen: (Node) -> Void
    private let trailing: Trailing

    public init(
        chain: [Node],
        name: KeyPath<Node, String>,
        children: KeyPath<Node, [Node]?>,
        systemImage: @escaping (Node) -> String,
        onOpen: @escaping (Node) -> Void,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.chain = chain
        self.name = name
        self.children = children
        self.systemImage = systemImage
        self.onOpen = onOpen
        self.trailing = trailing()
    }

    public var body: some View {
        // The first form that fits the width the bar is given. Written out in full because the
        // three are different views, not one view with a switch.
        ViewThatFits(in: .horizontal) {
            EditorBarPathRow(
                chain: chain, namesFolders: true, name: name, children: children,
                systemImage: systemImage, onOpen: onOpen, trailing: trailing)
            EditorBarPathRow(
                chain: chain, namesFolders: false, name: name, children: children,
                systemImage: systemImage, onOpen: onOpen, trailing: trailing)
            EditorBarPathShortRow(
                chain: chain, name: name, children: children,
                systemImage: systemImage, onOpen: onOpen, trailing: trailing)
        }
    }
}

public extension EditorBarPath where Trailing == EmptyView {
    /// A path with nothing after its leaf.
    init(
        chain: [Node],
        name: KeyPath<Node, String>,
        children: KeyPath<Node, [Node]?>,
        systemImage: @escaping (Node) -> String,
        onOpen: @escaping (Node) -> Void
    ) {
        self.init(
            chain: chain, name: name, children: children, systemImage: systemImage,
            onOpen: onOpen, trailing: { EmptyView() })
    }
}

/// What the preview walks. Not a type any tenant has.
private struct PreviewPathNode: Identifiable {
    let id: String
    var children: [PreviewPathNode]?
}

#Preview("EditorBarPath - gives way") {
    // One deep path in three bars of different widths: the same call, three forms. The width goes
    // on AFTER the bar: a bar spans the container it is attached to, so a width set on the content
    // first leaves every bar as wide as the preview itself.
    let file = PreviewPathNode(id: "finding.yaml")
    let finding = PreviewPathNode(id: "7A43CD32-AF12-4E7C-BA5B-B95331C919CB", children: [file])
    let findings = PreviewPathNode(id: "Findings", children: [finding])
    let root = PreviewPathNode(id: "Ratlcecream", children: [findings])
    let chain = [root, findings, finding, file]

    VStack(alignment: .leading, spacing: 32) {
        ForEach([900, 560, 320], id: \.self) { width in
            Text("\(width) wide")
                .frame(maxWidth: .infinity, minHeight: 60)
                .workbenchEditorBar(flip: nil) {
                    EditorBarPath(
                        chain: chain,
                        name: \.id,
                        children: \.children,
                        systemImage: { $0.children == nil ? "curlybraces" : "folder.fill" },
                        onOpen: { _ in })
                }
                .frame(width: CGFloat(width))
                .border(.separator)
        }
    }
    .padding()
}
