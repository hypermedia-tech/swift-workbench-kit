import SwiftUI

public struct AvatarCircle: View {
    public enum Content: Sendable {
        case symbol(String)
        case monogram(String)   // initials derived from a name
    }
    
    private let content: Content
    private let tint: Color
    
    public init(symbol: String, tint: Color) {
        self.content = .symbol(symbol)
        self.tint = tint
    }
    
    public init(monogram name: String, tint: Color) {
        self.content = .monogram(name)
        self.tint = tint
    }
    
    public var body: some View {
        Circle()
            .fill(tint.gradient)
            .frame(width: WorkbenchMetrics.avatarSize, height: WorkbenchMetrics.avatarSize)
            .overlay {
                switch content {
                case let .symbol(name):
                    Image(systemName: name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                case let .monogram(name):
                    Text(Self.initials(of: name))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .accessibilityHidden(true)
    }
    
    /// Up-to-two uppercased leading initials from a name — the git consumer's author monogram
    /// (§0). `internal static` so it is a pure, testable seam (no `AvatarCircle` instance needed).
    static func initials(of name: String) -> String {
        name.split(separator: " ").prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
    }
}
