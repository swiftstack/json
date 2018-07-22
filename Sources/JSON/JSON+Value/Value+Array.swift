import Stream

extension Array where Element == JSON.Value {
    public init(from stream: StreamReader) throws {
        guard try stream.consume(.squareBracketOpen) else {
            throw JSON.Error.invalidJSON
        }
        var result = [JSON.Value]()
        loop: while true {
            try stream.consume(set: .whitespaces)

            switch try stream.peek() {
            case .squareBracketClose:
                try stream.consume(count: 1)
                break loop
            case .comma:
                try stream.consume(count: 1)
            default:
                result.append(try JSON.Value(from: stream))
            }
        }
        self = result
    }

    public func encode(to stream: StreamWriter) throws {
        try stream.write(.squareBracketOpen)
        var needComma = false
        for value in self {
            switch needComma {
            case true: try stream.write(.comma)
            case false: needComma = true
            }
            try value.encode(to: stream)
        }
        try stream.write(.squareBracketClose)
    }
}
