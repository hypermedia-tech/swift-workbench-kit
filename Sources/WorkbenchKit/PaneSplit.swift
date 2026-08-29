import SwiftUI

/// A two-pane split with the Xcode interaction grammar: grab-and-drag resize,
/// snap-to-collapse on release, double-click toggle, resize pointers. Built over
/// plain stacks — NEVER HSplitView/VSplitView (the workbench layout rule: an
/// AppKit split inside the NavigationSplitView detail column imposes a hard
/// detail-column minimum and fights the trailing inspector's safe area; the war
/// story is in AskPane's comment).
///
/// `axis` names the STACKING direction: `.vertical` = primary above secondary,
/// `.horizontal` = primary leading, secondary trailing. The secondary pane's size
/// is held in POINTS (the binding), Xcode-style: window resizes re-clamp the
/// layout but never rewrite the user's chosen size. The caller owns both bindings
/// and their persistence (@SceneStorage at the surface is the expected shape).
///
/// Collapse contract: when `isCollapsed`, the secondary is pinned to
/// `collapsedExtent` (default: the 32pt ribbon strip; pass 0 to vanish entirely)
/// and the divider is removed — expansion is the caller's affordance (a bar
/// button flipping the same binding). A drag released below half the secondary
/// minimum collapses; the pre-drag size is restored to the binding first, so
/// expanding returns the pane to where the user had it.
///
/// LAYOUT RULES (U2 debugging findings — see
/// `.cat/working/Active/UI-v1/CyberBench-U2-Layout-Debugging-Findings.md`):
/// every pane frame carries an explicit alignment (an unaligned frame CENTRES an
/// uncompressible child — bars clip off the top, inputs off the bottom), and
/// every pane is clipped (a pane's content must never paint outside its pane —
/// note clipping is drawing-only; overflow still hit-tests, so overflow must be
/// eliminated at source, not merely clipped).
///
/// ⚠ SCOPED LIMITATION (findings doc §2 + §6; re-scoped 2026-07-23 after the
/// round-8/9 live retry): a HORIZONTAL PaneSplit whose primary held the WHOLE
/// chat column — the input row INSIDE the split's subtree — destroyed that
/// subtree's height proposal in the app (children measured at ideal; never
/// reproduced outside the app across the harness's 20+ runs; mechanism
/// unresolved). The re-cut geometry — the split holding ONLY the content row,
/// bars and input rows OUTSIDE it — is PROVEN LIVE in the app (U2 §18 + the
/// round-9 amendment, owner-verified). Until the mechanism is understood,
/// keep bars/input rows out of a horizontal split's subtree; this file's
/// preview stays the regression lab.
public struct PaneSplit<Primary: View, Secondary: View>: View {
    private let axis: Axis
    private let minPrimary: CGFloat
    private let minSecondary: CGFloat
    private let collapsedExtent: CGFloat
    @Binding private var secondaryExtent: CGFloat
    @Binding private var isCollapsed: Bool
    private let primary: Primary
    private let secondary: Secondary

    @State private var containerExtent: CGFloat = 0
    @State private var dragStartExtent: CGFloat?
    @State private var lastProposal: CGFloat?

    public init(
        axis: Axis = .vertical,
        secondaryExtent: Binding<CGFloat>,
        isCollapsed: Binding<Bool>,
        minPrimary: CGFloat = WorkbenchMetrics.minPrimaryPane,
        minSecondary: CGFloat = WorkbenchMetrics.minSecondaryPane,
        collapsedExtent: CGFloat = WorkbenchMetrics.ribbonHeight,
        @ViewBuilder primary: () -> Primary,
        @ViewBuilder secondary: () -> Secondary
    ) {
        self.axis = axis
        self._secondaryExtent = secondaryExtent
        self._isCollapsed = isCollapsed
        self.minPrimary = minPrimary
        self.minSecondary = minSecondary
        self.collapsedExtent = collapsedExtent
        self.primary = primary()
        self.secondary = secondary()
    }

    public var body: some View {
        // Primitive VStack/HStack, written as full twins (house rule: no shared
        // @ViewBuilder helper). AnyLayout(V/HStackLayout) measured identically
        // in the U2 investigation — the primitive form is kept as the simpler
        // of two equivalents.
        Group {
            if axis == .vertical {
                VStack(spacing: 0) {
                    primary
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .clipped()
                    if !isCollapsed {
                        SplitDivider(
                            axis: .vertical,
                            onDrag: adjust,
                            onDragEnded: settle,
                            onDoubleTap: toggleCollapsed
                        )
                    }
                    // Collapsed to extent 0, the pane LEAVES THE TREE — a zero
                    // frame keeps its content alive at the content's own minimum
                    // inside the clip, and clipped overflow still hit-tests
                    // (findings §6.3: a 42pt invisible hot strip).
                    if !(isCollapsed && collapsedExtent == 0) {
                        secondary
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .frame(
                                height: isCollapsed ? collapsedExtent : displayExtent,
                                alignment: .topLeading
                            )
                            .clipped()
                    }
                }
            } else {
                HStack(spacing: 0) {
                    primary
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .clipped()
                    if !isCollapsed {
                        SplitDivider(
                            axis: .horizontal,
                            onDrag: adjust,
                            onDragEnded: settle,
                            onDoubleTap: toggleCollapsed
                        )
                    }
                    // Collapsed to extent 0, the pane LEAVES THE TREE — same
                    // rationale as the vertical twin above (findings §6.3).
                    if !(isCollapsed && collapsedExtent == 0) {
                        secondary
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                            .frame(
                                width: isCollapsed ? collapsedExtent : displayExtent,
                                alignment: .topLeading
                            )
                            .clipped()
                    }
                }
            }
        }
        .onGeometryChange(for: CGFloat.self) { [axis] proxy in
            axis == .vertical ? proxy.size.height : proxy.size.width
        } action: { containerExtent = $0 }
    }

    /// The extent actually laid out: the binding re-clamped against the LIVE
    /// container, so a window resize keeps both minimums honest without ever
    /// rewriting the user's chosen size.
    private var displayExtent: CGFloat {
        // Before the first geometry callback there is no container to clamp
        // against — floor at the minimum rather than trusting persisted state
        // (a poisoned @SceneStorage value must never wedge the layout).
        guard containerExtent > 0 else { return max(secondaryExtent, minSecondary) }
        return SplitMath.clamp(
            proposed: secondaryExtent,
            container: containerExtent,
            minPrimary: minPrimary,
            minSecondary: minSecondary
        )
    }

    private func adjust(_ translation: CGSize) {
        if dragStartExtent == nil { dragStartExtent = displayExtent }
        guard let start = dragStartExtent else { return }
        // The divider precedes the secondary pane in both axes, so dragging
        // toward the secondary (positive translation) SHRINKS it.
        let delta = axis == .vertical ? translation.height : translation.width
        let proposed = start - delta
        lastProposal = proposed
        secondaryExtent = SplitMath.clamp(
            proposed: proposed,
            container: containerExtent,
            minPrimary: minPrimary,
            minSecondary: minSecondary
        )
    }

    private func settle() {
        defer {
            dragStartExtent = nil
            lastProposal = nil
        }
        guard let proposal = lastProposal,
              SplitMath.shouldCollapse(
                proposed: proposal,
                minSecondary: minSecondary,
                snapFraction: WorkbenchMetrics.collapseSnapFraction
              )
        else { return }

        // Restore the pre-drag size FIRST: expand must return the pane to where
        // the user had it, not to the squashed minimum the drag left behind.
        if let start = dragStartExtent {
            secondaryExtent = start
        }
        withAnimation(.snappy) { isCollapsed = true }
    }

    private func toggleCollapsed() {
        withAnimation(.snappy) { isCollapsed.toggle() }
    }
}

#Preview("PaneSplit — dock-shaped regression lab") {
    // The U2 regression harness: the dock's structural shape with plain content.
    // The pass condition is exactly what the U2 bug violated — the bar strip and
    // the input strip BOTH stay visible, and the 200 transcript rows scroll
    // INSIDE the pane. If either vanishes, the proposal chain is broken again.
    @Previewable @State var dockExtent: CGFloat = 320
    @Previewable @State var dockCollapsed = false
    @Previewable @State var panelExtent: CGFloat = 300
    @Previewable @State var panelCollapsed = true

    PaneSplit(
        axis: .vertical,
        secondaryExtent: $dockExtent,
        isCollapsed: $dockCollapsed,
        minPrimary: 220,
        minSecondary: 180
    ) {
        Color.blue.opacity(0.08)
            .overlay(Text("editor stand-in"))
    } secondary: {
        VStack(spacing: 0) {
            HStack {
                Text("bar stand-in — must stay visible")
                Spacer()
                Button("chevron") { dockCollapsed = true }
            }
            .padding(.horizontal, 12)
            .frame(height: 32)
            Group {
                PaneSplit(
                    axis: .horizontal,
                    secondaryExtent: $panelExtent,
                    isCollapsed: $panelCollapsed,
                    minPrimary: 400,
                    minSecondary: 240,
                    collapsedExtent: 0
                ) {
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 4) {
                                ForEach(0..<200) { row in
                                    Text("transcript stand-in row \(row)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(12)
                        }
                        Divider()
                        HStack {
                            Text("input stand-in — must stay visible")
                            Spacer()
                        }
                        .padding(10)
                        .frame(height: 46)
                    }
                } secondary: {
                    Color.orange.opacity(0.15)
                        .overlay(Text("GF stand-in"))
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    .frame(width: 900, height: 640)
}
