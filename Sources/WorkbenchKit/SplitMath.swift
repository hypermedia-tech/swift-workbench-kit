import CoreGraphics

/// Pure geometry for PaneSplit: clamp a proposed secondary-pane
/// extent and decide snap-to-collapse.
nonisolated public enum SplitMath {
    /// Clamp a proposed secondary extent into [minSecondary, container − minPrimary].
    /// A container too small to honour both minimums resolves in the primary's
    /// favour: the ceiling never drops below minSecondary, so the secondary pins
    /// there and the primary takes what remains.
    public static func clamp(
        proposed: CGFloat,
        container: CGFloat,
        minPrimary: CGFloat,
        minSecondary: CGFloat
    ) -> CGFloat {
        let ceiling = max(minSecondary, container - minPrimary)
        return min(max(proposed, minSecondary), ceiling)
    }
    
    /// True when a drag's final (unclamped) proposal has gone far enough below the
    /// secondary minimum that release should collapse the pane rather than pin it.
    public static func shouldCollapse(
        proposed: CGFloat,
        minSecondary: CGFloat,
        snapFraction: CGFloat
    ) -> Bool {
        proposed < minSecondary * snapFraction
    }
}
