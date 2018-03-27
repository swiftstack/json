import Stream
import Platform

extension JSONValue {
    public enum Number {
        case int(Int)
        case uint(UInt)
        case double(Double)
    }
}

extension JSONValue.Number {
    init<T: StreamReader>(from stream: T) throws {
        let isNegative = try stream.consume(.hyphen) ? true : false
        var isInteger = true

        var string = [UInt8]()

        try stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
            string.append(contentsOf: bytes)
        }

        if (try? stream.consume(.dot)) ?? false {
            isInteger = false
            string.append(.dot)
            try stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
                string.append(contentsOf: bytes)
            }
        }
        string.append(0)

        let pointer = UnsafeRawPointer(string)
            .assumingMemoryBound(to: Int8.self)

        switch isNegative {
        case true:
            switch isInteger {
            case true: self = .int(-strtol(pointer, nil, 10))
            case false: self = .double(-strtod(pointer, nil))
            }
        case false:
            switch isInteger {
            case true: self = .uint(strtoul(pointer, nil, 10))
            case false: self = .double(strtod(pointer, nil))
            }
        }
    }
}

extension JSONValue.Number: Equatable {
    public static func ==(lhs: JSONValue.Number, rhs: JSONValue.Number) -> Bool {
        switch (lhs, rhs) {
        case let (.int(lhs), .int(rhs)): return lhs == rhs
        case let (.uint(lhs), .uint(rhs)): return lhs == rhs
        case let (.double(lhs), .double(rhs)): return lhs == rhs
        default: return false
        }
    }
}

extension JSONValue.Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int(let int): return int.description
        case .uint(let uint): return uint.description
        case .double(let double): return double.description
        }
    }
}
