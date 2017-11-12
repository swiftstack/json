import Test
@testable import JSON

class JSONTests: TestCase {
    func testEncode() {
        let expected = [UInt8]("""
            {"answer":42,"hello":"Hello, World!"}
            """.utf8)
        struct Model: Encodable {
            let answer: Int = 42
            let hello: String = "Hello, World!"
        }
        do {
            let json = try JSONEncoder().encode(Model())
            assertEqual(json, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testDecode() {
        let json = [UInt8]("""
            {"answer":42,"hello":"Hello, World!"}
            """.utf8)
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        let model = try? JSON.decode(Model.self, from: json)
        assertEqual(model?.answer, 42)
        assertEqual(model?.hello, "Hello, World!")
    }

    func testDecodeEscaped() {
        let json = [UInt8]("""
            {
              "answer":42,
              "hello":"Hello, World!"
            }
            """.utf8)
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        let model = try? JSON.decode(Model.self, from: json)
        assertEqual(model?.answer, 42)
        assertEqual(model?.hello, "Hello, World!")
    }

    func testDecodeEscapedUnicode() {
        let json = [UInt8]("""
            {
              "answer":42,
              "hello":"\\u3053\\u3093\\u306b\\u3061\\u306f"
            }
            """.utf8)
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        let model = try? JSON.decode(Model.self, from: json)
        assertEqual(model?.answer, 42)
        assertEqual(model?.hello, "こんにちは")
    }
}
