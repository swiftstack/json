import Stream

extension Array where Element == JSON.Value {
    public static func decode(from stream: ByteArrayInputStream) throws -> Self {
        guard try stream.consume(.openBracket) else {
            throw JSON.Error.invalidJSON
        }
        var result = [JSON.Value]()
        loop: while true {
            try stream.consume(set: .whitespaces)

            switch try stream.peek() {
            case .closeBracket:
                try stream.consume(count: 1)
                break loop
            case .comma:
                try stream.consume(count: 1)
            default:
                result.append(try JSON.Value.decode(from: stream))
            }
        }
        return result
    }

    public func encode(to stream: ByteArrayOutputStream) throws {
        try stream.write(.openBracket)
        var needComma = false
        for value in self {
            switch needComma {
            case true: try stream.write(.comma)
            case false: needComma = true
            }
            try value.encode(to: stream)
        }
        try stream.write(.closeBracket)
    }
}
