import Stream

public struct JSON {
    public enum Value {
        case null
        case bool(Bool)
        case number(Number)
        case string(String)
        case array([JSON.Value])
        case object([String : JSON.Value])

        public enum Number {
            case int(Int)
            case uint(UInt)
            case double(Double)
        }
    }
}

extension JSON {
    public static func encode<Model: Encodable, Writer: StreamWriter>(
        _ value: Model,
        to stream: Writer) throws
    {
        let encoder = JSONEncoder()
        try encoder.encode(value, to: stream)
    }

    public static func decode<Model: Decodable, Reader: StreamReader>(
        _ type: Model.Type,
        from stream: Reader) throws -> Model
    {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: stream)
    }
}

extension JSON {
    public static func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }

    public static func decode<T: Decodable>(
        _ type: T.Type,
        from json: [UInt8]) throws -> T
    {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: InputByteStream(json))
    }
}
