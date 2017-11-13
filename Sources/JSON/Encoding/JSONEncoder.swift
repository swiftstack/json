public struct JSONEncoder {
    let capacity: Int
    public init(reservingCapacity capacity: Int = 256) {
        self.capacity = capacity
    }

    public func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let encoder = _JSONEncoder(reservingCapacity: capacity)
        try value.encode(to: encoder)
        return encoder.json
    }
    
    public func encode(_ value: Encodable) throws -> [UInt8] {
        let encoder = _JSONEncoder(reservingCapacity: capacity)
        try value.encode(to: encoder)
        return encoder.json
    }
}

class _JSONEncoder: Encoder {
    public var codingPath: [CodingKey] {
        return []
    }
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let storage: Storage

    var json: [UInt8] {
        closeContainers(downTo: 0)
        return storage.json
    }

    init(reservingCapacity capacity: Int = 256) {
        self.storage = Storage(reservingCapacity: capacity)
    }

    enum ContainerType {
        case keyed
        case unkeyed
        case single
    }

    var openedContainers = ContiguousArray<ContainerType>()

    func openContainer(_ type: ContainerType) {
        switch type {
        case .keyed: storage.write(.curlyBracketOpen)
        case .unkeyed: storage.write(.bracketOpen)
        case .single: break
        }
        openedContainers.append(type)
    }

    func closeContainer() {
        if let type = openedContainers.popLast() {
            switch type {
            case .keyed: storage.write(.curlyBracketClose)
            case .unkeyed: storage.write(.bracketClose)
            case .single: break
            }
        }
    }

    func closeContainers(downTo index: Int) {
        precondition(openedContainers.count >= index, "invalid stack")
        guard openedContainers.count > index else {
            return
        }
        while openedContainers.count > index {
            closeContainer()
        }
    }

    public func container<Key>(
        keyedBy type: Key.Type
    ) -> KeyedEncodingContainer<Key> {
        openContainer(.keyed)
        let container = JSONKeyedEncodingContainer<Key>(self)
        return KeyedEncodingContainer(container)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        openContainer(.unkeyed)
        return JSONUnkeyedEncodingContainer(self)
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        openContainer(.single)
        return JSONSingleValueEncodingContainer(self)
    }
}

extension _JSONEncoder {
    func encodeNil() throws {
        storage.write(.null)
    }

    func encode(_ value: Bool) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: Int) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: Int8) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: Int16) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: Int32) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: Int64) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: UInt) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: UInt8) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: UInt16) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: UInt32) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: UInt64) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: Float) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: Double) throws {
        storage.write(String(describing: value))
    }

    func encode(_ value: String) throws {
        storage.write(.quote)

        for scalar in value.unicodeScalars {
            switch scalar {
            case "\"":
                storage.write(.backslash)
                storage.write(.quote)
            case "\\":
                storage.write(.backslash)
                storage.write(.backslash)
            case "\n":
                storage.write(.backslash)
                storage.write(.n)
            case "\r":
                storage.write(.backslash)
                storage.write(.r)
            case "\t":
                storage.write(.backslash)
                storage.write(.t)
            case "\u{8}":
                storage.write(.backslash)
                storage.write(.b)
            case "\u{c}":
                storage.write(.backslash)
                storage.write(.f)
            case "\u{0}"..."\u{f}":
                storage.write("\\u000")
                storage.write(String(scalar.value, radix: 16))
            case "\u{10}"..."\u{1f}":
                storage.write("\\u00")
                storage.write(String(scalar.value, radix: 16))
            default:
                guard let utf8 = UTF8.encode(scalar) else {
                    throw JSONError.invalidJSON
                }
                utf8.forEach(storage.write)
            }
        }

        storage.write(.quote)
    }
}
