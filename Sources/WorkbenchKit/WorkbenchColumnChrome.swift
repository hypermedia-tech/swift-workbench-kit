import SwiftUI

public extension View {
    /// Fit a bar's content into the committed chrome band
    func bandSized() -> some View {
        padding(.horizontal, WorkbenchMetrics.bandHInset)
            .frame(minHeight: WorkbenchMetrics.bandHeight)
    }
}

/// Pins a top bar (and optional bottom bar) onto a column's scrollable view via
/// macOS 26 `safeAreaBar`, which also extends the scroll-edge Liquid Glass effect.
/// The TOP bar is sized to the committed band here — the agreement every column's
/// header bottom conforms to. The BOTTOM bar is placed as-is and is NOT band-sized:
/// footers are free to differ in height, be present or absent (the design lets them).
public struct WorkbenchColumnChrome<TopBar: View, BottomBar: View>: ViewModifier {
    private let topBar: TopBar
    private let bottomBar: BottomBar
    private let bottomEdge: ScrollEdgeEffectStyle
    private let hasBottomBar: Bool
    
    public init(
        bottomEdge: ScrollEdgeEffectStyle = .automatic,
        hasBottomBar: Bool,
        @ViewBuilder topBar: () -> TopBar,
        @ViewBuilder bottomBar: () -> BottomBar
    ) {
        self.bottomEdge = bottomEdge
        self.hasBottomBar = hasBottomBar
        self.topBar = topBar()
        self.bottomBar = bottomBar()
    }
    
    public func body(content: Content) -> some View {
        let topped = content
            .scrollEdgeEffectStyle(bottomEdge, for: .bottom)
            .safeAreaBar(edge: .top) { topBar.bandSized() }
        // CRITICAL: an EMPTY `.safeAreaBar(edge: .bottom)` STEALS all hit-testing over the column's
        // content — clicks return the scroll view, never the rows (proven with the chromeprobe
        // hit-test harness: the `bottomEmptyOnly`/`full` variants return HostingScrollView across
        // the whole content, while `fixed` — no empty bottom bar — returns the real row controls).
        //
        // TWO gates, and both are needed. `BottomBar.self == EmptyView.self` is a STATIC TYPE check:
        // it catches the caller who passes nothing, and is structurally BLIND to a caller who passes
        // a ViewBuilder conditional — a lone `if` lowers to `Optional<Bar>` and an if/else to
        // `_ConditionalContent<…>`, neither of which is `EmptyView`, so a footer that renders nothing
        // still emitted an empty bar and killed the column (measured 2026-07-25; same defect class as
        // the U8.1 actions gate). `hasBottomBar` is the caller's RUNTIME intent — the only thing that
        // CAN know — and it is REQUIRED, not defaulted, so the compiler forces every call site to
        // answer. The type check is now the backstop: caller says "yes" but hands over an EmptyView.
        if hasBottomBar && BottomBar.self != EmptyView.self {
            topped.safeAreaBar(edge: .bottom) { bottomBar }
        } else {
            topped
        }
    }
}

public extension View {
    /// Column chrome: top bar + bottom bar
    func workbenchColumnChrome<TopBar: View, BottomBar: View>(
        bottomEdge: ScrollEdgeEffectStyle = .automatic,
        hasBottomBar: Bool,
        @ViewBuilder topBar: () -> TopBar,
        @ViewBuilder bottomBar: () -> BottomBar
    ) -> some View {
        modifier(WorkbenchColumnChrome(
            bottomEdge: bottomEdge,
            hasBottomBar: hasBottomBar,
            topBar: topBar,
            bottomBar: bottomBar
        ))

    }
    
    /// Column chrome: top bar only (inspector, editor)
    func workbenchColumnChrome<TopBar: View>(
        @ViewBuilder topBar: () -> TopBar
    ) -> some View {
        modifier(WorkbenchColumnChrome(hasBottomBar: false, topBar: topBar, bottomBar: { EmptyView() }))
    }
}
