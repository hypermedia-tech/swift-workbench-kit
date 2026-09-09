import Foundation

/// WCAG 2.1 contrast, so the palette's rules are arithmetic rather than opinion. The gallery shows
/// these numbers beside every swatch and the suite asserts them, which is the whole reason the
/// palette keeps components rather than only `Color`s.
nonisolated public enum WorkbenchContrast {
    /// The floor for text at the sizes this palette uses. WCAG AA for normal text.
    public static let textFloor: Double = 4.5

    /// A separator has to be seen and must not shout. Below the floor it disappears on its fill;
    /// above the ceiling it reads as a border where a division was meant.
    public static let lineFloor: Double = 1.15
    public static let lineCeiling: Double = 1.75

    /// Ratio between two opaque values, 1...21. Order does not matter.
    public static func ratio(_ one: WorkbenchColorValue, _ other: WorkbenchColorValue) -> Double {
        let a = one.relativeLuminance
        let b = other.relativeLuminance
        return (max(a, b) + 0.05) / (min(a, b) + 0.05)
    }

    /// Shortest way round the hue circle, 0...180.
    public static func hueSeparation(_ one: WorkbenchColorValue, _ other: WorkbenchColorValue) -> Double {
        let gap = abs(one.hueDegrees - other.hueDegrees)
        return min(gap, 360 - gap)
    }
}
