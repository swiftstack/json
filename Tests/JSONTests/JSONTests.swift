import Test
import Stream
@testable import JSON

class JSONTests: TestCase {
    func testEncode() {
        scope {
            let expected = """
            {"answer":42,"hello":"Hello, World!"}
            """
            struct Model: Encodable {
                let answer: Int = 42
                let hello: String = "Hello, World!"
            }
            let bytes = try JSONEncoder().encode(Model())
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }

    func testDecode() {
        scope {
            let json = InputByteStream("""
            {"answer":42,"hello":"Hello, World!"}
            """)
            struct Model: Decodable {
                let answer: Int
                let hello: String
            }
            let model = try JSON.decode(Model.self, from: json)
            assertEqual(model.answer, 42)
            assertEqual(model.hello, "Hello, World!")
        }
    }

    func testDecodeEscaped() {
        scope {
            let json = InputByteStream("""
            {
              "answer":42,
              "hello":"Hello, World!"
            }
            """)
            struct Model: Decodable {
                let answer: Int
                let hello: String
            }
            let model = try JSON.decode(Model.self, from: json)
            assertEqual(model.answer, 42)
            assertEqual(model.hello, "Hello, World!")
        }
    }

    func testDecodeEscapedUnicode() {
        scope {
            let json = InputByteStream("""
            {
              "answer":42,
              "hello":"\\u3053\\u3093\\u306b\\u3061\\u306f"
            }
            """)
            struct Model: Decodable {
                let answer: Int
                let hello: String
            }
            let model = try JSON.decode(Model.self, from: json)
            assertEqual(model.answer, 42)
            assertEqual(model.hello, "こんにちは")
        }
    }
}
