import Stream

struct EncoderError: Swift.Encoder {
    var codingPath: [CodingKey] { return [] }

    var userInfo: [CodingUserInfoKey : Any] { return [:] }

    func container<Key: CodingKey>(
        keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
    {
        return KeyedEncodingContainer(KeyedEncodingContainerError())
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedEncodingContainerError()
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        return SingleValueEncodingContainerError()
    }
}

struct SingleValueEncodingContainerError: SingleValueEncodingContainer {
    var codingPath: [CodingKey] { return [] }

    mutating func encodeNil() throws {
        throw StreamError.notEnoughSpace
    }

    mutating func encode<T>(_ value: T) throws where T : Encodable {
        throw StreamError.notEnoughSpace
    }
}

struct UnkeyedEncodingContainerError: UnkeyedEncodingContainer {
    var codingPath: [CodingKey] {
        return []
    }

    var count: Int {
        return 0
    }

    mutating func encodeNil() throws {
        throw StreamError.notEnoughSpace
    }

    mutating func encode<T>(_ value: T) throws where T : Encodable {
        throw StreamError.notEnoughSpace
    }

    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey>
    {
        return KeyedEncodingContainer(KeyedEncodingContainerError<NestedKey>())
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedEncodingContainerError()
    }

    mutating func superEncoder() -> Swift.Encoder {
        return EncoderError()
    }
}

struct KeyedEncodingContainerError<K : CodingKey>
: KeyedEncodingContainerProtocol {
    typealias Key = K

    var codingPath: [CodingKey] { return [] }

    mutating func encodeNil(forKey key: K) throws {
        throw StreamError.notEnoughSpace
    }

    mutating func encode<T: Encodable>(_ value: T, forKey key: K) throws {
        throw StreamError.notEnoughSpace
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: K) -> KeyedEncodingContainer<NestedKey>
    {
        return KeyedEncodingContainer(KeyedEncodingContainerError<NestedKey>())
    }

    mutating func nestedUnkeyedContainer(
        forKey key: K) -> UnkeyedEncodingContainer
    {
        return UnkeyedEncodingContainerError()
    }

    mutating func superEncoder() -> Swift.Encoder {
        return EncoderError()
    }

    mutating func superEncoder(forKey key: K) -> Swift.Encoder {
        return EncoderError()
    }
}
