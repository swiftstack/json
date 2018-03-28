import Test
import Stream
@testable import JSON

extension OutputByteStream {
    var string: String {
        return String(decoding: bytes, as: UTF8.self)
    }
}

class UnkeyedEncodingContainerTests: TestCase {
    func testUnkeyedContainer() {
        do {
            let output = OutputByteStream()
            let encoder = _JSONEncoder(output)
            var unkeyedContainer = encoder.unkeyedContainer()
            try unkeyedContainer.encode(1)
            try unkeyedContainer.encode(2)
            try encoder.close()
            assertEqual(output.bytes, [UInt8]("[1,2]".utf8))
        } catch {
            fail(String(describing: error))
        }
    }

    func testNestedUnkeyedContainer() {
        do {
            let output = OutputByteStream()
            let encoder = _JSONEncoder(output)
            var unkeyedContainer = encoder.unkeyedContainer()
            var nested1 = unkeyedContainer.nestedUnkeyedContainer()
            try nested1.encode(1)
            var nested2 = unkeyedContainer.nestedUnkeyedContainer()
            try nested2.encode(2)
            try encoder.close()
            assertEqual(output.bytes, [UInt8]("[[1],[2]]".utf8))
        } catch {
            fail(String(describing: error))
        }
    }

    func testNull() {
        do {
            let output = OutputByteStream()
            let encoder = _JSONEncoder(output)
            var unkeyedContainer = encoder.unkeyedContainer()
            try unkeyedContainer.encodeNil()
            try unkeyedContainer.encodeNil()
            try encoder.close()
            assertEqual(output.string, "[null,null]")
        } catch {
            fail(String(describing: error))
        }
    }
}
