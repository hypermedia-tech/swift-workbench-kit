import SwiftUI

/// A fold's closed line when it names itself with words: the title in the label register, and the
/// count that rides in it.
///
/// Its own type rather than a `Text` the fold styles, because `WorkbenchBlockFold` is generic over
/// its label and a generic parameter cannot be the opaque type `.labelRegister()` returns. Being a
/// type also means a caller building a richer closed line can set part of it in the same register
/// without restating the modifier.
public struct WorkbenchFoldTitle: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .labelRegister()
    }
}
