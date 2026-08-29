import SwiftUI

/// The grab-and-drag divider between a PaneSplit's panes: a 1pt hairline centered
/// in a wider invisible hit strip, with the macOS resize pointer on hover.
/// Dumb by design, all geometry lives in PaneSplit; this view reports gestures.
public struct SplitDivider: View {
    private let axis: Axis
    private let onDrag: (CGSize) -> Void
    private let onDragEnded: () -> Void
    private let onDoubleTap: () -> Void
    
    public init(
        axis: Axis,
        onDrag: @escaping (CGSize) -> Void,
        onDragEnded: @escaping () -> Void,
        onDoubleTap: @escaping () -> Void
    ) {
        self.axis = axis
        self.onDrag = onDrag
        self.onDragEnded = onDragEnded
        self.onDoubleTap = onDoubleTap
    }
    
    public var body: some View {
        Color.clear
            .frame(
                width: axis == .horizontal ? WorkbenchMetrics.dividerGrabExtent : nil,
                height: axis == .vertical ? WorkbenchMetrics.dividerGrabExtent : nil
            )
            .overlay {
                Rectangle()
                    .fill(.separator)
                    .frame(
                        width: axis == .horizontal ? 1 : nil,
                        height: axis == .vertical ? 1 : nil
                    )
            }
            .contentShape(Rectangle())
            .pointerStyle(axis == .vertical ? .rowResize : .columnResize)
            .onTapGesture(count: 2, perform: onDoubleTap)
            .gesture(drag)
            .accessibilityElement()
            .accessibilityLabel("Pane divider")
            .accessibilityHint("Drag to resize. Double-click to collapse.")
            .accessibilityAddTraits(.isButton)
            .accessibilityAdjustableAction { direction in
                // One keyboard/VoiceOver increment = one 20pt drag step toward
                // grow (.increment) or shrink (.decrement) of the secondary pane.
                switch direction {
                case .increment: onDrag(CGSize(width: -20, height: -20))
                case .decrement: onDrag(CGSize(width: 20, height: 20))
                @unknown default: break
                }
                onDragEnded()
            }
    }
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged { onDrag($0.translation) }
            .onEnded { _ in onDragEnded() }
    }
}
