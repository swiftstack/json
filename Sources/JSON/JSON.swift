public struct JSON {
    public static func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }

    public static func decode<T: Decodable>(
        _ type: T.Type, from json: [UInt8]
    ) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: json)
    }
}
