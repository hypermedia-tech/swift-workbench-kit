import AppKit
import SwiftUI

/// A palette entry: the value for each appearance, and the `Color` that picks between them.
///
/// The pick happens inside a dynamic `NSColor`, so nothing has to be threaded through the
/// environment for light and dark to be right, and Increase Contrast rides on the system's own
/// appearance matching.
public struct WorkbenchColorToken: Sendable {
    public let light: WorkbenchColorValue
    public let dark: WorkbenchColorValue

    /// Built once, at token construction. `Color` is a value; the dynamic `NSColor` behind it
    /// resolves per appearance every time it is drawn.
    public let color: Color

    public init(light: WorkbenchColorValue, dark: WorkbenchColorValue) {
        self.light = light
        self.dark = dark
        self.color = Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
                ? NSColor(dark)
                : NSColor(light)
        })
    }

    /// The common case: one opaque hex per appearance.
    public init(lightHex: UInt32, darkHex: UInt32) {
        self.init(light: WorkbenchColorValue(hex: lightHex), dark: WorkbenchColorValue(hex: darkHex))
    }

    /// The value this token resolves to in a given scheme — what the suite and the gallery read.
    public func value(for scheme: ColorScheme) -> WorkbenchColorValue {
        scheme == .dark ? dark : light
    }
}

extension NSColor {
    /// `nonisolated` because the caller is an Objective-C block that AppKit invokes when it
    /// resolves the colour, not necessarily on the main actor. The block is imported unannotated,
    /// so the compiler cannot police that boundary — this marking is the guarantee instead, and it
    /// costs nothing: the initialiser reads only immutable value components.
    fileprivate nonisolated convenience init(_ value: WorkbenchColorValue) {
        self.init(srgbRed: value.red, green: value.green, blue: value.blue, alpha: value.alpha)
    }
}
