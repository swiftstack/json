extension JSON.Value {
    public var booleanValue: Bool? {
        switch self {
        case .bool(let value): return value
        default: return nil
        }
    }

    public var integerValue: Int? {
        switch self {
        case .number(.int(let value)): return value
        case .number(.uint(let value)) where value < UInt(Int.max):
            return Int(value)
        default: return nil
        }
    }

    public var unsignedValue: UInt? {
        switch self {
        case .number(.uint(let value)): return value
        case .number(.int(let value)) where value >= 0: return UInt(value)
        default: return nil
        }
    }

    public var doubleValue: Double? {
        switch self {
        case .number(.double(let value)): return value
        case .number(.int(let value)): return Double(value)
        case .number(.uint(let value)): return Double(value)
        default: return nil
        }
    }

    public var stringValue: String? {
        switch self {
        case .string(let value): return value
        default: return nil
        }
    }

    public subscript(index: Int) -> JSON.Value? {
        switch self {
        case .array(let array) where index < array.count: return array[index]
        default: return nil
        }
    }

    public subscript(key: String) -> JSON.Value? {
        switch self {
        case .object(let object): return object[key]
        default: return nil
        }
    }
}
