import Stream
import Platform

extension JSON.Value.Number {
    public static func decode(from stream: StreamReader) async throws -> Self {
        let isNegative = try await stream.consume(.hyphen) ? true : false
        var isInteger = true

        var string = [UInt8]()

        try await stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
            string.append(contentsOf: bytes)
        }

        if (try? await stream.consume(.dot)) ?? false {
            isInteger = false
            string.append(.dot)
            try await stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
                string.append(contentsOf: bytes)
            }
        }
        string.append(0)

        let casted = unsafeBitCast(string, to: [Int8].self)

        switch isNegative {
        case true:
            switch isInteger {
            case true: return .int(-strtol(casted, nil, 10))
            case false: return .double(-strtod(casted, nil))
            }
        case false:
            switch isInteger {
            case true: return .uint(strtoul(casted, nil, 10))
            case false: return .double(strtod(casted, nil))
            }
        }
    }

    public func encode(to stream: StreamWriter) async throws {
        switch self {
        case .int(let value): try await stream.write(String(value))
        case .uint(let value): try await stream.write(String(value))
        case .double(let value): try await stream.write(String(value))
        }
    }
}

extension JSON.Value.Number: Equatable {
    public static func ==(
        lhs: JSON.Value.Number,
        rhs: JSON.Value.Number) -> Bool
    {
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
