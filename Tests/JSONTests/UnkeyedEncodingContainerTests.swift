import Test
@testable import JSON

class UnkeyedEncodingContainerTests: TestCase {
    func testUnkeyedContainer() {
        do {
            let expected = [UInt8]("[1,2]".utf8)
            let encoder = _JSONEncoder()
            var unkeyedContainer = encoder.unkeyedContainer()
            try unkeyedContainer.encode(1)
            try unkeyedContainer.encode(2)
            assertEqual(encoder.json, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testNestedUnkeyedContainer() {
        do {
            let expected = [UInt8]("[[1],[2]]".utf8)
            let encoder = _JSONEncoder()
            var unkeyedContainer = encoder.unkeyedContainer()
            var nested1 = unkeyedContainer.nestedUnkeyedContainer()
            try nested1.encode(1)
            var nested2 = unkeyedContainer.nestedUnkeyedContainer()
            try nested2.encode(2)
            assertEqual(encoder.json, expected)
        } catch {
            fail(String(describing: error))
        }
    }
}
