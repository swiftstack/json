import Test
import Stream
import JSON // don't use @testable

class PublicAPITests: TestCase {
    func testJSONEncoder() throws {
        try JSON.withScopedEncoder(using: OutputByteStream()) { encoder in

        }
    }

    func testJSONDecoder() throws {
        try JSON.withScopedDecoder(using: InputByteStream("null"))
        { decoder in

        }
    }
}
