public class JSONDecoder {
    public init() { }

    public func decode<T: Decodable>(
        _ type: T.Type, from json: [UInt8]
    ) throws -> T {
        let decoder = try _JSONDecoder(json)
        return try T(from: decoder)
    }
    
    // FIXME: (_ type: Decodable.Type, ...) shadows the generic one
    public func decode(
        decodable type: Decodable.Type, from json: [UInt8]
    ) throws -> Decodable {
        let decoder = try _JSONDecoder(json)
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

    init(_ json: [UInt8]) throws {
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
