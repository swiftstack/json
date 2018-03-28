import Stream

extension Array where Element == JSON.Value {
    public init<T: StreamReader>(from stream: T) throws {
        guard try stream.consume(.bracketOpen) else {
            throw JSON.Error.invalidJSON
        }
        var result = [JSON.Value]()
        loop: while true {
            try stream.consume(set: .whitespaces)

            switch try stream.peek() {
            case .bracketClose:
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
}
