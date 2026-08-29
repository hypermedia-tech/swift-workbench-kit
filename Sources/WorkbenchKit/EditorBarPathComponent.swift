import SwiftUI

/// One traversable component of the path: a menu labelled with the folder's name and glyph, whose
/// entries are that folder's own children.
///
/// Internal on purpose — it is only ever built by `EditorBarPath`, and a public type whose init is
/// the implicit memberwise one would be unusable outside the module anyway.
struct EditorBarPathComponent<Node: Identifiable>: View {
    let node: Node
    let currentChildID: Node.ID?
    let name: KeyPath<Node, String>
    let children: KeyPath<Node, [Node]?>
    let systemImage: (Node) -> String
    let onOpen: (Node) -> Void

    var body: some View {
        Menu {
            EditorBarPathMenuItems(
                items: node[keyPath: children] ?? [],
                currentID: currentChildID,
                name: name,
                children: children,
                systemImage: systemImage,
                onOpen: onOpen)
        } label: {
            Label(node[keyPath: name], systemImage: systemImage(node))
                .foregroundStyle(.secondary)
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
    }
}
