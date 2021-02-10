import Stream

extension Array where Element == JSON.Value {
    public static func decode(from stream: StreamReader) async throws -> Self {
        guard try await stream.consume(.squareBracketOpen) else {
            throw JSON.Error.invalidJSON
        }
        var result = [JSON.Value]()
        loop: while true {
            try await stream.consume(set: .whitespaces)

            switch try await stream.peek() {
            case .squareBracketClose:
                try await stream.consume(count: 1)
                break loop
            case .comma:
                try await stream.consume(count: 1)
            default:
                result.append(try await JSON.Value.decode(from: stream))
            }
        }
        return result
    }

    public func encode(to stream: StreamWriter) async throws {
        try await stream.write(.squareBracketOpen)
        var needComma = false
        for value in self {
            switch needComma {
            case true: try await stream.write(.comma)
            case false: needComma = true
            }
            try await value.encode(to: stream)
        }
        try await stream.write(.squareBracketClose)
    }
}
