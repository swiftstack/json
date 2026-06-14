import ASCII
import Stream

extension JSON.Value.Number {
    // TODO: https://github.com/fastfloat/fast_float
    public static func decode(from stream: ByteArrayInputStream) throws -> Self {
        let isNegative = try stream.consume(.hyphenMinus) ? true : false
        var isInteger = true

        let string = try stream.read(while: {
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

    public func encode(to stream: ByteArrayOutputStream) throws {
        switch self {
        case .int(let value): try stream.write(String(value))
        case .uint(let value): try stream.write(String(value))
        case .double(let value): try stream.write(String(value))
        }
    }

    private static func isDigit(_ byte: UInt8) -> Bool {
        byte >= .zero && byte <= .nine
    }
}
