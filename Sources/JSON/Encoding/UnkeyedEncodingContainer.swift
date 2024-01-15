import Stream
import Codable

struct JSONUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    var codingPath: [CodingKey] {
        return []
    }

    let encoder: JSON.Encoder
    let nestingLevel: Int
    var count: Int

    init(_ encoder: JSON.Encoder) {
        self.encoder = encoder
        self.nestingLevel = encoder.openedContainers.count
        self.count = 0
    }

    var hasValues = false
    mutating func writeCommaIfNeeded() throws {
        guard _slowPath(hasValues) else {
            hasValues = true
            return
        }
        encoder.storage.write(",")
    }

    var hasNested = false
    mutating func closeNestedIfNeeded() throws {
        if hasNested {
            try encoder.closeContainers(downTo: nestingLevel)
            hasNested = false
        }
    }

    mutating func encodeNil() throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encodeNil()
        count += 1
    }

    mutating func encode(_ value: Bool) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int8) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int16) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int32) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Int64) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt8) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt16) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt32) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: UInt64) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Float) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: Double) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode(_ value: String) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try encoder.encode(value)
        count += 1
    }

    mutating func encode<T>(_ value: T) throws where T: Encodable {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        hasNested = true
        try value.encode(to: encoder)
        count += 1
    }

    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            hasNested = true
            count += 1
            return encoder.container(keyedBy: keyType)
        } catch {
            return KeyedEncodingContainer(KeyedEncodingError(error))
        }
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            hasNested = true
            count += 1
            return encoder.unkeyedContainer()
        } catch {
            return EncodingError(error)
        }
    }

    mutating func superEncoder() -> Swift.Encoder {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            hasNested = true
            return encoder
        } catch {
            return EncodingError(error)
        }
    }
}
