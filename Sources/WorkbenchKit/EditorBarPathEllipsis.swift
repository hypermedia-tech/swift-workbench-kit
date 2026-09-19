import SwiftUI

/// The folders between the root and what is open, folded into one "…" component. Its menu lists
/// them in order, each a submenu of its own children with the one on the path in bold, so nothing
/// the written-out path offers is lost: it is one level further in.
///
/// Internal on purpose: only `EditorBarPathShortRow` builds it.
struct EditorBarPathEllipsis<Node: Identifiable>: View {
    let chain: [Node]
    let name: KeyPath<Node, String>
    let children: KeyPath<Node, [Node]?>
    let systemImage: (Node) -> String
    let onOpen: (Node) -> Void

    var body: some View {
        Menu {
            ForEach(Array(chain.enumerated().dropFirst().dropLast()), id: \.element.id) { index, node in
                Menu {
                    EditorBarPathMenuItems(
                        items: node[keyPath: children] ?? [],
                        currentID: chain[index + 1].id,
                        name: name,
                        children: children,
                        systemImage: systemImage,
                        onOpen: onOpen)
                } label: {
                    Label(node[keyPath: name], systemImage: systemImage(node))
                }
            }
        } label: {
            Label("Folders in between", systemImage: "ellipsis")
                .labelStyle(.iconOnly)
                .foregroundStyle(.secondary)
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
        .help(chain.dropFirst().dropLast().map { $0[keyPath: name] }.joined(separator: " › "))
    }
}
