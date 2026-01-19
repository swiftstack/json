import Stream

extension JSON {
    public static func withScopedEncoder<T>(
        using writer: StreamWriter,
        _ body: (Encoder) async throws -> T
    ) async throws -> T {
        let stream = ByteArrayOutputStream()
        let encoder = Encoder(stream)
        let result = try await body(encoder)
        try encoder.close()
        try await writer.write(stream.bytes)
        return result
    }

    public static func withScopedEncoder<T>(
        using stream: ByteArrayOutputStream,
        _ body: (Encoder) throws -> T
    ) throws -> T {
        let encoder = Encoder(stream)
        let result = try body(encoder)
        try encoder.close()
        return result
    }
}
