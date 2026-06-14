import Testing
import Stream
// don't use @testable
import AsyncJSON

@Test("withScopedEncoder")
func withScopedEncoder() async throws {
    try JSON.withScopedEncoder(using: ByteArrayOutputStream()) { _ in
    }
}

@Test("withScopedDecoder")
func withScopedDecoder() async throws {
    try await JSON.withScopedDecoder(using: ByteArrayInputStream("null")) { _ in
    }
}
