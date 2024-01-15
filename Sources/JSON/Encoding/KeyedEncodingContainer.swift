import Stream
import Codable

struct JSONKeyedEncodingContainer<K: CodingKey>
: KeyedEncodingContainerProtocol {
    typealias Key = K

    var codingPath: [CodingKey] {
        return []
    }

    let encoder: JSON.Encoder
    let nestingLevel: Int

    init(_ encoder: JSON.Encoder) {
        self.encoder = encoder
        nestingLevel = encoder.openedContainers.count
    }

    var hasValues = false
    mutating func writeCommaIfNeeded() throws {
        guard _slowPath(hasValues) else {
            hasValues = true
            return
        }
        encoder.storage.write(.comma)
    }

    mutating func writeKey(_ key: String) throws {
        encoder.storage.write(.doubleQuote)
        encoder.storage.write(key)
        encoder.storage.write(.doubleQuote)
        encoder.storage.write(.colon)
    }

    var hasNested = false
    mutating func closeNestedIfNeeded() throws {
        if hasNested {
            try encoder.closeContainers(downTo: nestingLevel)
            hasNested = false
        }
    }

    mutating func encodeNil(forKey key: K) throws {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        encoder.storage.write(.null)
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
    ) throws where T: Encodable {
        try closeNestedIfNeeded()
        try writeCommaIfNeeded()
        try writeKey(key.stringValue)
        hasNested = true
        try value.encode(to: encoder)
    }

    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: K
    ) -> KeyedEncodingContainer<NestedKey> {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            hasNested = true
            return encoder.container(keyedBy: keyType)
        } catch {
            return KeyedEncodingContainer(KeyedEncodingError(error))
        }
    }

    mutating func nestedUnkeyedContainer(
        forKey key: K
    ) -> UnkeyedEncodingContainer {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            try writeKey(key.stringValue)
            hasNested = true
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

    mutating func superEncoder(forKey key: K) -> Swift.Encoder {
        do {
            try closeNestedIfNeeded()
            try writeCommaIfNeeded()
            try writeKey(key.stringValue)
            hasNested = true
            return encoder
        } catch {
            return EncodingError(error)
        }
    }
}
