class JSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey?] {
        return []
    }

    var position: Int
    let array: [JSONValue]
    init(_ array: [JSONValue]) {
        self.array = array
        self.position = 0
    }

    var count: Int? {
        return array.count
    }

    var isAtEnd: Bool {
        return position == array.count
    }

    @inline(__always)
    private func inlinedDecodeIfPresent<T: JSONValueInitializable>(
        _ type: T.Type
    ) throws -> T? {
        guard let value = T(array[position]) else {
            if case .null = array[position] {
                position += 1
                return nil
            }
            throw DecodingError.typeMismatch(
                type, .incompatible(with: array[position]))
        }
        position += 1
        return value
    }

    func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent(_ type: String.Type) throws -> String? {
        return try inlinedDecodeIfPresent(type)
    }

    func decodeIfPresent<T>(
        _ type: T.Type
    ) throws -> T? where T : Decodable {
        let decoder = try _JSONDecoder(array[position])
        let value = try T(from: decoder)
        position += 1
        return value
    }

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        guard case .object(let object) = array[position] else {
            throw DecodingError.typeMismatch([String : JSONValue].self, nil)
        }
        position += 1
        let container = JSONKeyedDecodingContainer<NestedKey>(object)
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .array(let array) = array[position] else {
            throw DecodingError.typeMismatch([JSONValue].self, nil)
        }
        position += 1
        return JSONUnkeyedDecodingContainer(array)
    }

    func superDecoder() throws -> Decoder {
        return self
    }
}

// FIXME: 😞
extension JSONUnkeyedDecodingContainer: Decoder {
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    func container<Key>(
        keyedBy type: Key.Type
    ) throws -> KeyedDecodingContainer<Key> {
        return try nestedContainer(keyedBy: type)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try nestedUnkeyedContainer()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}

extension JSONUnkeyedDecodingContainer: SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        guard case .null = array[position] else {
            return false
        }
        return true
    }

    func decode(_ type: Int.Type) throws -> Int {
        guard let value = try decodeIfPresent(Int.self) else {
            throw DecodingError.typeMismatch(type, .unexpectedNull())
        }
        return value
    }

    @inline(__always)
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        guard let value = try decodeIfPresent(T.self) else {
            throw DecodingError.typeMismatch(type, .unexpectedNull())
        }
        return value
    }
}
