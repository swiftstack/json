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
        try withScopedEncoder(using: stream) { encoder in
            try value.encode(to: encoder)
        }
    }

    public static func decode<Model: Decodable>(
        _ type: Model.Type,
        from stream: StreamReader) throws -> Model
    {
        return try withScopedDecoder(using: stream) { decoder in
            return try Model(from: decoder)
        }
    }
}

// MARK: type-erased

extension JSON {
    public static func encode(
        encodable value: Encodable,
        to stream: StreamWriter) throws
    {
        try withScopedEncoder(using: stream) { encoder in
            try value.encode(to: encoder)
        }
    }

    public static func decode(
        decodable type: Decodable.Type,
        from stream: StreamReader) throws -> Decodable
    {
        return try withScopedDecoder(using: stream) { decoder in
            return try type.init(from: decoder)
        }
    }
}

// MARK: [UInt8]

extension JSON {
    public static func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let stream = OutputByteStream()
        try encode(value, to: stream)
        return stream.bytes
    }

    public static func decode<T: Decodable>(
        _ type: T.Type,
        from json: [UInt8]) throws -> T
    {
        return try decode(type, from: InputByteStream(json))
    }

    public static func encode(encodable value: Encodable) throws -> [UInt8] {
        let stream = OutputByteStream()
        try encode(encodable: value, to: stream)
        return stream.bytes
    }

    public static func decode(
        decodable type: Decodable.Type,
        from json: [UInt8]) throws -> Decodable
    {
        return try decode(decodable: type, from: InputByteStream(json))
    }
}
