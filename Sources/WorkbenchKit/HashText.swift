import SwiftUI

/// A labelled hash, abbreviated for a row and complete on hover: the first twelve characters in
/// monospace, with the algorithm and the full digest in the tooltip.
///
/// Takes two strings rather than a digest type on purpose — this is chrome, and the kit stays
/// Domain-free so the same chip can carry an evidence content hash today and a commit SHA when the
/// git view lands. Naming the algorithm is not decoration: an unlabelled hex string is not a
/// verifiable claim, and every hash this platform shows is labelled.
public struct HashText: View {
    private let algorithm: String
    private let hex: String

    private let visibleCharacters = 12

    public init(algorithm: String, hex: String) {
        self.algorithm = algorithm
        self.hex = hex
    }

    public var body: some View {
        Text(abbreviated)
            .font(.system(.body, design: .monospaced))
            .foregroundStyle(.secondary)
            .help("\(algorithm) \(hex)")
    }

    private var abbreviated: String {
        hex.count > visibleCharacters ? "\(hex.prefix(visibleCharacters)).." : hex
    }
}
