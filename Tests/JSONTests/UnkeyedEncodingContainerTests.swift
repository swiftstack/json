import Test
import Stream
@testable import JSON

class UnkeyedEncodingContainerTests: TestCase {
    func testUnkeyedContainer() {
        do {
            let output = OutputByteStream()
            let encoder = _JSONEncoder(output)
            var unkeyedContainer = encoder.unkeyedContainer()
            try unkeyedContainer.encode(1)
            try unkeyedContainer.encode(2)
            try? encoder.closeContainers(downTo: 0)
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
            try? encoder.closeContainers(downTo: 0)
            assertEqual(output.bytes, [UInt8]("[[1],[2]]".utf8))
        } catch {
            fail(String(describing: error))
        }
    }
}
