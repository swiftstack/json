import Stream
import Codable

extension JSON {
    public class Encoder: Swift.Encoder {
        public var codingPath: [CodingKey] {
            return []
        }
        public var userInfo: [CodingUserInfoKey : Any] {
            return [:]
        }

        // FIXME: [Concurrency] should be async StreamWriter
        let storage: OutputByteStream

        // FIXME: [Concurrency] should be async StreamWriter
        init(_ writer: OutputByteStream) {
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
            case .keyed: storage.write(.curlyBracketOpen)
            case .unkeyed: storage.write(.squareBracketOpen)
            case .single: break
            }
            openedContainers.append(type)
        }

        func closeContainer() throws {
            if let type = openedContainers.popLast() {
                switch type {
                case .keyed: storage.write(.curlyBracketClose)
                case .unkeyed: storage.write(.squareBracketClose)
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
                return KeyedEncodingContainer(KeyedEncodingError(error))
            }
        }

        public func unkeyedContainer() -> UnkeyedEncodingContainer {
            do {
                try openContainer(.unkeyed)
                return JSONUnkeyedEncodingContainer(self)
            } catch {
                return EncodingError(error)
            }
        }

        public func singleValueContainer() -> SingleValueEncodingContainer {
            do {
                try openContainer(.single)
                return JSONSingleValueEncodingContainer(self)
            } catch {
                return EncodingError(error)
            }
        }
    }
}

extension JSON.Encoder {
    func encodeNil() throws {
        storage.write(.null)
    }

    func encode(_ value: Bool) throws {
        storage.write(value ? .true : .false)
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
        storage.write(.doubleQuote)

        for scalar in value.unicodeScalars {
            switch scalar {
            case "\"":
                storage.write(.backslash)
                storage.write(.doubleQuote)
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
                    throw JSON.Error.invalidJSON
                }
                utf8.forEach(storage.write)
            }
        }

        storage.write(.doubleQuote)
    }
}
