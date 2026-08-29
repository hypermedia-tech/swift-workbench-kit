import SwiftUI

/// The entries of one component menu: a file is a button that opens it, a folder is a submenu of
/// its own children. Recursive, and terminating by construction — the recursion follows `children`,
/// which is nil at every file.
///
/// An EMPTY folder is the one honest dead entry: there is nothing to pick, so it says so by being
/// disabled rather than opening a submenu with nothing in it.
///
/// `currentID` marks the entry on the open file's path, in BOLD rather than with a checkmark:
/// swapping the glyph for a checkmark would cost the kind icon, which is the thing worth having.
/// It is nil for every level below the first, because only one child per level can be on the path.
struct EditorBarPathMenuItems<Node: Identifiable>: View {
    let items: [Node]
    let currentID: Node.ID?
    let name: KeyPath<Node, String>
    let children: KeyPath<Node, [Node]?>
    let systemImage: (Node) -> String
    let onOpen: (Node) -> Void

    var body: some View {
        ForEach(items) { item in
            if let grandchildren = item[keyPath: children] {
                if grandchildren.isEmpty {
                    Button {} label: { label(for: item) }
                        .disabled(true)
                } else {
                    Menu {
                        EditorBarPathMenuItems(
                            items: grandchildren,
                            currentID: nil,
                            name: name,
                            children: children,
                            systemImage: systemImage,
                            onOpen: onOpen)
                    } label: {
                        label(for: item)
                    }
                }
            } else {
                Button { onOpen(item) } label: { label(for: item) }
            }
        }
    }

    private func label(for item: Node) -> some View {
        Label {
            Text(item[keyPath: name]).bold(item.id == currentID)
        } icon: {
            Image(systemName: systemImage(item))
        }
    }
}
