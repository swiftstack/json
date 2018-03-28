class JSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey] {
        return []
    }

    var currentIndex: Int
    let array: [JSON.Value]
    init(_ array: [JSON.Value]) {
        self.array = array
        self.currentIndex = 0
    }

    var count: Int? {
        return array.count
    }

    var isAtEnd: Bool {
        return currentIndex == array.count
    }

    @inline(__always)
    private func inlinedDecodeIfPresent<T: JSONValueInitializable>(
        _ type: T.Type
    ) throws -> T? {
        guard let value = T(array[currentIndex]) else {
            if case .null = array[currentIndex] {
                currentIndex += 1
                return nil
            }
            throw DecodingError.typeMismatch(
                type, .incompatible(with: array[currentIndex]))
        }
        currentIndex += 1
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
        let decoder = try Decoder(array[currentIndex])
        let value = try T(from: decoder)
        currentIndex += 1
        return value
    }

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        guard case .object(let object) = array[currentIndex] else {
            throw DecodingError.typeMismatch([String : JSON.Value].self, nil)
        }
        currentIndex += 1
        let container = JSONKeyedDecodingContainer<NestedKey>(object)
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .array(let array) = array[currentIndex] else {
            throw DecodingError.typeMismatch([JSON.Value].self, nil)
        }
        currentIndex += 1
        return JSONUnkeyedDecodingContainer(array)
    }

    func superDecoder() throws -> Swift.Decoder {
        return self
    }
}

// FIXME: 😞
extension JSONUnkeyedDecodingContainer: Swift.Decoder {
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
        guard case .null = array[currentIndex] else {
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
