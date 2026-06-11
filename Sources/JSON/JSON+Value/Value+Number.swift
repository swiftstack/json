import Stream
import ASCII

extension JSON.Value.Number {
    // TODO: https://github.com/fastfloat/fast_float
    public static func decode(from stream: StreamReader) async throws -> Self {
        let isNegative = try await stream.consume(.hyphenMinus) ? true : false
        var isInteger = true

        let string = try await stream.read(while: {
            let isDouble =
                $0 == .period ||
                $0 == .hyphenMinus ||
                $0 == .plus ||
                $0 == .e ||
                $0 == .E

            isInteger = isInteger && !isDouble

            return isDigit($0) || isDouble
        }) { bytes in
            String(decoding: bytes, as: UTF8.self)
        }

        switch isInteger {
        case true:
            guard let value = UInt(string) else {
                throw JSON.Error.invalidJSON
            }
            if isNegative && value > Int.max {
                throw JSON.Error.invalidJSON
            }
            return isNegative ? .int(-Int(value)) : .uint(value)
        default:
            guard let value = Double(string) else {
                throw JSON.Error.invalidJSON
            }
            return .double(isNegative ? -value : value)
        }
    }

    public func encode(to stream: StreamWriter) async throws {
        switch self {
        case .int(let value): try await stream.write(String(value))
        case .uint(let value): try await stream.write(String(value))
        case .double(let value): try await stream.write(String(value))
        }
    }

    private static func isDigit(_ byte: UInt8) -> Bool {
        byte >= .zero && byte <= .nine
    }
}

extension JSON.Value.Number: Equatable {
    public static func == (
        lhs: JSON.Value.Number,
        rhs: JSON.Value.Number
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.int(lhs), .int(rhs)): return lhs == rhs
        case let (.uint(lhs), .uint(rhs)): return lhs == rhs
        case let (.double(lhs), .double(rhs)): return lhs == rhs
        default: return false
        }
    }
}

extension JSON.Value.Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int(let int): return int.description
        case .uint(let uint): return uint.description
        case .double(let double): return double.description
        }
    }
}
