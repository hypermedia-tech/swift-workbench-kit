import SwiftUI

/// The reusable segmented selector for a column header (Band 2).
/// Same component left (navigator) and right (inspector) — only the data differs.
public struct SelectorBar<Tag: Hashable>: View {
    private let segments: [SelectorSegment<Tag>]
    @Binding private var selection: Tag

    public init(_ segments: [SelectorSegment<Tag>], selection: Binding<Tag>) {
        self.segments = segments
        self._selection = selection
    }

    public var body: some View {
        Picker("Selection", selection: $selection) {
            ForEach(segments) { segment in
                Label(segment.label, systemImage: segment.systemImage)
                    .help(segment.label)
                    .tag(segment.tag)
            }
        }
        .pickerStyle(.segmented)
        .controlSize(.large)
        .buttonSizing(.flexible)
        .labelStyle(.iconOnly)
        .labelsHidden()
        .clipShape(Capsule())
    }
}

#Preview("SelectorBar - reuse proof") {
    @Previewable @State var inspector = "file"
    @Previewable @State var navigator = "project"
    
    VStack(spacing: 32) {
        // Right column — 3 segments (inspector)
        SelectorBar([
            SelectorSegment(tag: "file",    systemImage: "doc",                 label: "File"),
            SelectorSegment(tag: "history", systemImage: "clock",               label: "History"),
            SelectorSegment(tag: "help",    systemImage: "questionmark.circle", label: "Quick Help"),
        ], selection: $inspector)
        .frame(width: 160)

        // Left column — 8 segments (navigator)
        SelectorBar([
            SelectorSegment(tag: "project", systemImage: "folder",                  label: "Project"),
            SelectorSegment(tag: "scm",     systemImage: "arrow.triangle.branch",   label: "Source Control"),
            SelectorSegment(tag: "symbol",  systemImage: "curlybraces",             label: "Symbols"),
            SelectorSegment(tag: "find",    systemImage: "magnifyingglass",         label: "Find"),
            SelectorSegment(tag: "issue",   systemImage: "exclamationmark.triangle", label: "Issues"),
            SelectorSegment(tag: "test",    systemImage: "checkmark.diamond",       label: "Tests"),
            SelectorSegment(tag: "debug",   systemImage: "ladybug",                 label: "Debug"),
            SelectorSegment(tag: "report",  systemImage: "doc.plaintext",           label: "Reports"),
        ], selection: $navigator)
        .frame(width: 360)
    }
    .padding()
}
