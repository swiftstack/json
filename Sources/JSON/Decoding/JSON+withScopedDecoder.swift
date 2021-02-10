import Stream

extension JSON {
    // FIXME: currently pointless, designed for future lazy reading
    public static func withScopedDecoder<T>(
        using reader: StreamReader,
        options: JSON.Decoder.Options = .default,
        _ body: (Decoder) throws -> T) async throws -> T
    {
        let json = try await JSON.Value.decode(from: reader)
        let decoder = try Decoder(json, options: options)
        let result = try body(decoder)
        try decoder.close()
        return result
    }
}
