struct JSONKeyedDecodingContainer<K : CodingKey>
: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] {
        return []
    }
    var allKeys: [K] {
        return []
    }

    let object: [String : JSON.Value]
    init(_ object: [String : JSON.Value]) {
        self.object = object
    }

    func contains(_ key: K) -> Bool {
        return object[key.stringValue] != nil
    }

    @inline(__always)
    private func inlinedDecodeIfPresent<T: JSONValueInitializable>(
        _ type: T.Type, forKey key: K
    ) throws -> T? {
        guard let object = object[key.stringValue] else {
            return nil
        }

        guard let value = T(object) else {
            if case .null = object {
                return nil
            }
            throw DecodingError.typeMismatch(
                type, .incompatible(with: object, for: key))
        }

        return value
    }

    @inline(__always)
    private func inlinedDecode<T: JSONValueInitializable>(
        _ type: T.Type, forKey key: K
    ) throws -> T {
        guard let object = object[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }

        guard let value = T(object) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: object, for: key))
        }

        return value
    }

    func decodeNil(forKey key: K) throws -> Bool {
        // TODO:
        throw JSON.Error.cantDecodeNil
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        return try inlinedDecode(type, forKey: key)
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String {
        return try inlinedDecode(type, forKey: key)
    }

    func decode<T>(
        _ type: T.Type,
        forKey key: K
    ) throws -> T where T : Decodable {
        guard let value = object[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        let decoder = try Decoder(value)
        return try T(from: decoder)
    }

    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        return try inlinedDecodeIfPresent(type, forKey: key)
    }

    func decodeIfPresent<T>(
        _ type: T.Type,
        forKey key: K
    ) throws -> T? where T : Decodable {
        guard let value = object[key.stringValue] else {
            return nil
        }
        let decoder = try Decoder(value)
        return try T(from: decoder)
    }

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type,
        forKey key: K
    ) throws -> KeyedDecodingContainer<NestedKey> {
        guard let nested = object[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard case .object(let object) = nested else {
            throw DecodingError.typeMismatch([String : JSON.Value].self, nil)
        }
        let container = JSONKeyedDecodingContainer<NestedKey>(object)
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer(
        forKey key: K
    ) throws -> UnkeyedDecodingContainer {
        guard let nested = object[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard case .array(let array) = nested else {
            throw DecodingError.typeMismatch([JSON.Value].self, nil)
        }
        return JSONUnkeyedDecodingContainer(array)
    }

    func superDecoder() throws -> Swift.Decoder {
        return try Decoder(.object(object))
    }

    func superDecoder(forKey key: K) throws -> Swift.Decoder {
        guard let nested = object[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        return try Decoder(nested)
    }
}
