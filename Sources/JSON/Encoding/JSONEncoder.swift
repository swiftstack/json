import Stream

public struct JSONEncoder {
    public init() {}

    public func encode<Model, Writer>(_ value: Model, to writer: Writer) throws
        where Model: Encodable, Writer: StreamWriter
    {
        let encoder = _JSONEncoder(writer)
        try value.encode(to: encoder)
        try encoder.closeContainers(downTo: 0)
    }

    public func encode<Writer>(_ value: Encodable, to writer: Writer) throws
        where Writer: StreamWriter
    {
        let encoder = _JSONEncoder(writer)
        try value.encode(to: encoder)
        try encoder.closeContainers(downTo: 0)
    }
}

extension JSONEncoder {
    public func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let stream = OutputByteStream()
        let encoder = _JSONEncoder(stream)
        try value.encode(to: encoder)
        try encoder.closeContainers(downTo: 0)
        return stream.bytes
    }

    public func encode(_ value: Encodable) throws -> [UInt8] {
        let stream = OutputByteStream()
        let encoder = _JSONEncoder(stream)
        try value.encode(to: encoder)
        try encoder.closeContainers(downTo: 0)
        return stream.bytes
    }
}

class _JSONEncoder<Writer: StreamWriter>: Encoder {
    public var codingPath: [CodingKey] {
        return []
    }
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let storage: Writer

    init(_ writer: Writer) {
        self.storage = writer
    }

    enum ContainerType {
        case keyed
        case unkeyed
        case single
    }

    var openedContainers = ContiguousArray<ContainerType>()

    func openContainer(_ type: ContainerType) throws {
        switch type {
        case .keyed: try storage.write(.curlyBracketOpen)
        case .unkeyed: try storage.write(.bracketOpen)
        case .single: break
        }
        openedContainers.append(type)
    }

    func closeContainer() throws {
        if let type = openedContainers.popLast() {
            switch type {
            case .keyed: try storage.write(.curlyBracketClose)
            case .unkeyed: try storage.write(.bracketClose)
            case .single: break
            }
        }
    }

    func closeContainers(downTo index: Int) throws {
        precondition(openedContainers.count >= index, "invalid stack")
        guard openedContainers.count > index else {
            return
        }
        while openedContainers.count > index {
            try closeContainer()
        }
    }

    public func container<Key>(
        keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
    {
        do {
            try openContainer(.keyed)
            let container = JSONKeyedEncodingContainer<Key, Writer>(self)
            return KeyedEncodingContainer(container)
        } catch {
            return KeyedEncodingContainer(KeyedEncodingContainerError())
        }
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        do {
            try openContainer(.unkeyed)
            return JSONUnkeyedEncodingContainer(self)
        } catch {
            return UnkeyedEncodingContainerError()
        }
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        do {
            try openContainer(.single)
            return JSONSingleValueEncodingContainer(self)
        } catch {
            return SingleValueEncodingContainerError()
        }
    }
}

extension _JSONEncoder {
    func encodeNil() throws {
        try storage.write(.null)
    }

    func encode(_ value: Bool) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: Int) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: Int8) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: Int16) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: Int32) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: Int64) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: UInt) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: UInt8) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: UInt16) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: UInt32) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: UInt64) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: Float) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: Double) throws {
        try storage.write(String(describing: value))
    }

    func encode(_ value: String) throws {
        try storage.write(.quote)

        for scalar in value.unicodeScalars {
            switch scalar {
            case "\"":
                try storage.write(.backslash)
                try storage.write(.quote)
            case "\\":
                try storage.write(.backslash)
                try storage.write(.backslash)
            case "\n":
                try storage.write(.backslash)
                try storage.write(.n)
            case "\r":
                try storage.write(.backslash)
                try storage.write(.r)
            case "\t":
                try storage.write(.backslash)
                try storage.write(.t)
            case "\u{8}":
                try storage.write(.backslash)
                try storage.write(.b)
            case "\u{c}":
                try storage.write(.backslash)
                try storage.write(.f)
            case "\u{0}"..."\u{f}":
                try storage.write("\\u000")
                try storage.write(String(scalar.value, radix: 16))
            case "\u{10}"..."\u{1f}":
                try storage.write("\\u00")
                try storage.write(String(scalar.value, radix: 16))
            default:
                guard let utf8 = UTF8.encode(scalar) else {
                    throw JSONError.invalidJSON
                }
                try utf8.forEach(storage.write)
            }
        }

        try storage.write(.quote)
    }
}
