import SwiftUI

/// The path's last step: not a place in the tree, but which PART of the open thing is showing, a
/// report's lists, a file's branches.
///
/// Which FORM the open thing is showing, rendered or original, is the bar's flip, not this. A pane
/// whose original side has no parts hides this while flipped.
///
/// Generic over the caller's own choice type, as `EditorBarPath` is over its node: the kit never
/// learns what is being chosen between. `detail` is a short figure that belongs beside a name,
/// a count or a short hash: the component draws it after the name, and the menu draws it
/// as each entry's badge.
///
/// The current entry is BOLD, the rule `EditorBarPathMenuItems` set: a checkmark would cost the
/// kind glyph.
///
/// It draws its own leading chevron, so a caller that shows it only some of the time gets no
/// stray separator. Hand it to `EditorBarPath`'s trailing slot and it sits at the path's spacing.
public struct EditorBarPathChoice<Choice: Identifiable>: View {
    private let title: String
    private let choices: [Choice]
    private let currentID: Choice.ID
    private let name: KeyPath<Choice, String>
    private let detail: (Choice) -> String?
    private let systemImage: (Choice) -> String
    private let onChoose: (Choice) -> Void

    /// `title` says what is being chosen ("List", "Branch"). It is never drawn: it is the
    /// component's tooltip and the start of what VoiceOver reads.
    public init(
        _ title: String,
        choices: [Choice],
        currentID: Choice.ID,
        name: KeyPath<Choice, String>,
        detail: @escaping (Choice) -> String? = { _ in nil },
        systemImage: @escaping (Choice) -> String,
        onChoose: @escaping (Choice) -> Void
    ) {
        self.title = title
        self.choices = choices
        self.currentID = currentID
        self.name = name
        self.detail = detail
        self.systemImage = systemImage
        self.onChoose = onChoose
    }

    public var body: some View {
        if let current = choices.first(where: { $0.id == currentID }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.compact.right").foregroundStyle(.tertiary)
                Menu {
                    ForEach(choices) { choice in
                        Button { onChoose(choice) } label: {
                            Label {
                                Text(choice[keyPath: name]).bold(choice.id == currentID)
                            } icon: {
                                Image(systemName: systemImage(choice))
                            }
                        }
                        .badge(detail(choice).map { Text($0) })
                    }
                } label: {
                    Label {
                        Text(spoken(current))
                    } icon: {
                        Image(systemName: systemImage(current))
                    }
                    .foregroundStyle(.secondary)
                }
                .menuStyle(.borderlessButton)
                .fixedSize()
                .help(title)
                .accessibilityLabel("\(title): \(spoken(current))")
            }
        }
    }

    /// The name, then the detail when there is one: "Issues 9".
    private func spoken(_ choice: Choice) -> String {
        [choice[keyPath: name], detail(choice)].compactMap(\.self).joined(separator: " ")
    }
}

/// What the preview chooses between. Not a type any tenant has: the point is that the kit needs
/// none of theirs.
private struct PreviewEntry: Identifiable {
    let id: String
    var count: Int?
    let glyph: String
    var children: [PreviewEntry]?
}

#Preview("EditorBarPathChoice - reuse proof") {
    // Two tenants: a report's lists with their counts after a path, and a file's branches with
    // no counts after a bare title.
    @Previewable @State var list = "Issues"
    @Previewable @State var branch = "main"
    let lists = [
        PreviewEntry(id: "Issues", count: 9, glyph: "exclamationmark.triangle"),
        PreviewEntry(id: "Informational", count: 1, glyph: "info.circle"),
        PreviewEntry(id: "Closed", count: 0, glyph: "checkmark.circle"),
        PreviewEntry(id: "Assets", count: 49, glyph: "server.rack")
    ]
    let branches = [
        PreviewEntry(id: "main", glyph: "arrow.triangle.branch"),
        PreviewEntry(id: "feature/longer-name", glyph: "arrow.triangle.branch")
    ]

    VStack(spacing: 32) {
        Text(list)
            .frame(width: 520, height: 80)
            .workbenchEditorBar(flip: nil) {
                EditorBarPath(
                    chain: [PreviewEntry(id: "scc-findings.jsonl", glyph: "curlybraces")],
                    name: \.id,
                    children: \.children,
                    systemImage: { $0.glyph },
                    onOpen: { _ in },
                    trailing: {
                        EditorBarPathChoice(
                            "List",
                            choices: lists,
                            currentID: list,
                            name: \.id,
                            detail: { $0.count.map { String($0) } },
                            systemImage: { $0.glyph },
                            onChoose: { list = $0.id })
                    })
            }

        Text(branch)
            .frame(width: 520, height: 80)
            .workbenchEditorBar(flip: nil) {
                EditorBarTitle("Package.swift", systemImage: "swift")
                EditorBarPathChoice(
                    "Branch",
                    choices: branches,
                    currentID: branch,
                    name: \.id,
                    systemImage: { $0.glyph },
                    onChoose: { branch = $0.id })
            }
    }
    .padding()
}
