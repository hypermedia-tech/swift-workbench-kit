import SwiftUI

/// A compact, TOP-ALIGNED empty state for an inspector column. Deliberately NOT
/// `ContentUnavailableView` + `fixedSize`: that floors the window's min content height at ~928pt
/// (measured with the chromeprobe harness) so the window can't shrink. This compact stack stays
/// compressible (~89pt floor) — the window shrinks freely — and sits at the top of the column
/// instead of floating in the centre.
public struct InspectorEmptyState: View {
    private let title: String
    private let systemImage: String
    private let message: String

    public init(title: String, systemImage: String, message: String) {
        self.title = title
        self.systemImage = systemImage
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 34))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 32)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
