import SwiftUI

/// The jump bar's path: every component from the root down to what is open, each folder a menu you
/// can traverse, the leaf plain. Generic over the caller's own node type — the kit never learns
/// what a file is; the caller hands over two key paths, a glyph and an action.
///
/// Marking: a component's menu marks the child that is ON the current path, which the chain
/// already knows (it is the next component down). Only the top level of each menu can be on-path,
/// so deeper submenus carry no mark and that is correct rather than missing.
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
