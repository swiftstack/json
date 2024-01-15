import Test
import Stream
// don't use @testable
import JSON

test("withScopedEncoder") {
    try JSON.withScopedEncoder(using: OutputByteStream()) { encoder in

    }
}

test("withScopedDecoder") {
    try await JSON.withScopedDecoder(using: InputByteStream("null"))
    { decoder in

    }
}

await run()
