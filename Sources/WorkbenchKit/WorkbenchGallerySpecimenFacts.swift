import Foundation

/// The five facts every block specimen is drawn with, so two specimens compared side by side
/// differ only in the thing under test.
nonisolated enum WorkbenchGallerySpecimenFacts {
    static let five: [WorkbenchFact] = [
        .init(label: "Scanner", value: "Trivy 0.58.1"),
        .init(label: "Scanned", value: "9 September 2026, 14:02"),
        .init(label: "Target", value: "my-awesome-docker-image:2.3.0"),
        .init(label: "Digest", value: "a3c9f1e4b7d2"),
        .init(label: "Result", value: "3 critical", tone: .alarm)
    ]
}
