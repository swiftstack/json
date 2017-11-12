import Test
@testable import JSON

class _JSONEncoderTests: TestCase {
    func testKeyedContainer() {
        let expected = [UInt8]("""
            {"answer":42}
            """.utf8)
        let encoder = _JSONEncoder()
        enum Keys: CodingKey {
            case answer
        }
        var container = encoder.container(keyedBy: Keys.self)
        try? container.encode(42, forKey: .answer)
        assertEqual(encoder.json, expected)
    }

    func testUnkeyedContainer() {
        let expected = [UInt8]("[1,[2],[3],4]".utf8)
        let encoder = _JSONEncoder()
        var container = encoder.unkeyedContainer()
        try? container.encode(1)
        var nested1 = container.nestedUnkeyedContainer()
        try? nested1.encode(2)
        var nested2 = container.nestedUnkeyedContainer()
        try? nested2.encode(3)
        try? container.encode(4)
        assertEqual(encoder.json, expected)
    }

    func testSingleValueContainer() {
        let expected = [UInt8]("true".utf8)
        let encoder = _JSONEncoder()
        var container = encoder.singleValueContainer()
        try? container.encode(true)
        assertEqual(encoder.json, expected)
    }
}
