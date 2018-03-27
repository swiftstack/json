import Stream

public class JSONDecoder {
    public init() { }
}

extension JSONDecoder {
    public func decode<Model: Decodable, Reader: StreamReader>(
        _ type: Model.Type,
        from reader: Reader) throws -> Model
    {
        let decoder = try _JSONDecoder(reader)
        return try Model(from: decoder)
    }

    // FIXME: (_ type: Decodable.Type, ...) shadows the generic one
    public func decode<Reader: StreamReader>(
        decodable type: Decodable.Type,
        from reader: Reader) throws -> Decodable
    {
        let decoder = try _JSONDecoder(reader)
        return try type.init(from: decoder)
    }
}

class _JSONDecoder: Decoder {
    var codingPath: [CodingKey] {
        return []
    }
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let json: JSONValue

    init(_ json: JSONValue) throws {
        self.json = json
    }

    init<T: StreamReader>(_ stream: T) throws {
        self.json = try JSONValue(from: stream)
    }

    func container<Key>(
        keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>
    {
        guard case .object(let dictionary) = json else {
            throw DecodingError.typeMismatch([String : JSONValue].self, nil)
        }
        let container = JSONKeyedDecodingContainer<Key>(dictionary)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .array(let array) = json else {
            throw DecodingError.typeMismatch([JSONValue].self, nil)
        }
        return JSONUnkeyedDecodingContainer(array)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return JSONSingleValueDecodingContainer(json)
    }
}
