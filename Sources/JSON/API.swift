import Stream

extension JSON {
    public static func encode<T: Encodable>(
        _ value: T
    ) throws -> [UInt8] {
        let stream = ByteArrayOutputStream()
        let encoder = Encoder(stream)
        try value.encode(to: encoder)
        try encoder.close()
        return stream.bytes
    }

    public static func decode<T: Decodable>(
        _ type: T.Type,
        from json: [UInt8],
        options: Decoder.Options = .default
    ) throws -> T {
        let stream = ByteArrayInputStream(json)
        let value = try JSON.Value.decode(from: stream)
        let decoder = try Decoder(value, options: options)
        return try T(from: decoder)
    }

    public static func encode(
        encodable value: Encodable
    ) throws -> [UInt8] {
        let stream = ByteArrayOutputStream()
        let encoder = Encoder(stream)
        try value.encode(to: encoder)
        try encoder.close()
        return stream.bytes
    }

    public static func decode(
        decodable type: Decodable.Type,
        from json: [UInt8],
        options: Decoder.Options = .default
    ) throws -> Decodable {
        let stream = ByteArrayInputStream(json)
        let value = try JSON.Value.decode(from: stream)
        let decoder = try Decoder(value, options: options)
        return try type.init(from: decoder)
    }
}
