public class JSONDecoder {
    public init() { }

    public func decode<T: Decodable>(
        _ value: T.Type, from json: String
    ) throws -> T {
        let decoder = try _JSONDecoder(json)
        return try T(from: decoder)
    }
}

class _JSONDecoder: Decoder {
    var codingPath: [CodingKey?] {
        return []
    }
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let json: JSONValue

    init(_ json: JSONValue) throws {
        self.json = json
    }

    init(_ json: String) throws {
        self.json = try JSONValue(from: json)
    }

    func container<Key>(
        keyedBy type: Key.Type
    ) throws -> KeyedDecodingContainer<Key> {
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
