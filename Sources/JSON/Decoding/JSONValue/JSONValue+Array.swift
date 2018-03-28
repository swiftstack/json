import Stream

extension Array where Element == JSONValue {
    public init<T: StreamReader>(from stream: T) throws {
        guard try stream.consume(.bracketOpen) else {
            throw JSONError.invalidJSON
        }
        var result = [JSONValue]()
        loop: while true {
            try stream.consume(set: .whitespace)

            switch try stream.peek() {
            case .bracketClose:
                try stream.consume(count: 1)
                break loop
            case .comma:
                try stream.consume(count: 1)
            default:
                result.append(try JSONValue(from: stream))
            }
        }
        self = result
    }
}
