import Test
import Stream
// don't use @testable
import JSON

test.case("withScopedEncoder") {
    try await JSON.withScopedEncoder(using: OutputByteStream()) { encoder in

    }
}

test.case("withScopedDecoder") {
    try await JSON.withScopedDecoder(using: InputByteStream("null"))
    { decoder in

    }
}

test.run()
