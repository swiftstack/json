import Stream

extension Dictionary where Key == String, Value == JSON.Value {
    public static func decode(from stream: StreamReader) async throws -> Self {
        guard try await stream.consume(.curlyBracketOpen) else {
            throw JSON.Error.invalidJSON
        }

        var result = [String : JSON.Value]()
        loop: while true {
            try await stream.consume(set: .whitespaces)

            switch try await stream.peek() {
            case .curlyBracketClose:
                try await stream.consume(count: 1)
                break loop
            case .doubleQuote:
                let key = try await String.decode(from: stream)
                try await stream.consume(set: .whitespaces)
                guard try await stream.consume(.colon) else {
                    throw JSON.Error.invalidJSON
                }
                try await stream.consume(set: .whitespaces)
                result[key] = try await JSON.Value.decode(from: stream)
            case .comma:
                try await stream.consume(count: 1)
            default:
                throw JSON.Error.invalidJSON
            }
        }
        return result
    }

    public func encode(to stream: StreamWriter) async throws {
        try await stream.write(.curlyBracketOpen)
        for (key, value) in self {
            try await stream.write(.doubleQuote)
            try await stream.write(key)
            try await stream.write(.doubleQuote)
            try await stream.write(.colon)
            try await value.encode(to: stream)
        }
        try await stream.write(.curlyBracketClose)
    }
}
