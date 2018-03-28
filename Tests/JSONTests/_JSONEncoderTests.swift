import Test
import Stream
@testable import JSON

class _JSONEncoderTests: TestCase {
    func testKeyedContainer() {
        let expected = [UInt8]("""
            {"answer":42}
            """.utf8)
        let output = OutputByteStream()
        let encoder = _JSONEncoder(output)
        enum Keys: CodingKey {
            case answer
        }
        var container = encoder.container(keyedBy: Keys.self)
        try? container.encode(42, forKey: .answer)
        try? encoder.close()
        assertEqual(output.bytes, expected)
    }

    func testUnkeyedContainer() {
        let expected = [UInt8]("[1,[2],[3],4]".utf8)
        let output = OutputByteStream()
        let encoder = _JSONEncoder(output)
        var container = encoder.unkeyedContainer()
        try? container.encode(1)
        var nested1 = container.nestedUnkeyedContainer()
        try? nested1.encode(2)
        var nested2 = container.nestedUnkeyedContainer()
        try? nested2.encode(3)
        try? container.encode(4)
        try? encoder.close()
        assertEqual(output.bytes, expected)
    }

    func testSingleValueContainer() {
        let expected = [UInt8]("true".utf8)
        let output = OutputByteStream()
        let encoder = _JSONEncoder(output)
        var container = encoder.singleValueContainer()
        try? container.encode(true)
        assertEqual(output.bytes, expected)
    }
}
