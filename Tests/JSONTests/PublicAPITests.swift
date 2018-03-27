import Test
import JSON // don't use @testable

class PublicAPITests: TestCase {
    func testJSONEncoder() {
        _ = JSONEncoder()
    }

    func testJSONEncoderEncode() {
        scope {
            let encoder = JSONEncoder()
            _ = try encoder.encode(42)
        }
    }
}
