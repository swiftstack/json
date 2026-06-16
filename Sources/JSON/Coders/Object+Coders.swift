import Stream

extension Dictionary where Key == String, Value == JSON.Value {
    public static func decode(from stream: MemoryStream) throws -> Self {
        guard try stream.consume(.openBrace) else {
            throw JSON.Error.invalidJSON
        }

        var result = [String: JSON.Value]()
        loop: while true {
            try stream.consume(set: .whitespaces)

            switch try stream.peek() {
            case .closeBrace:
                try stream.consume(count: 1)
                break loop
            case .quote:
                let key = try String.decode(from: stream)
                try stream.consume(set: .whitespaces)
                guard try stream.consume(.colon) else {
                    throw JSON.Error.invalidJSON
                }
                try stream.consume(set: .whitespaces)
                result[key] = try JSON.Value.decode(from: stream)
            case .comma:
                try stream.consume(count: 1)
            default:
                throw JSON.Error.invalidJSON
            }
        }
        return result
    }

    public func encode(to stream: MemoryStream) throws {
        try stream.write(.openBrace)
        for (key, value) in self {
            try stream.write(.quote)
            try stream.write(key)
            try stream.write(.quote)
            try stream.write(.colon)
            try value.encode(to: stream)
        }
        try stream.write(.closeBrace)
    }
}
