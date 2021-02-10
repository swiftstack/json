import Stream

public struct JSON {
    @dynamicMemberLookup
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

        public subscript(dynamicMember member: String) -> Value? {
            get {
                switch self {
                case .object(let object): return object[member]
                default: return nil
                }
            }
            set {
                switch self {
                case .object(var object):
                    object[member] = newValue
                    self = .object(object)
                default:
                    switch newValue {
                    case .some(let value):
                        self = .object([member : value])
                    case .none:
                        self = .object([:])
                    }
                }
            }
        }
    }
}

// MARK: generic

extension JSON {
    public static func encode<Model: Encodable>(
        _ value: Model,
        to stream: StreamWriter) async throws
    {
        try await withScopedEncoder(using: stream) { encoder in
            try value.encode(to: encoder)
        }
    }

    public static func decode<Model: Decodable>(
        _ type: Model.Type,
        from stream: StreamReader,
        options: Decoder.Options = .default) async throws -> Model
    {
        return try await withScopedDecoder(using: stream, options: options)
        { decoder in
            return try Model(from: decoder)
        }
    }
}

// MARK: type-erased

extension JSON {
    public static func encode(
        encodable value: Encodable,
        to stream: StreamWriter) async throws
    {
        try await withScopedEncoder(using: stream) { encoder in
            try value.encode(to: encoder)
        }
    }

    public static func decode(
        decodable type: Decodable.Type,
        from stream: StreamReader,
        options: Decoder.Options = .default) async throws -> Decodable
    {
        return try await withScopedDecoder(using: stream, options: options)
        { decoder in
            return try type.init(from: decoder)
        }
    }
}

// MARK: [UInt8]

extension JSON {
    public static func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        // FIXME: [Concurrency]
        let stream = OutputByteStream()
        let encoder = Encoder(stream)
        try value.encode(to: encoder)
        try encoder.close()
        return stream.bytes
    }

    public static func decode<T: Decodable>(
        _ type: T.Type,
        from json: [UInt8],
        options: Decoder.Options = .default) async throws -> T
    {
        // FIXME: [Concurrency] should be sync
        return try await decode(type, from: InputByteStream(json), options: options)
    }

    public static func encode(encodable value: Encodable) throws -> [UInt8] {
        // FIXME: [Concurrency]
        let stream = OutputByteStream()
        let encoder = Encoder(stream)
        try value.encode(to: encoder)
        try encoder.close()
        return stream.bytes
    }

    public static func decode(
        decodable type: Decodable.Type,
        from json: [UInt8],
        options: Decoder.Options = .default) async throws -> Decodable
    {
        // FIXME: [Concurrency] should be sync
        return try await decode(
            decodable: type,
            from: InputByteStream(json),
            options: options)
    }
}
