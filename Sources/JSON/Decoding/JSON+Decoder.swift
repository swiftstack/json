import Stream

extension JSON {
    // FIXME: currently pointless, designed for future lazy reading
    public static func withScopedDecoder<T>(
        using reader: StreamReader,
        options: JSON.Decoder.Options = .default,
        _ body: (Decoder) throws -> T) throws -> T
    {
        let decoder = try Decoder(reader, options: options)
        let result = try body(decoder)
        try decoder.close()
        return result
    }
}

extension JSON {
    public class Decoder: Swift.Decoder {
        public var codingPath: [CodingKey] { [] }
        public var userInfo: [CodingUserInfoKey : Any] { [:] }

        let json: JSON.Value
        let options: Options

        public struct Options {
            public let parseNullAsOptional: Bool

            public static var `default` = Options(parseNullAsOptional: true)
        }

        public init(_ json: JSON.Value, options: Options = .default) throws
        {
            self.json = json
            self.options = options
        }

        // NOTE: should be internal, use withScopedDecoder
        init(_ stream: StreamReader, options: Options = .default) throws {
            self.json = try JSON.Value(from: stream)
            self.options = options
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
            let container = JSONKeyedDecodingContainer<Key>(dictionary, options)
            return KeyedDecodingContainer(container)
        }

        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            guard case .array(let array) = json else {
                throw DecodingError.typeMismatch([JSON.Value].self, nil)
            }
            return JSONUnkeyedDecodingContainer(array, options)
        }

        public func singleValueContainer() throws
            -> SingleValueDecodingContainer
        {
            return JSONSingleValueDecodingContainer(json, options)
        }
    }
}
