import JSON
import Contacts
import Stream

extension JSON.Value {
    public static func decode(from stream: some StreamReader) async throws -> Self {
        try await stream.consume(set: .whitespaces)

        func consume(_ value: [UInt8]) async throws {
            guard try await stream.consume(sequence: value) else {
                throw JSON.Error.invalidJSON
            }
        }

        switch try await stream.peek() {
        case .openBrace:
            return .object(try await [String: JSON.Value].decode(from: stream))

        case .openBracket:
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

        case (.zero)...(.nine), .hyphenMinus:
            return .number(try await Number.decode(from: stream))

        case .quote:
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
            try await stream.write(.quote)
            try await stream.write(string)
            try await stream.write(.quote)
        case .array(let values):
            try await values.encode(to: stream)
        case .object(let object):
            try await object.encode(to: stream)
        }
    }
}
