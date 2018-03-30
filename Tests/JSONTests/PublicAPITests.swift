import Test
import Stream
import JSON // don't use @testable

class PublicAPITests: TestCase {
    func testJSONEncoder() {
        scope {
            try JSON.withScopedEncoder(using: OutputByteStream()) { encoder in

            }
        }
    }

    func testJSONDecoder() {
        scope {
            try JSON.withScopedDecoder(using: InputByteStream("null"))
            { decoder in

            }
        }
    }
}
