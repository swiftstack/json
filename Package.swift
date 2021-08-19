// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "JSON",
    products: [
        .library(
            name: "JSON",
            targets: ["JSON"])
    ],
    dependencies: [
        .package(name: "Platform"),
        .package(name: "Codable"),
        .package(name: "Stream"),
        .package(name: "Test")
    ],
    targets: [
        .target(
            name: "JSON",
            dependencies: ["Platform", "Codable", "Stream"]),
        .testTarget(
            name: "JSONTests",
            dependencies: ["JSON", "Test"]),
        .testTarget(
            name: "JSONCodableTests",
            dependencies: ["JSON", "Test"])
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
            : .package(name: name, url: source.url(for: name), .branch("fiber"))
    }
}
