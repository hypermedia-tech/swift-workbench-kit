import Foundation

/// One appearance's value for a palette token: straight sRGB components, and the alpha a tint is
/// drawn at. Opaque by default — only a tint carries an alpha below 1.
///
/// Deliberately not a `Color`. The palette's design rules are contrast rules, and contrast is
/// arithmetic on components; keeping the numbers is what lets `WorkbenchContrast` check them and
/// the gallery show them.
///
/// `nonisolated` for the same reason `SplitMath` is: it is pure arithmetic over immutable values,
/// and the module's default isolation would otherwise put it out of reach of any caller that is
/// not on the main actor.
nonisolated public struct WorkbenchColorValue: Sendable, Equatable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    /// `0xRRGGBB` — the form the design document states its values in, so a token in code and a
    /// line in the document can be compared by eye.
    public init(hex: UInt32, alpha: Double = 1) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            alpha: alpha)
    }

    /// `RRGGBB`, for a gallery label. Alpha is not part of it.
    public var hexDescription: String {
        String(format: "%02X%02X%02X",
               Int((red * 255).rounded()), Int((green * 255).rounded()), Int((blue * 255).rounded()))
    }

    /// WCAG 2.1 relative luminance. Meaningful for an opaque value; composite a tint first.
    public var relativeLuminance: Double {
        func linear(_ channel: Double) -> Double {
            channel <= 0.03928 ? channel / 12.92 : pow((channel + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linear(red) + 0.7152 * linear(green) + 0.0722 * linear(blue)
    }

    /// Hue in degrees, 0..<360; 0 for a grey. The status ramp is kept apart from the action colour
    /// by hue, because two colours can share a contrast ratio and still be the same colour.
    public var hueDegrees: Double {
        let high = max(red, green, blue)
        let low = min(red, green, blue)
        let span = high - low
        guard span > 0 else { return 0 }
        let sextant: Double
        if high == red {
            sextant = (green - blue) / span
        } else if high == green {
            sextant = 2 + (blue - red) / span
        } else {
            sextant = 4 + (red - green) / span
        }
        let degrees = sextant * 60
        return degrees < 0 ? degrees + 360 : degrees
    }

    /// This value drawn source-over an opaque backdrop. The result is opaque, which is what makes a
    /// hovered row's contrast checkable.
    public func composited(over backdrop: WorkbenchColorValue) -> WorkbenchColorValue {
        WorkbenchColorValue(
            red: red * alpha + backdrop.red * (1 - alpha),
            green: green * alpha + backdrop.green * (1 - alpha),
            blue: blue * alpha + backdrop.blue * (1 - alpha))
    }
}
