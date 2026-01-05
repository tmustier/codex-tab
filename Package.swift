// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodexTab",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "CodexTabCore",
            targets: ["CodexTabCore"]
        ),
        .executable(
            name: "codex-tab",
            targets: ["CodexTabCLI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CodexTabCore"
        ),
        .executableTarget(
            name: "CodexTabCLI",
            dependencies: ["CodexTabCore"]
        ),
        .testTarget(
            name: "CodexTabCoreTests",
            dependencies: [
                "CodexTabCore",
            ]
        ),
    ]
)
