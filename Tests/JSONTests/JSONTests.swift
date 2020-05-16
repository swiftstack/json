import Test
import Stream
@testable import JSON

class JSONTests: TestCase {
    func testEncode() throws {
        let expected = """
            {"answer":42,"hello":"Hello, World!"}
            """
        struct Model: Encodable {
            let answer: Int = 42
            let hello: String = "Hello, World!"
        }
        let bytes = try JSON.encode(Model())
        let json = String(decoding: bytes, as: UTF8.self)
        expect(json == expected)
    }

    func testDecode() throws {
        let json = InputByteStream("""
            {"answer":42,"hello":"Hello, World!"}
            """)
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        let model = try JSON.decode(Model.self, from: json)
        expect(model.answer == 42)
        expect(model.hello == "Hello, World!")
    }

    func testDecodeEscaped() throws {
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
        expect(model.answer == 42)
        expect(model.hello == "Hello, World!")
    }

    func testDecodeEscapedUnicode() throws {
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
        expect(model.answer == 42)
        expect(model.hello == "こんにちは")
    }
}
