import Stream

// Encoder

extension JSON {
    public static func withScopedEncoder(
        using writer: MemoryStream,
        _ body: (Encoder) async throws -> Void
    ) async throws {
        let stream = MemoryStream()
        let encoder = Encoder(stream)
        try await body(encoder)
        try encoder.close()
        try await stream.withUnsafeBufferPointer { buffer in
            try await writer.write(buffer)
        }
    }
}

// Decoder

extension JSON {
    // FIXME: currently pointless, designed for future lazy reading
    public static func withScopedDecoder<T>(
        using reader: some MemoryStream,
        options: JSON.Decoder.Options = .default,
        _ body: (Decoder) throws -> T
    ) throws -> T {
        let json = try JSON.Value.decode(from: reader)
        let decoder = try Decoder(json, options: options)
        let result = try body(decoder)
        try decoder.close()
        return result
    }
}
