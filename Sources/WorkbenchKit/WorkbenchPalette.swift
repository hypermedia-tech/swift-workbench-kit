import SwiftUI

/// The content layer's colours — the fills, lines, text levels and status ramp that every
/// document-shaped surface is drawn with. One source of truth, the way `WorkbenchMetrics` is one
/// source of truth for the chrome's geometry.
///
/// This is not the control layer. Toolbars, editor bars, docks and buttons are Liquid Glass and
/// take nothing from here; Apple's guidance is that glass belongs to the controls that sit over
/// content, and standard materials and fills to the content itself.
///
/// Every value is measured. Text and status tokens clear WCAG AA against every fill they are
/// allowed to sit on, including a hovered one; lines sit inside a visible-but-quiet band. The
/// suite asserts all of it, so a tuning pass that breaks a rule fails a test rather than a review.
public enum WorkbenchPalette {

    // MARK: - Fills

    /// The scroll's background. Nothing sits directly on it except a block.
    public static let ground = WorkbenchColorToken(lightHex: 0xF6F7FA, darkHex: 0x0A1020)

    /// A block's fill — the standard content surface.
    public static let block = WorkbenchColorToken(lightHex: 0xFFFFFF, darkHex: 0x101A2E)

    /// A nested region inside a block: a fold's body, an evidence area. Named for its job rather
    /// than its direction, because it steps lighter in dark and darker in light.
    public static let inset = WorkbenchColorToken(lightHex: 0xF1F3F8, darkHex: 0x1C2743)

    /// Drawn OVER a fill for a hovered or pressed row, never used as a fill of its own. Keeping it
    /// a tint is what bounds the contrast problem: there is one hover appearance per fill and the
    /// suite composites it to check them.
    public static let hoverTint = WorkbenchColorToken(
        light: WorkbenchColorValue(hex: 0x000000, alpha: 0.05),
        dark: WorkbenchColorValue(hex: 0xFFFFFF, alpha: 0.07))

    // MARK: - Lines

    /// Divides one region from another: a block's border, the rule under a block header, and rows
    /// inside an `inset` region.
    public static let hairline = WorkbenchColorToken(lightHex: 0xCFD6E4, darkHex: 0x2E3A57)

    /// Divides rows from each other inside a block. Rows are divided by lines, never by gaps.
    public static let hairlineSoft = WorkbenchColorToken(lightHex: 0xE3E7EF, darkHex: 0x222C42)

    // MARK: - Text

    /// What you read.
    public static let textPrimary = WorkbenchColorToken(lightHex: 0x131A2B, darkHex: 0xF4F7FF)

    /// Supporting prose beside it.
    public static let textSecondary = WorkbenchColorToken(lightHex: 0x4C566B, darkHex: 0xA7B0C2)

    /// The label register's colour. It goes no dimmer than this: a label is text and holds the
    /// text floor. Its recessiveness comes from width, case, weight and tracking.
    public static let textLabel = WorkbenchColorToken(lightHex: 0x5F6879, darkHex: 0x99A3B6)

    // MARK: - Action

    /// Links, and the one control a block header may carry. The brand cyan, lifted until it clears
    /// the text floor on every fill.
    public static let action = WorkbenchColorToken(lightHex: 0x07607E, darkHex: 0x3FB6DE)

    // MARK: - Status

    /// A ranked ramp, hot to cold, plus a reading for something that carries no status.
    ///
    /// Named for what a reader is being told, never for a caller's vocabulary — this package knows
    /// no product's Domain. A consumer maps its own words onto these.
    public enum Tone: String, CaseIterable, Sendable {
        case alarm, warning, caution, notice, affirm, neutral
    }

    public static let alarm = WorkbenchColorToken(lightHex: 0xC0242A, darkHex: 0xFF8589)
    public static let warning = WorkbenchColorToken(lightHex: 0x9A5410, darkHex: 0xF5A25A)
    /// An olive in light appearance rather than an amber: an amber dark enough to clear the text
    /// floor on white lands on top of `warning`, and two tones a reader cannot tell apart are one
    /// tone. Verified by `neighbouringTonesAreDistinct`.
    public static let caution = WorkbenchColorToken(lightHex: 0x6A6A18, darkHex: 0xE3BF54)

    /// The cold end of the ramp is a lavender, not a blue: a blue at this weight is the same colour
    /// as `action` to a reader, and a coloured numeral that reads as a link is a bug in the palette.
    public static let notice = WorkbenchColorToken(lightHex: 0x5A588C, darkHex: 0x9E9DC6)

    /// Resolved, fixed, passed.
    public static let affirm = WorkbenchColorToken(lightHex: 0x12764B, darkHex: 0x58C99A)

    public static func token(for tone: Tone) -> WorkbenchColorToken {
        switch tone {
        case .alarm: alarm
        case .warning: warning
        case .caution: caution
        case .notice: notice
        case .affirm: affirm
        case .neutral: textSecondary
        }
    }

    /// The call-site form: `.foregroundStyle(WorkbenchPalette.color(tone))`.
    public static func color(_ tone: Tone) -> Color { token(for: tone).color }

    // MARK: - Chips

    /// The alpha a chip's wash is drawn at. Lighter in light appearance: the ramp's light values are
    /// dark colours, and the alpha that reads as a tint over a dark fill reads as a stain over white.
    static let chipWashAlphaLight: Double = 0.08
    static let chipWashAlphaDark: Double = 0.12

    private static func makeChipWash(_ token: WorkbenchColorToken) -> WorkbenchColorToken {
        WorkbenchColorToken(
            light: WorkbenchColorValue(
                red: token.light.red, green: token.light.green, blue: token.light.blue,
                alpha: chipWashAlphaLight),
            dark: WorkbenchColorValue(
                red: token.dark.red, green: token.dark.green, blue: token.dark.blue,
                alpha: chipWashAlphaDark))
    }

    /// Built once each, like every other token in this file. `WorkbenchColorToken`'s initialiser
    /// allocates a dynamic `NSColor`, and a chip's ground is read inside a row's `body`: a list of
    /// 180 issues carrying three chips apiece would otherwise allocate on every pass.
    private static let alarmWash = makeChipWash(alarm)
    private static let warningWash = makeChipWash(warning)
    private static let cautionWash = makeChipWash(caution)
    private static let noticeWash = makeChipWash(notice)
    private static let affirmWash = makeChipWash(affirm)
    private static let neutralWash = makeChipWash(textSecondary)

    /// A chip's ground: the chip's own tone, washed back over whatever fill the chip sits on.
    ///
    /// A tint rather than an opaque fill per tone, for the reason `hoverTint` is one — a single value
    /// works over `block` and over `inset`, and the suite composites it over both to check the tone's
    /// own word still clears the text floor on it.
    ///
    /// Deliberately NOT one of `readingGrounds`: only the matching tone's word is ever drawn on a
    /// wash, so the rule that holds it is `everyToneClearsTheFloorOnItsOwnWash`.
    public static func chipWash(for tone: Tone) -> WorkbenchColorToken {
        switch tone {
        case .alarm: alarmWash
        case .warning: warningWash
        case .caution: cautionWash
        case .notice: noticeWash
        case .affirm: affirmWash
        case .neutral: neutralWash
        }
    }
}
