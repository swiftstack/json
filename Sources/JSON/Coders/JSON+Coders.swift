import Constants
import Stream

extension JSON.Value {
    public static func decode(from stream: ByteArrayInputStream) throws -> Self {
        try stream.consume(set: .whitespaces)

        func consume(_ value: [UInt8]) throws {
            guard try stream.consume(sequence: value) else {
                throw JSON.Error.invalidJSON
            }
        }

        switch try stream.peek() {
        case .openBrace:
            return .object(try [String: JSON.Value].decode(from: stream))

        case .openBracket:
            return .array(try [JSON.Value].decode(from: stream))

        case .n:
            try consume(.null)
            return .null

        case .t:
            try consume(.true)
            return .bool(true)

        case .f:
            try consume(.false)
            return .bool(false)

        case (.zero)...(.nine), .hyphenMinus:
            return .number(try Number.decode(from: stream))

        case .quote:
            return .string(try String.decode(from: stream))

        default:
            throw JSON.Error.invalidJSON
        }
    }

    public func encode(to stream: ByteArrayOutputStream) throws {
        switch self {
        case .null:
            try stream.write(.null)
        case .bool(let value):
            try stream.write(value ? .true : .false)
        case .number(let number):
            try number.encode(to: stream)
        case .string(let string):
            try stream.write(.quote)
            try stream.write(string)
            try stream.write(.quote)
        case .array(let values):
            try values.encode(to: stream)
        case .object(let object):
            try object.encode(to: stream)
        }
    }
}
