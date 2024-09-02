// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "JSON",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "JSON",
            targets: ["JSON"]),
    ],
    dependencies: [
        .package(
            name: "Platform"),
        .package(
            name: "Codable"),
        .package(
            name: "Stream"),
        .package(
            url: "https://github.com/apple/swift-testing.git",
            from: "0.12.0"),
    ],
    targets: [
        .target(
            name: "JSON",
            dependencies: [
                .product(name: "Platform", package: "platform"),
                .product(name: "Codable", package: "codable"),
                .product(name: "Stream", package: "stream"),
            ],
            swiftSettings: swift6),
        .testTarget(
            name: "Tests",
            dependencies: [
                .target(name: "JSON"),
                .product(name: "Stream", package: "stream"),
                .product(name: "Testing", package: "swift-testing"),
            ]),
    ]
)

let swift6: [SwiftSetting] = [
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("StrictConcurrency"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("BareSlashRegexLiterals"),
]

// MARK: - custom package source

#if canImport(ObjectiveC)
import Darwin.C
#else
import Glibc
#endif

extension Package.Dependency {
    enum Source: String {
        case local, remote, github

        static var `default`: Self { .github }

        var baseUrl: String {
            switch self {
            case .local: return "../"
            case .remote: return "https://swiftstack.io/"
            case .github: return "https://github.com/swiftstack/"
            }
        }

        func url(for name: String) -> String {
            return self == .local
                ? baseUrl + name.lowercased()
                : baseUrl + name.lowercased() + ".git"
        }
    }

    static func package(name: String) -> Package.Dependency {
        guard let pointer = getenv("SWIFTSTACK") else {
            return .package(name: name, source: .default)
        }
        guard let source = Source(rawValue: String(cString: pointer)) else {
            fatalError("Invalid source. Use local, remote or github")
        }
        return .package(name: name, source: source)
    }

    static func package(name: String, source: Source) -> Package.Dependency {
        return source == .local
            ? .package(name: name, path: source.url(for: name))
            : .package(url: source.url(for: name), branch: "dev")
    }
}
