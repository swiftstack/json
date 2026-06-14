public protocol JSONValueInitializable {
    init?(_ value: JSON.Value)
}

extension Bool: JSONValueInitializable {
        public init?(_ value: JSON.Value) {
        guard case .bool(let value) = value else {
            return nil
        }
        self = value
    }
}

extension Int: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value): self = value
        case .uint(let value) where value <= Int.max: self = Int(value)
        default: return nil
        }
    }
}

extension Int8: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value <= Int8.max: self = Int8(value)
        case .uint(let value) where value <= Int8.max: self = Int8(value)
        default: return nil
        }
    }
}

extension Int16: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value <= Int16.max: self = Int16(value)
        case .uint(let value) where value <= Int16.max: self = Int16(value)
        default: return nil
        }
    }
}

extension Int32: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value <= Int32.max: self = Int32(value)
        case .uint(let value) where value <= Int32.max: self = Int32(value)
        default: return nil
        }
    }
}

extension Int64: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value <= Int64.max: self = Int64(value)
        case .uint(let value) where value <= Int64.max: self = Int64(value)
        default: return nil
        }
    }
}

extension UInt: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value >= 0: self = UInt(value)
        case .uint(let value): self = value
        default: return nil
        }
    }
}

extension UInt8: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value >= 0 && value <= UInt8.max:
            self = UInt8(value)
        case .uint(let value) where value <= UInt8.max:
            self = UInt8(value)
        default: return nil
        }
    }
}

extension UInt16: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value >= 0 && value <= UInt16.max:
            self = UInt16(value)
        case .uint(let value) where value <= UInt16.max:
            self = UInt16(value)
        default: return nil
        }
    }
}

extension UInt32: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value >= 0 && value <= UInt32.max:
            self = UInt32(value)
        case .uint(let value) where value <= UInt32.max:
            self = UInt32(value)
        default: return nil
        }
    }
}

extension UInt64: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        switch number {
        case .int(let value) where value >= 0 && value <= UInt64.max:
            self = UInt64(value)
        case .uint(let value) where value <= UInt64.max:
            self = UInt64(value)
        default: return nil
        }
    }
}

extension Float: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        // TODO: check maximum value without losing precision
        switch number {
        case .double(let value):
            self = Float(value)
        case .int(let value):
            self = Float(value)
        case .uint(let value):
            self = Float(value)
        }
    }
}

extension Double: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .number(let number) = value else {
            return nil
        }
        // TODO: check maximum value without losing precision
        switch number {
        case .double(let value):
            self = value
        case .int(let value):
            self = Double(value)
        case .uint(let value):
            self = Double(value)
        }
    }
}

extension String: JSONValueInitializable {
    public init?(_ value: JSON.Value) {
        guard case .string(let value) = value else {
            return nil
        }
        self = value
    }
}
