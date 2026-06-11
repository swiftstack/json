import Foundation

func measure(
    name: StaticString,
    duration: Duration,
    _ task: () async -> Void
) async {
    var now = ContinuousClock.now
    var outerIterations = 0
    let start = ContinuousClock.now
    repeat {
        await task()
        outerIterations += 1
        now = .now
    } while (start.duration(to: now) < duration)
    let elapsed = start.duration(to: now)
    let seconds = Double(elapsed.components.seconds) +
    Double(elapsed.components.attoseconds) / 1e18
    let throughput = Double(outerIterations) / seconds
    print("\(name): \(Int(throughput)) ops/s")
}

@inline(never)
func blackHole<T>(_ value: T) {
    _ = value
}

// MARK: async versions

func encode<T: Encodable>(_ value: T) async throws -> Data {
    try JSONEncoder().encode(model)
}

func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T {
    try JSONDecoder().decode(T.self, from: data)
}
