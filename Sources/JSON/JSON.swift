import Stream

public struct JSON {
    @dynamicMemberLookup
    public enum Value: Sendable {
        case null
        case bool(Bool)
        case number(Number)
        case string(String)
        case array([JSON.Value])
        case object([String: JSON.Value])

        public enum Number: Sendable {
            case int(Int)
            case uint(UInt)
            case double(Double)
        }

        public subscript(dynamicMember member: String) -> Value? {
            get {
                switch self {
                case .object(let object): return object[member]
                default: return nil
                }
            }
            set {
                switch self {
                case .object(var object):
                    object[member] = newValue
                    self = .object(object)
                default:
                    switch newValue {
                    case .some(let value):
                        self = .object([member: value])
                    case .none:
                        self = .object([:])
                    }
                }
            }
        }
    }
}

// MARK: JSON.Value

extension JSON.Value: Equatable {
    public static func == (lhs: JSON.Value, rhs: JSON.Value) -> Bool {
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

// MARK: JSON.Value.Number

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
