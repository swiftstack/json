import Stream

extension JSON {
    public static func withScopedEncoder<T>(
        using writer: StreamWriter,
        _ body: (Encoder) throws -> T) throws -> T
    {
        let encoder = Encoder(writer)
        let result = try body(encoder)
        try encoder.close()
        return result
    }
}

public class Encoder: Swift.Encoder {
    public var codingPath: [CodingKey] {
        return []
    }
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let storage: StreamWriter

    init(_ writer: StreamWriter) {
        self.storage = writer
    }

    func close() throws {
        try closeContainers(downTo: 0)
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
        case .unkeyed: try storage.write(.squareBracketOpen)
        case .single: break
        }
        openedContainers.append(type)
    }

    func closeContainer() throws {
        if let type = openedContainers.popLast() {
            switch type {
            case .keyed: try storage.write(.curlyBracketClose)
            case .unkeyed: try storage.write(.squareBracketClose)
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
            let container = JSONKeyedEncodingContainer<Key>(self)
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

extension Encoder {
    func encodeNil() throws {
        try storage.write(.null)
    }

    func encode(_ value: Bool) throws {
        try storage.write(value ? .true : .false)
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
        try storage.write(.doubleQuote)

        for scalar in value.unicodeScalars {
            switch scalar {
            case "\"":
                try storage.write(.backslash)
                try storage.write(.doubleQuote)
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
                    throw JSON.Error.invalidJSON
                }
                try utf8.forEach(storage.write)
            }
        }

        try storage.write(.doubleQuote)
    }
}
