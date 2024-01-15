import Test
import Stream
// don't use @testable
import JSON

test("withScopedEncoder") {
    try JSON.withScopedEncoder(using: OutputByteStream()) { _ in
    }
}

test("withScopedDecoder") {
    try await JSON.withScopedDecoder(using: InputByteStream("null")) { _ in
    }
}

await run()
