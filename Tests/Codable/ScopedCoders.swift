import Testing
import Stream
// don't use @testable
import JSON

@Test("withScopedEncoder")
func withScopedEncoder() async throws {
    try JSON.withScopedEncoder(using: OutputByteStream()) { _ in
    }
}

@Test("withScopedDecoder")
func withScopedDecoder() async throws {
    try await JSON.withScopedDecoder(using: InputByteStream("null")) { _ in
    }
}
