import SwiftUI

/// The path at its shortest: the root's glyph, one "…" component holding every folder in between,
/// then what is open and whatever follows it. However deep the path, this form is the same few
/// components wide, which is what gives the bar a minimum width that does not move with what is
/// open.
///
/// Internal on purpose: only `EditorBarPath` builds it.
struct EditorBarPathShortRow<Node: Identifiable, Trailing: View>: View {
    let chain: [Node]
    let name: KeyPath<Node, String>
    let children: KeyPath<Node, [Node]?>
    let systemImage: (Node) -> String
    let onOpen: (Node) -> Void
    let trailing: Trailing

    var body: some View {
        HStack(spacing: 4) {
            if chain.count > 1, let root = chain.first {
                EditorBarPathComponent(
                    node: root,
                    currentChildID: chain[1].id,
                    named: false,
                    name: name,
                    children: children,
                    systemImage: systemImage,
                    onOpen: onOpen)
                Image(systemName: "chevron.compact.right").foregroundStyle(.tertiary)
            }
            if chain.count > 2 {
                EditorBarPathEllipsis(
                    chain: chain,
                    name: name,
                    children: children,
                    systemImage: systemImage,
                    onOpen: onOpen)
                Image(systemName: "chevron.compact.right").foregroundStyle(.tertiary)
            }
            if let last = chain.last {
                if last[keyPath: children] == nil {
                    EditorBarTitle(last[keyPath: name], systemImage: systemImage(last))
                } else {
                    EditorBarPathComponent(
                        node: last,
                        currentChildID: nil,
                        named: true,
                        name: name,
                        children: children,
                        systemImage: systemImage,
                        onOpen: onOpen)
                }
            }
            trailing
        }
        .lineLimit(1)
    }
}
