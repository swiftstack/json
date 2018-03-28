import Stream

struct JSONKeyedEncodingContainer<K : CodingKey, Writer: StreamWriter>
: KeyedEncodingContainerProtocol {
    typealias Key = K

    var codingPath: [CodingKey] {
        return []
    }

    let encoder: _JSONEncoder<Writer>
    let nestingLevel: Int

    init(_ encoder: _JSONEncoder<Writer>) {
        self.encoder = encoder
        nestingLevel = encoder.openedContainers.count
    }

    var hasValues = false
    mutating func writeCommaIfNeeded() throws {
        guard _slowPath(hasValues) else {
            hasValues = true
            return
        }
        try encoder.storage.write(.comma)
    }

    mutating func writeKey(_ key: String) throws {
        try encoder.storage.write(.quote)
        try encoder.storage.write(key)
        try encoder.storage.write(.quote)
        try encoder.storage.write(.colon)
    }

    var hasNested = false
    mutating func closeNestedIfNeeded() throws {
        if hasNested {
            try encoder.closeContainers(downTo: nestingLevel)
            hasNested = false
        }
    }

    mutating func encodeNil(forKey key: K) throws {
        // TODO:
        throw JSON.Error.cantEncodeNil
    }

    mutating func encode(_ value: Bool, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int8, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int16, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int32, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int64, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt8, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt16, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt32, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt64, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Float, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Double, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: String, forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode<T>(
        _ value: T, forKey key: K
    ) throws where T : Encodable {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        hasNested = true
        try value.encode(to: encoder)
    }

    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: K) -> KeyedEncodingContainer<NestedKey>
    {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            hasNested = true
            return encoder.container(keyedBy: keyType)
        } catch {
            let container = KeyedEncodingContainerError<NestedKey>()
            return KeyedEncodingContainer(container)
        }
    }

    mutating func nestedUnkeyedContainer(
        forKey key: K) -> UnkeyedEncodingContainer
    {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            try writeKey(key.stringValue)
            hasNested = true
            return encoder.unkeyedContainer()
        } catch {
            return UnkeyedEncodingContainerError()
        }
    }

    mutating func superEncoder() -> Encoder {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            hasNested = true
            return encoder
        } catch {
            return EncoderError()
        }
    }

    mutating func superEncoder(forKey key: K) -> Encoder {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            try writeKey(key.stringValue)
            hasNested = true
            return encoder
        } catch {
            return EncoderError()
        }
    }
}
