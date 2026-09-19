import SwiftUI

/// The path written out: every component from the root to what is open, then whatever follows the
/// leaf. `namesFolders` false is the tighter form, where a folder on the way shows its glyph only;
/// its name is then its tooltip and what VoiceOver reads, and its menu is unchanged. What is open
/// (the last component) keeps its words in both.
///
/// Internal on purpose: only `EditorBarPath` builds it.
struct EditorBarPathRow<Node: Identifiable, Trailing: View>: View {
    let chain: [Node]
    let namesFolders: Bool
    let name: KeyPath<Node, String>
    let children: KeyPath<Node, [Node]?>
    let systemImage: (Node) -> String
    let onOpen: (Node) -> Void
    let trailing: Trailing

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(chain.enumerated()), id: \.element.id) { index, node in
                if index > 0 {
                    Image(systemName: "chevron.compact.right").foregroundStyle(.tertiary)
                }
                if node[keyPath: children] == nil {
                    EditorBarTitle(node[keyPath: name], systemImage: systemImage(node))
                } else {
                    EditorBarPathComponent(
                        node: node,
                        currentChildID: chain.indices.contains(index + 1)
                            ? chain[index + 1].id : nil,
                        named: namesFolders || index == chain.count - 1,
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
