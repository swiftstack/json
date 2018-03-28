import Test
import Stream
@testable import JSON

class EncoderTests: TestCase {
    func testKeyedContainer() {
        scope {
            let expected = """
            {"answer":42}
            """
            let output = OutputByteStream()
            let encoder = Encoder(output)
            enum Keys: CodingKey {
                case answer
            }
            var container = encoder.container(keyedBy: Keys.self)
            try container.encode(42, forKey: .answer)
            try encoder.close()
            assertEqual(output.string, expected)
        }
    }

    func testUnkeyedContainer() {
        scope {
            let expected = "[1,[2],[3],4]"
            let output = OutputByteStream()
            let encoder = Encoder(output)
            var container = encoder.unkeyedContainer()
            try container.encode(1)
            var nested1 = container.nestedUnkeyedContainer()
            try nested1.encode(2)
            var nested2 = container.nestedUnkeyedContainer()
            try nested2.encode(3)
            try container.encode(4)
            try encoder.close()
            assertEqual(output.string, expected)
        }
    }

    func testSingleValueContainer() {
        scope {
            let expected = "true"
            let output = OutputByteStream()
            let encoder = Encoder(output)
            var container = encoder.singleValueContainer()
            try container.encode(true)
            assertEqual(output.string, expected)
        }
    }
}
