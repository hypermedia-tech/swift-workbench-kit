import CoreGraphics

/// Shared geometry for the workbench chrome — one source of truth so every
/// column, and every consuming app, agrees on the same band.
public enum WorkbenchMetrics {
    /// Committed height of a header band: toolbar-bottom → content-start line.
    /// A `minHeight`, so it holds for normal content but grows (not clips)
    /// under larger Dynamic Type.
    public static let bandHeight: CGFloat = 34
    
    /// Horizontal inset for a bar's content within its band
    public static let bandHInset: CGFloat = 8

    /// Leading inset for a DETAIL pane's editor bar — wider than `bandHInset` so the bar's first
    /// control clears the split edge. The deployed value, lifted from the case pane's own bar.
    public static let editorBarLeadingInset: CGFloat = 16

    /// Gap between an editor bar's regions (identity, controls). The deployed value from the case
    /// pane's row.
    public static let editorBarSpacing: CGFloat = 8

    /// Gap between individual controls INSIDE an editor bar's trailing cluster — wider than the
    /// region gap, because these are bare icons with no border to separate them. The deployed
    /// value from the case pane's button cluster.
    public static let editorBarControlSpacing: CGFloat = 14
    
    // MARK: - Pane splits (U1)
    
    /// Total hit-target thickness of a split divider; the visible hairline is
    /// 1pt, centered. Wide enough to grab, thin enough to read as a gutter.
    public static let dividerGrabExtent: CGFloat = 9
    
    /// The always-visible collapsed strip, the Xcode debug-bar grammar. Matches
    /// the dock header's 32pt bar so a collapsed dock IS its ribbon.
    public static let ribbonHeight: CGFloat = 32
    
    /// Default pane minimums. Defaults only, each surface picks its own at call site
    public static let minPrimaryPane: CGFloat = 160
    public static let minSecondaryPane: CGFloat = 120
    
    /// A drag released below `minSecondary × this` snaps the pane collapsed.
    public static let collapseSnapFraction: CGFloat = 0.5
    
    // MARK: - History rows

    /// Diameter of a `HistoryRow`'s leading `AvatarCircle`.
    public static let avatarSize: CGFloat = 28
    
    // MARK: - Detail popover
    
    /// Fixed width of a `HistoryDetailPopover` (Xcode's actions card is a comfortable fixed width).
    public static let detailPopoverWidth: CGFloat = 320

    /// Max height of the popover's scrollable body region before it scrolls (bounds a long body so
    /// the popover can't grow without limit).
    public static let detailPopoverBodyMaxHeight: CGFloat = 240
    
    // MARK: - Content-layer blocks (LOOK)

    /// Corner radius of a block. The reference page uses five; six is what the one bordered block
    /// already in the estate uses, and matching it costs nothing.
    public static let blockCornerRadius: CGFloat = 6

    /// Corner radius of a region nested inside a block — a fold's body, an evidence area.
    public static let insetCornerRadius: CGFloat = 4

    /// A separator's thickness. One POINT, not one pixel: a pixel line lands unevenly between grid
    /// cells at Retina scale, and the cell grid is where hairlines do the most work.
    public static let hairlineWidth: CGFloat = 1

    /// Horizontal inset for content inside a block.
    public static let blockHInset: CGFloat = 12

    /// Vertical inset for a row inside a block, and for a block header.
    public static let blockRowVInset: CGFloat = 10

    /// Gap between blocks on the ground. Matches `blockHInset`, so the gutter round a block reads
    /// square rather than accidental.
    public static let blockSpacing: CGFloat = 12

    /// Width of the label column in a fact row that cannot use `WorkbenchFactRows`.
    ///
    /// `WorkbenchFactRows` gets its alignment from a `Grid`, which builds every row — right for a
    /// block of five facts and wrong for a fold holding a package inventory, where the rows must
    /// stay lazy. A lazily-realised row cannot know how wide the widest label is, so it is given a
    /// column instead. Labels wrap inside it rather than truncating.
    public static let factLabelWidth: CGFloat = 168

    /// Narrowest a cell in a hairline-divided cell grid may be before the grid drops a column.
    /// Wider than the reference page's 112 because Mac text is larger.
    public static let cellMinWidth: CGFloat = 120

    // MARK: - Chips

    /// Horizontal padding inside a chip. Narrower than `blockHInset`, because a chip is a word and
    /// not a region: padded to a block's inset it reads as a button.
    public static let chipHInset: CGFloat = 6

    /// Vertical padding inside a chip. Small enough that a row of chips does not set the row's
    /// height — the title does.
    public static let chipVInset: CGFloat = 2

    /// A chip's corner radius. Smaller than `insetCornerRadius` in proportion to the chip, so the
    /// corner reads the same at the chip's size as a fold's does at a fold's.
    public static let chipCornerRadius: CGFloat = 3
}
