import Testing
import Stream
// don't use @testable
import AsyncJSON

@Test("withScopedEncoder")
func withScopedEncoder() async throws {
    try await JSON.withScopedEncoder(using: MemoryStream()) { _ in
    }
}

@Test("withScopedDecoder")
func withScopedDecoder() async throws {
    try await JSON.withScopedDecoder(using: MemoryStream("null")) { _ in
    }
}
