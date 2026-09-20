import SwiftUI

/// The choice component's menu, in one of its two forms: `written` draws glyph, name and figure;
/// not written draws the glyph alone. The entries are the same in both: the current one bold, each
/// figure as its badge.
///
/// Internal on purpose: only `EditorBarPathChoice` builds it.
struct EditorBarPathChoiceMenu<Choice: Identifiable>: View {
    let choices: [Choice]
    let current: Choice
    let written: Bool
    let title: String
    let spoken: String
    let name: KeyPath<Choice, String>
    let detail: (Choice) -> String?
    let systemImage: (Choice) -> String
    let onChoose: (Choice) -> Void

    var body: some View {
        Menu {
            ForEach(choices) { choice in
                Button { onChoose(choice) } label: {
                    Label {
                        Text(choice[keyPath: name]).bold(choice.id == current.id)
                    } icon: {
                        Image(systemName: systemImage(choice))
                    }
                }
                .badge(detail(choice).map { Text($0) })
            }
        } label: {
            if written {
                Label(spoken, systemImage: systemImage(current))
                    .foregroundStyle(.secondary)
            } else {
                Label(spoken, systemImage: systemImage(current))
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
            }
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
        .help(written ? title : "\(title): \(spoken)")
        .accessibilityLabel("\(title): \(spoken)")
    }
}
