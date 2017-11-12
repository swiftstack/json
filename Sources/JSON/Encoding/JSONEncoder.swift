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
        case .keyed: storage.write("{")
        case .unkeyed: storage.write("[")
        case .single: break
        }
        openedContainers.append(type)
    }

    func closeContainer() {
        if let type = openedContainers.popLast() {
            switch type {
            case .keyed: storage.write("}")
            case .unkeyed: storage.write("]")
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
        storage.write("null")
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
        storage.write("\"")

        @inline(__always)
        func write(prefix: String, value scalar: Unicode.Scalar) {
            storage.write(prefix)
            storage.write(String(scalar.value, radix: 16))
        }

        for scalar in value.unicodeScalars {
            switch scalar {
            case "\"": storage.write("\\\"")
            case "\\": storage.write("\\\\")
            case "\n": storage.write("\\n")
            case "\r": storage.write("\\r")
            case "\t": storage.write("\\t")
            case "\u{8}": storage.write("\\b")
            case "\u{c}": storage.write("\\f")
            case "\u{0}"..."\u{f}": write(prefix: "\\u000", value: scalar)
            case "\u{10}"..."\u{1f}": write(prefix: "\\u00", value: scalar)
            default: storage.write(String(scalar))
            }
        }

        storage.write("\"")
    }
}
