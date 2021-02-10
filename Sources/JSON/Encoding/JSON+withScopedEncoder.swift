import Stream

extension JSON {
    public static func withScopedEncoder<T>(
        using writer: StreamWriter,
        // FIXME: [Concurrency] should be async
        _ body: (Encoder) throws -> T
    ) async throws -> T {
        let stream = OutputByteStream()
        let encoder = Encoder(stream)
        let result = try body(encoder)
        try encoder.close()
        try await writer.write(stream.bytes)
        return result
    }

    public static func withScopedEncoder<T>(
        using stream: OutputByteStream,
        _ body: (Encoder) throws -> T) throws -> T
    {
        let encoder = Encoder(stream)
        let result = try body(encoder)
        try encoder.close()
        return result
    }
}
