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
        .package(name: "Platform"),
        .package(name: "Codable"),
        .package(name: "Stream"),
        .package(name: "Test"),
    ],
    targets: [
        .target(
            name: "JSON",
            dependencies: [
                .product(name: "Platform", package: "platform"),
                .product(name: "Codable", package: "codable"),
                .product(name: "Stream", package: "stream"),
            ]),
    ]
)

// MARK: - tests

testTarget("Codable") { test in
    test("Decoder")
    test("Encoder")
    test("JSON.decode")
    test("JSON.encode")
    test("ScopedCoders")
    test("UnkeyedDecodingContainer")
    test("UnkeyedEncodingContainer")
}

testTarget("JSON") { test in
    test("Value")
    test("Value+DynamicLookup")
    test("Value+InputStream")
    test("Value+OutputStream")
}

func testTarget(_ target: String, task: ((String) -> Void) -> Void) {
    task { test in addTest(target: target, name: test) }
}

func addTest(target: String, name: String) {
    package.targets.append(
        .executableTarget(
            name: "Tests/\(target)/\(name)",
            dependencies: [
                .target(name: "JSON"),
                .product(name: "Stream", package: "stream"),
                .product(name: "Test", package: "test"),
            ],
            path: "Tests/\(target)/\(name)"))
}

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
