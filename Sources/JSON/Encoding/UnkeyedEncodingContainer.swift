struct JSONUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    var codingPath: [CodingKey] {
        return []
    }

    let encoder: _JSONEncoder
    let nestingLevel: Int
    var count: Int

    init(_ encoder: _JSONEncoder) {
        self.encoder = encoder
        self.nestingLevel = encoder.openedContainers.count
        self.count = 0
    }

    var hasValues = false
    mutating func writeCommaIfNeeded() {
        guard _slowPath(hasValues) else {
            hasValues = true
            return
        }
        encoder.storage.write(",")
    }

    var hasNested = false
    mutating func closeNestedIfNeeded() {
        if hasNested {
            encoder.closeContainers(downTo: nestingLevel)
            hasNested = false
        }
    }

    mutating func encodeNil() throws {
        // TODO:
        fatalError()
    }

    mutating func encode(_ value: Int) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int8) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int16) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int32) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int64) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt8) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt16) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt32) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt64) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Float) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Double) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: String) throws {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode<T>(_ value: T) throws where T : Encodable {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        hasNested = true
        try value.encode(to: encoder)
        count += 1
    }

    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        hasNested = true
        count += 1
        return encoder.container(keyedBy: keyType)
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        hasNested = true
        count += 1
        return encoder.unkeyedContainer()
    }

    mutating func superEncoder() -> Encoder {
        closeNestedIfNeeded()
        writeCommaIfNeeded()
        hasNested = true
        return encoder
    }
}
