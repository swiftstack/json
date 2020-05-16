import Test
@testable import JSON

class DynamicLookupTests: TestCase {
    func testGet() {
        let value = JSON.Value.object(["key": .string("value")])
        expect(value.key == .string("value"))
    }

    func testSet() {
        var value = JSON.Value.null
        value.key = .string("value")
        expect(value == .object(["key": .string("value")]))
    }
}
