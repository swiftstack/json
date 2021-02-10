import Stream

extension JSON.Value {
    public static func decode(from stream: StreamReader) async throws -> Self {
        try await stream.consume(set: .whitespaces)

        func consume(_ value: [UInt8]) async throws {
            guard try await stream.consume(sequence: value) else {
                throw JSON.Error.invalidJSON
            }
        }

        switch try await stream.peek() {
        case .curlyBracketOpen:
            return .object(try await [String : JSON.Value].decode(from: stream))

        case .squareBracketOpen:
            return .array(try await [JSON.Value].decode(from: stream))

        case .n:
            try await consume(.null)
            return .null

        case .t:
            try await consume(.true)
            return .bool(true)

        case .f:
            try await consume(.false)
            return .bool(false)

        case (.zero)...(.nine), .hyphen:
            return .number(try await Number.decode(from: stream))

        case .doubleQuote:
            return .string(try await String.decode(from: stream))

        default:
            throw JSON.Error.invalidJSON
        }
    }

    public func encode(to stream: StreamWriter) async throws {
        switch self {
        case .null:
            try await stream.write(.null)
        case .bool(let value):
            try await stream.write(value ? .true : .false)
        case .number(let number):
            try await number.encode(to: stream)
        case .string(let string):
            try await stream.write(.doubleQuote)
            try await stream.write(string)
            try await stream.write(.doubleQuote)
        case .array(let values):
            try await values.encode(to: stream)
        case .object(let object):
            try await object.encode(to: stream)
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
