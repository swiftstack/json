import Stream

public class JSONDecoder {
    public init() { }
}

extension JSONDecoder {
    public func decode<Model: Decodable>(
        _ type: Model.Type,
        from reader: StreamReader) throws -> Model
    {
        let decoder = try Decoder(reader)
        return try Model(from: decoder)
    }

    public func decode(
        decodable type: Decodable.Type,
        from reader: StreamReader) throws -> Decodable
    {
        let decoder = try Decoder(reader)
        return try type.init(from: decoder)
    }
}

class Decoder: Swift.Decoder {
    var codingPath: [CodingKey] {
        return []
    }
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let json: JSON.Value

    init(_ json: JSON.Value) throws {
        self.json = json
    }

    init(_ stream: StreamReader) throws {
        self.json = try JSON.Value(from: stream)
    }

    func container<Key>(
        keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>
    {
        guard case .object(let dictionary) = json else {
            throw DecodingError.typeMismatch([String : JSON.Value].self, nil)
        }
        let container = JSONKeyedDecodingContainer<Key>(dictionary)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .array(let array) = json else {
            throw DecodingError.typeMismatch([JSON.Value].self, nil)
        }
        return JSONUnkeyedDecodingContainer(array)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return JSONSingleValueDecodingContainer(json)
    }
}
