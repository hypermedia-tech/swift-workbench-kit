import AppKit
import SwiftUI

/// Read-only plain-text viewer backed by a TextKit 2 `NSTextView`. TextKit 2 lays out only the
/// visible viewport (`NSTextViewportLayoutController`), so a multi-MB log scrolls without the
/// whole-document layout a single SwiftUI `Text` would force. Pure presentation over primitives —
/// no VM, per HY-ADR-015 (only screen-level views get one).
public struct PlainTextFileView: NSViewRepresentable {
    private let text: String

    public init(text: String) {
        self.text = text
    }

    public func makeNSView(context: Context) -> NSScrollView {
        // "To create a text view that uses TextKit 2, use the new constructor and pass true for
        // the UsingTextLayoutManager parameter." Ventura+ also opts in by default, but the
        // explicit constructor removes any doubt about which engine we got.
        //
        // NEVER let this view fall back to TextKit 1 — the fallback is ONE-WAY ("there's no
        // automatic way of going back"), and it costs us viewport layout, which is the entire
        // reason this type exists. WWDC22 names four causes:
        //   1. accessing `textView.layoutManager`  ← the number-one cause; never touch it
        //   2. reaching the layout manager via the text container
        //   3. attributes TextKit 2 doesn't support, notably TABLES
        //   4. printing
        // Runtime check: `textView.textLayoutManager != nil` means TextKit 2 is still live.
        let textView = NSTextView(usingTextLayoutManager: true)
        let scrollView = NSScrollView()
        scrollView.documentView = textView
        textView.isEditable = false
        textView.isSelectable = true
        textView.isRichText = false
        textView.usesFindBar = true
        textView.textContainerInset = NSSize(width: 12, height: 12)
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        textView.drawsBackground = false
        return scrollView
    }

    public func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        // Only re-set on a real change: assigning `string` replaces the whole document and
        // discards layout + selection, so an unguarded assignment here would undo the win.
        if textView.string != text { textView.string = text }
        // Font lives HERE, not makeNSView, so live Dynamic Type changes apply without
        // reopening the file.
        let font = NSFont.monospacedSystemFont(
            ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
        if textView.font != font { textView.font = font }
    }
}

#Preview {
    PlainTextFileView(
        text: (1...200).map { "2026-07-16T04:11:0\($0 % 10)Z sshd[441]: line \($0)" }
            .joined(separator: "\n"))
    .frame(width: 600, height: 400)
}
