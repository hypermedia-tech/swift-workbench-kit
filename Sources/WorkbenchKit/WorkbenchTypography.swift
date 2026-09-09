import CoreGraphics
import SwiftUI

/// The content layer's three registers, so a label, a number and a sentence are never argued about
/// at a call site. Plain SF throughout — no bundled font, and nothing that reads as a web page in
/// a Mac window.
public enum WorkbenchTypography {

    /// A name-of-a-thing rather than the thing: block kickers, column headers, fact labels, counts.
    /// Apply it with `labelRegister()`, which adds the case, tracking and colour that come with it.
    public static let label = Font.caption2.weight(.semibold).width(.condensed)

    /// Tracking for the label register. Condensed uppercase needs the air back.
    public static let labelTracking: CGFloat = 0.6

    /// An instrument reading. Small and dense on purpose: a row of large titles is a row of
    /// headlines competing, which is the opposite of an instrument cluster.
    public static let number = Font.title2.weight(.semibold).monospaced()

    /// A block's name, in its header.
    public static let blockTitle = Font.headline

    /// A fact row's value. Tabular figures so a column of them lines up.
    public static let value = Font.callout.monospacedDigit()

    /// Prose you read.
    public static let reading = Font.body

    /// Prose beside it.
    public static let supporting = Font.callout
}
