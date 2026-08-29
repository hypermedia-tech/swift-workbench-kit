// swift-tools-version: 6.2
import PackageDescription

let package = Package(
	name: "WorkbenchKit",
	platforms: [.macOS(.v26)],
	products: [
		.library(name: "WorkbenchKit", targets: ["WorkbenchKit"])
	],
    targets: [
        .target(
            name: "WorkbenchKit",
            swiftSettings: [
                // Match the framework target's existing convention: the
                // whole module is MainActor-isolated by default; explicit
                // `nonisolated` opts out for background/compute paths.
                // SE-0466 (Swift 6.2) makes this declarative in the manifest
                // rather than per-type.
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
            ]
        ),
        .testTarget(
            name: "WorkbenchKitTests",
            dependencies: ["WorkbenchKit"],
            swiftSettings: [
                // Same isolation semantics as the library target, so tests
                // touching MainActor kit types compile without surprises.
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
            ]
        )
    ]
)
