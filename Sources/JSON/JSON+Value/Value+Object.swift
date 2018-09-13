import Stream

extension Dictionary where Key == String, Value == JSON.Value {
    public init(from stream: StreamReader) throws {
        guard try stream.consume(.curlyBracketOpen) else {
            throw JSON.Error.invalidJSON
        }

        var result = [String : JSON.Value]()
        loop: while true {
            try stream.consume(set: .whitespaces)

            switch try stream.peek() {
            case .curlyBracketClose:
                try stream.consume(count: 1)
                break loop
            case .doubleQuote:
                let key = try String(from: stream)
                try stream.consume(set: .whitespaces)
                guard try stream.consume(.colon) else {
                    throw JSON.Error.invalidJSON
                }
                try stream.consume(set: .whitespaces)
                result[key] = try JSON.Value(from: stream)
            case .comma:
                try stream.consume(count: 1)
            default:
                throw JSON.Error.invalidJSON
            }
        }
        self = result
    }

    public func encode(to stream: StreamWriter) throws {
        try stream.write(.curlyBracketOpen)
        for (key, value) in self {
            try stream.write(.doubleQuote)
            try stream.write(key)
            try stream.write(.doubleQuote)
            try stream.write(.colon)
            try value.encode(to: stream)
        }
        try stream.write(.curlyBracketClose)
    }
}
