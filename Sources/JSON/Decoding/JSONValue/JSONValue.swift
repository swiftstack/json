public enum JSONValue {
    case null
    case bool(Bool)
    case number(Number)
    case string(String)
    case array([JSONValue])
    case object([String : JSONValue])
}

extension JSONValue {
    public init(from json: [UInt8]) throws {
        var index: Int = json.startIndex
        try self.init(from: json, at: &index)
    }

    init(from json: [UInt8], at index: inout Int) throws {
        json.formIndex(from: &index, consuming: .whitespace)

        func ensureValue(_ value: [UInt8]) throws {
            let distance = json.distance(from: index, to: json.endIndex)
            guard value.count <= distance else {
                throw JSONError.invalidJSON
            }
            var endIndex = index
            json.formIndex(&endIndex, offsetBy: value.count)
            guard json[index..<endIndex].starts(with: value) else {
                throw JSONError.invalidJSON
            }
            if distance > value.count {
                guard json[endIndex].contained(in: .terminator) else {
                    throw JSONError.invalidJSON
                }
            }
            index = endIndex
        }

        switch json[index] {
        case .curlyBracketOpen:
            self = .object(try [String : JSONValue](from: json, at: &index))

        case .bracketOpen:
            self = .array(try [JSONValue](from: json, at: &index))

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
            self = .number(try Number(from: json, at: &index))

        case .quote:
            self = .string(try String(from: json, at: &index))

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
