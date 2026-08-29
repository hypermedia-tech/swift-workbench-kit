import Foundation

/// One segment in a `SelectorBar`: an SF Symbol and the value it selects.
/// `Tag` is whatever the consumer binds to — an enum, String, Int, …
public struct SelectorSegment<Tag: Hashable>: Identifiable {
    public let tag: Tag
    public let systemImage: String
    public let label: String // VoiceOver label + tooltip; never drawn when icon-only
    
    public var id: Tag { tag }
    
    public init(tag: Tag, systemImage: String, label: String) {
        self.tag = tag
        self.systemImage = systemImage
        self.label = label
    }
}

extension SelectorSegment: Sendable where Tag: Sendable {}
