import Test
@testable import JSON

class ValueTests: TestCase {
    func testObject() {
        let value = JSON.Value.object(["key": .string("value")])
        assertEqual(value["key"], .string("value"))
    }

    func testArray() {
        let value = JSON.Value.array([.number(.int(42))])
        assertEqual(value[0], .number(.int(42)))
    }

    func testBoolean() {
        let value = JSON.Value.bool(true)
        assertEqual(value.booleanValue, true)
    }

    func testInteger() {
        let value = JSON.Value.number(.int(42))
        assertEqual(value.integerValue, 42)
        assertEqual(value.unsignedValue, 42)
    }

    func testUnsigned() {
        let value = JSON.Value.number(.uint(42))
        assertEqual(value.unsignedValue, 42)
        assertEqual(value.integerValue, 42)
    }

    func testDouble() {
        let value = JSON.Value.number(.double(40.2))
        assertEqual(value.doubleValue, 40.2)
    }

    func testString() {
        let value = JSON.Value.string("value")
        assertEqual(value.stringValue, "value")
    }
}
