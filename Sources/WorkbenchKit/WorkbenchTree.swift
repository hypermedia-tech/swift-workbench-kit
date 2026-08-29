import SwiftUI

/// A sidebar outline over the caller's own node type: rows the caller builds, disclosure the
/// caller's binding drives. Generic like `EditorBarPath` — the kit is handed one key path for
/// structure and a row builder, and learns nothing else about the tenant's data.
///
/// Programmatic expansion rather than `List(_:children:)`'s free styling, because every consumer
/// eventually needs to force a subtree open: a filter revealing matches, a drop landing a child
/// under a collapsed parent, a build failure surfacing its file. `filtering` swaps the expansion
/// source to `forcedOpen` and makes it read-only for the duration, so the user's own open/closed
/// set survives the filter untouched.
public struct WorkbenchTree<Node: Identifiable, Row: View>: View {
    private let roots: [Node]
    private let children: KeyPath<Node, [Node]?>
    @Binding private var selection: Node.ID?
    @Binding private var expanded: Set<Node.ID>
    private let filtering: Bool
    private let forcedOpen: Set<Node.ID>
    private let row: (Node) -> Row

    public init(
        roots: [Node],
        children: KeyPath<Node, [Node]?>,
        selection: Binding<Node.ID?>,
        expanded: Binding<Set<Node.ID>>,
        filtering: Bool = false,
        forcedOpen: Set<Node.ID> = [],
        @ViewBuilder row: @escaping (Node) -> Row
    ) {
        self.roots = roots
        self.children = children
        self._selection = selection
        self._expanded = expanded
        self.filtering = filtering
        self.forcedOpen = forcedOpen
        self.row = row
    }

    public var body: some View {
        List(selection: $selection) {
            ForEach(roots) { node in
                WorkbenchTreeRow(
                    node: node,
                    children: children,
                    expanded: $expanded,
                    filtering: filtering,
                    forcedOpen: forcedOpen,
                    row: row)
            }
        }
        .environment(\.sidebarRowSize, .small)
    }
}
