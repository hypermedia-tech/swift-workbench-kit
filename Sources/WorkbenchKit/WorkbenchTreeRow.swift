import SwiftUI

/// One node and, if it has children, its disclosure. Recursive: the tree's depth is the node
/// graph's depth, and the kit imposes no limit.
///
/// A node whose `children` key path yields nil is a leaf and draws no triangle; an EMPTY array
/// is a container that happens to be empty and draws one. That distinction is the caller's to
/// make and is the only structural question the kit asks of a node.
struct WorkbenchTreeRow<Node: Identifiable, Row: View>: View {
    let node: Node
    let children: KeyPath<Node, [Node]?>
    @Binding var expanded: Set<Node.ID>
    let filtering: Bool
    let forcedOpen: Set<Node.ID>
    let row: (Node) -> Row

    var body: some View {
        if let childNodes = node[keyPath: children] {
            DisclosureGroup(isExpanded: isExpanded) {
                ForEach(childNodes) { child in
                    WorkbenchTreeRow(
                        node: child,
                        children: children,
                        expanded: $expanded,
                        filtering: filtering,
                        forcedOpen: forcedOpen,
                        row: row)
                }
            } label: {
                row(node).tag(node.id)
            }
        } else {
            row(node).tag(node.id)
        }
    }

    /// While filtering, expansion is driven by the match paths and is read-only; otherwise it is
    /// the user's own set. Writing through during a filter would silently rewrite what the user
    /// had open before they typed.
    private var isExpanded: Binding<Bool> {
        Binding(
            get: { filtering ? forcedOpen.contains(node.id) : expanded.contains(node.id) },
            set: { open in
                guard !filtering else { return }
                if open { expanded.insert(node.id) } else { expanded.remove(node.id) }
            })
    }
}
