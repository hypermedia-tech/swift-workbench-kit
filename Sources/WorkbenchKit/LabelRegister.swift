import SwiftUI

/// The label register as one modifier — font, case, tracking and colour together — because half of
/// it is worse than none: uppercased text without the tracking sets tight, and the condensed face
/// without the dim colour competes with the value it labels.
public struct LabelRegister: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .font(WorkbenchTypography.label)
            .textCase(.uppercase)
            .tracking(WorkbenchTypography.labelTracking)
            .foregroundStyle(WorkbenchPalette.textLabel.color)
    }
}

extension View {
    /// Sets this text in the content layer's label register.
    public func labelRegister() -> some View { modifier(LabelRegister()) }
}
