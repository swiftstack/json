import Stream

public enum JSON {}

// MARK: JSON.Value

extension JSON {
    @dynamicMemberLookup
    public enum Value: Sendable {
        case null
        case bool(Bool)
        case number(Number)
        case string(String)
        case array([JSON.Value])
        case object(Object)

        public subscript(dynamicMember member: String) -> Value? {
            get {
                switch self {
                case .object(let object): object[member]
                default: nil
                }
            }
            set {
                switch self {
                case .object(var object):
                    object[member] = newValue
                    self = .object(object)
                default:
                    break
                }
            }
        }
    }
}

// MARK: JSON.Value.Number

extension JSON.Value {
    public enum Number: Sendable {
        case int(Int)
        case uint(UInt)
        case double(Double)
    }
}

// MARK: JSON.Value.Object

extension JSON.Value {
    @dynamicMemberLookup
    public struct Object: Sendable {
        public struct Element: Sendable, Equatable {
            let key: String
            let value: JSON.Value

            init(key: String, value: JSON.Value) {
                self.key = key
                self.value = value
            }

            init(_ keyValue: (String, JSON.Value)) {
                self.key = keyValue.0
                self.value = keyValue.1
            }
        }

        var array: [Element]

        public init(_ array: [Element] = []) {
            self.array = array
        }

        public subscript(_ key: String) -> JSON.Value? {
            get {
                array.first(where: { $0.key == key})?.value
            }
            set {
                if let index = array.firstIndex(where: { $0.key == key}) {
                    if let newValue {
                        array[index] = .init((key, newValue))
                    } else {
                        array.remove(at: index)
                    }
                } else {
                    if let newValue {
                        array.append(.init((key, newValue)))
                    }
                }
            }
        }

        public subscript(dynamicMember member: String) -> JSON.Value? {
            get { self[member] }
            set { self[member] = newValue }
        }

        public mutating func append(key: String, value: JSON.Value) {
            self.array.append(.init(key: key, value: value))
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

// MARK: JSON.Object

extension JSON.Value.Object: Equatable {
    public static func == (
        lhs: JSON.Value.Object,
        rhs: JSON.Value.Object
    ) -> Bool {
        lhs.array == rhs.array
    }
}

extension JSON.Value.Object: CustomStringConvertible {
    public var description: String {
        array.description
    }
}

extension JSON.Value.Object: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSON.Value)...) {
        self.array = elements.map(Element.init)
    }
}
