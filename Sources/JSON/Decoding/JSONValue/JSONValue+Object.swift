import Stream

extension Dictionary where Key == String, Value == JSONValue {
    public init<T: StreamReader>(from stream: T) throws {
        guard try stream.consume(.curlyBracketOpen) else {
            throw JSONError.invalidJSON
        }

        var result = [String : JSONValue]()
        loop: while true {
            try stream.consume(set: .whitespaces)

            switch try stream.peek() {
            case .curlyBracketClose:
                try stream.consume(count: 1)
                break loop
            case .quote:
                let key = try String(from: stream)
                try stream.consume(set: .whitespaces)
                guard try stream.consume(.colon) else {
                    throw JSONError.invalidJSON
                }
                try stream.consume(set: .whitespaces)
                result[key] = try JSONValue(from: stream)
            case .comma:
                try stream.consume(count: 1)
            default:
                throw JSONError.invalidJSON
            }
        }
        self = result
    }
}
