struct JSONKeyedEncodingContainer<K : CodingKey>
: KeyedEncodingContainerProtocol {
    typealias Key = K

    var codingPath: [CodingKey?]
    let encoder: _JSONEncoder
    let nestingLevel: Int

    init(_ encoder: _JSONEncoder) {
        self.codingPath = []
        self.encoder = encoder
        nestingLevel = encoder.openedContainers.count
    }

    var hasValues = false
    mutating func writeCommaIfNeeded() {
        guard _slowPath(hasValues) else {
            hasValues = true
            return
        }
        encoder.storage.write(",")
    }

    mutating func writeKey(_ key: String) {
        encoder.storage.write("\"")
        encoder.storage.write(key)
        encoder.storage.write("\"")
        encoder.storage.write(":")
    }

    var hasNested = false
    mutating func closeNestedIfNeeded() {
        if hasNested {
            encoder.closeContainers(downTo: nestingLevel)
            hasNested = false
        }
    }

    mutating func encode(_ value: Bool, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int8, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int16, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int32, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Int64, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt8, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt16, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt32, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: UInt64, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Float, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: Double, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode(_ value: String, forKey key: K) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        try encoder.encode(value)
    }

    mutating func encode<T>(
        _ value: T, forKey key: K
    ) throws where T : Encodable {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        hasNested = true
        try value.encode(to: encoder)
    }

    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type, forKey key: K
    ) -> KeyedEncodingContainer<NestedKey> {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        hasNested = true
        return encoder.container(keyedBy: keyType)
    }

    mutating func nestedUnkeyedContainer(
        forKey key: K
    ) -> UnkeyedEncodingContainer {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        hasNested = true
        return encoder.unkeyedContainer()
    }

    mutating func superEncoder() -> Encoder {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        hasNested = true
        return encoder
    }

    mutating func superEncoder(forKey key: K) -> Encoder {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        writeKey(key.stringValue)
        hasNested = true
        return encoder
    }
}
