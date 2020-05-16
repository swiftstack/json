// swift-tools-version:5.2
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
            url: "https://github.com/swift-stack/codable.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/stream.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/test.git",
            .branch("master")),
    ],
    targets: [
        .target(
            name: "JSON", 
            dependencies: ["Platform", "Codable", "Stream"]),
        .testTarget(
            name: "JSONTests", 
            dependencies: ["JSON", "Test"])
    ]
)
