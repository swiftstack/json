// swift-tools-version:6.4
import PackageDescription

let package = Package(
    name: "JSON",
    platforms: [
        .iOS(.v26),
        .tvOS(.v26),
        .macOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "JSON",
            targets: ["JSON"]),
        .library(
            name: "AsyncJSON",
            targets: ["AsyncJSON"]),
    ],
    dependencies: [
        .package(
            name: "ASCII"),
        .package(
            name: "Codable"),
        .package(
            name: "Stream"),
    ],
    targets: [
        .target(
            name: "Constants",
            dependencies: [
                .product(name: "ASCII", package: "ascii"),
            ],
            swiftSettings: [
                .treatWarning("EmbeddedRestrictions", as: .error)
            ]),
        .target(
            name: "JSON",
            dependencies: [
                .target(name: "Constants"),
                .product(name: "ASCII", package: "ascii"),
                .product(name: "Codable", package: "codable"),
                .product(name: "Stream", package: "stream"),
            ],
            swiftSettings: [
                .treatWarning("EmbeddedRestrictions", as: .error)
            ]),
        .target(
            name: "AsyncJSON",
            dependencies: [
                .target(name: "JSON"),
                .product(name: "Stream", package: "stream"),
            ],
            swiftSettings: [
                .treatWarning("EmbeddedRestrictions", as: .error)
            ]),
        .testTarget(
            name: "Tests",
            dependencies: [
                .target(name: "JSON"),
                .target(name: "AsyncJSON"),
            ]),
        .executableTarget(
            name: "Benchmarks",
            dependencies: [
                .target(name: "JSON"),
            ],
            path: "./Benchmarks",
        ),
    ]
)

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
