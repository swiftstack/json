import Test
@testable import JSON

class JSONTests: TestCase {
    func testEncode() {
        let expected = """
            {"answer":42,"hello":"Hello, World!"}
            """
        struct Model: Encodable {
            let answer: Int = 42
            let hello: String = "Hello, World!"
        }
        let json = try? JSON.encode(Model())
        assertEqual(json, expected)
    }

    func testDecode() {
        let json = """
            {"answer":42,"hello":"Hello, World!"}
            """
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        let model = try? JSON.decode(Model.self, from: json)
        assertEqual(model?.answer, 42)
        assertEqual(model?.hello, "Hello, World!")
    }
}
