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
}
