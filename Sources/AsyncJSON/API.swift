import JSON
import Stream

// MARK: generic

extension JSON {
    public static func encode<Model: Encodable>(
        _ value: Model,
        to stream: some StreamWriter
    ) async throws {
        try await withScopedEncoder(using: stream) { encoder in
            try value.encode(to: encoder)
        }
    }

    public static func decode<Model: Decodable>(
        _ type: Model.Type,
        from stream: some StreamReader,
        options: Decoder.Options = .default
    ) async throws -> Model {
        try await withScopedDecoder(
            using: stream,
            options: options
        ) { decoder in
            try Model(from: decoder)
        }
    }
}

// MARK: type-erased

extension JSON {
    public static func encode(
        encodable value: Encodable,
        to stream: StreamWriter
    ) async throws {
        try await withScopedEncoder(using: stream) { encoder in
            try value.encode(to: encoder)
        }
    }

    public static func decode(
        decodable type: Decodable.Type,
        from stream: some StreamReader,
        options: Decoder.Options = .default
    ) async throws -> Decodable {
        try await withScopedDecoder(
            using: stream,
            options: options
        ) { decoder in
            try type.init(from: decoder)
        }
    }
}
