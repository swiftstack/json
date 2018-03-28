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

// MARK: generic

extension JSON {
    public static func encode<Model: Encodable>(
        _ value: Model,
        to stream: StreamWriter) throws
    {
        let encoder = JSONEncoder()
        try encoder.encode(value, to: stream)
    }

    public static func decode<T: Decodable>(
        _ type: T.Type,
        from stream: StreamReader) throws -> T
    {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: stream)
    }
}

// MARK: type-erased

extension JSON {
    public static func encode(
        encodable value: Encodable,
        to stream: StreamWriter) throws
    {
        let encoder = JSONEncoder()
        try encoder.encode(encodable: value, to: stream)
    }

    public static func decode(
        decodable type: Decodable.Type,
        from stream: StreamReader) throws -> Decodable
    {
        let decoder = JSONDecoder()
        return try decoder.decode(decodable: type, from: stream)
    }
}

// MARK: [UInt8]

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

    public static func encode(encodable value: Encodable) throws -> [UInt8] {
        let encoder = JSONEncoder()
        return try encoder.encode(encodable: value)
    }

    public static func decode(
        decodable type: Decodable.Type,
        from json: [UInt8]) throws -> Decodable
    {
        let decoder = JSONDecoder()
        return try decoder.decode(decodable: type, from: InputByteStream(json))
    }
}
