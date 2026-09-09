import SwiftUI

/// One named token in a gallery section.
public struct WorkbenchGalleryEntry: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let token: WorkbenchColorToken

    public init(name: String, token: WorkbenchColorToken) {
        self.id = name
        self.name = name
        self.token = token
    }
}
