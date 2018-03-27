import Stream

public enum JSONValue {
    case null
    case bool(Bool)
    case number(Number)
    case string(String)
    case array([JSONValue])
    case object([String : JSONValue])
}

extension JSONValue {
    init<T: StreamReader>(from stream: T) throws {
        try stream.consume(set: .whitespace)

        func ensureValue(_ value: [UInt8]) throws {
            guard try stream.consume(sequence: value) else {
                throw JSONError.invalidJSON
            }
        }

        switch try stream.peek() {
        case .curlyBracketOpen:
            self = .object(try [String : JSONValue](from: stream))

        case .bracketOpen:
            self = .array(try [JSONValue](from: stream))

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
            throw JSONError.invalidJSON
        }
    }
}

extension JSONValue: Equatable {
    public static func ==(lhs: JSONValue, rhs: JSONValue) -> Bool {
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

extension JSONValue: CustomStringConvertible {
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
