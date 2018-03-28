import Stream

extension JSON.Value {
    public init(from stream: StreamReader) throws {
        try stream.consume(set: .whitespaces)

        func ensureValue(_ value: [UInt8]) throws {
            guard try stream.consume(sequence: value) else {
                throw JSON.Error.invalidJSON
            }
        }

        switch try stream.peek() {
        case .curlyBracketOpen:
            self = .object(try [String : JSON.Value](from: stream))

        case .bracketOpen:
            self = .array(try [JSON.Value](from: stream))

        case .n:
            try ensureValue(.null)
            self = .null

        case .t:
            try ensureValue(.true)
            self = .bool(true)

        case .f:
            try ensureValue(.false)
            self = .bool(false)

        case (.zero)...(.nine), .hyphen:
            self = .number(try Number(from: stream))

        case .quote:
            self = .string(try String(from: stream))

        default:
            throw JSON.Error.invalidJSON
        }
    }
}

extension JSON.Value: Equatable {
    public static func ==(lhs: JSON.Value, rhs: JSON.Value) -> Bool {
        switch (lhs, rhs) {
        case (.null, .null): return true
        case let (.bool(lhs), .bool(rhs)): return lhs == rhs
        case let (.number(lhs), .number(rhs)): return lhs == rhs
        case let (.string(lhs), .string(rhs)): return lhs == rhs
        case let (.array(lhs), .array(rhs)): return lhs == rhs
        case let (.object(lhs), .object(rhs)): return lhs == rhs
        default: return false
        }
    }
}

extension JSON.Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .null: return "null"
        case .bool(let value): return value.description
        case .number(let value): return value.description
        case .string(let value): return "\"\(value)\""
        case .array(let value): return value.description
        case .object(let value): return value.description
        }
    }
}
