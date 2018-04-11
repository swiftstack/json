// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "JSON",
    products: [
        .library(name: "JSON", targets: ["JSON"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-stack/platform.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/stream.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/test.git",
            .branch("master")),
    ],
    targets: [
        .target(name: "JSON", dependencies: ["Platform", "Stream"]),
        .testTarget(name: "JSONTests", dependencies: ["JSON", "Test"])
    ]
)
