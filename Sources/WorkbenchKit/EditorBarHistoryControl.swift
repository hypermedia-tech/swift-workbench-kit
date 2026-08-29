import SwiftUI

/// Xcode's jump-bar `‹ ›`, at the head of the editor bar. Each side disables when its stack is
/// empty. Direct-action buttons (title + icon) drawn icon-only, so VoiceOver still reads "Back" and
/// "Forward".
///
/// A leading-slot control, so it asks for the bar's control grammar by name rather than restating
/// it. The 2pt pairing is its own: these two are one control, tighter than the gap between separate
/// ones.
public struct EditorBarHistoryControl: View {
    private let canGoBack: Bool
    private let canGoForward: Bool
    private let goBack: () -> Void
    private let goForward: () -> Void

    public init(
        canGoBack: Bool,
        canGoForward: Bool,
        goBack: @escaping () -> Void,
        goForward: @escaping () -> Void
    ) {
        self.canGoBack = canGoBack
        self.canGoForward = canGoForward
        self.goBack = goBack
        self.goForward = goForward
    }

    public var body: some View {
        HStack(spacing: 2) {
            Button("Back", systemImage: "chevron.left", action: goBack)
                .disabled(!canGoBack)
            Button("Forward", systemImage: "chevron.right", action: goForward)
                .disabled(!canGoForward)
        }
        .labelStyle(.iconOnly)
        .workbenchEditorBarControlStyle()
    }
}
