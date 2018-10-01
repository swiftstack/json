import Stream

extension JSON {
    // FIXME: currently pointless, designed for future lazy reading
    public static func withScopedDecoder<T>(
        using reader: StreamReader,
        _ body: (Decoder) throws -> T) throws -> T
    {
        let decoder = try Decoder(reader)
        let result = try body(decoder)
        try decoder.close()
        return result
    }
}

extension JSON {
    public class Decoder: Swift.Decoder {
        public var codingPath: [CodingKey] {
            return []
        }
        public var userInfo: [CodingUserInfoKey : Any] {
            return [:]
        }

        let json: JSON.Value

        public init(_ json: JSON.Value) throws {
            self.json = json
        }

        // NOTE: should be internal, use withScopedDecoder
        init(_ stream: StreamReader) throws {
            self.json = try JSON.Value(from: stream)
        }

        // NOTE: should be internal, use withScopedDecoder
        func close() throws {
            // consume the rest of stream
        }

        public func container<Key>(
            keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>
        {
            guard case .object(let dictionary) = json else {
                throw DecodingError
                    .typeMismatch([String : JSON.Value].self, nil)
            }
            let container = JSONKeyedDecodingContainer<Key>(dictionary)
            return KeyedDecodingContainer(container)
        }

        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            guard case .array(let array) = json else {
                throw DecodingError.typeMismatch([JSON.Value].self, nil)
            }
            return JSONUnkeyedDecodingContainer(array)
        }

        public func singleValueContainer() throws
            -> SingleValueDecodingContainer
        {
            return JSONSingleValueDecodingContainer(json)
        }
    }
}
