import Test
@testable import JSON

class JSONValueTests: TestCase {
    func testObject() {
        let value = JSON.Value.object(["key": .string("value")])
        expect(value["key"] == .string("value"))
    }

    func testArray() {
        let value = JSON.Value.array([.number(.int(42))])
        expect(value[0] == .number(.int(42)))
    }

    func testBoolean() {
        let value = JSON.Value.bool(true)
        expect(value.booleanValue == true)
    }

    func testInteger() {
        let value = JSON.Value.number(.int(42))
        expect(value.integerValue == 42)
        expect(value.unsignedValue == 42)
    }

    func testUnsigned() {
        let value = JSON.Value.number(.uint(42))
        expect(value.unsignedValue == 42)
        expect(value.integerValue == 42)
    }

    func testDouble() {
        let value = JSON.Value.number(.double(40.2))
        expect(value.doubleValue == 40.2)
    }

    func testString() {
        let value = JSON.Value.string("value")
        expect(value.stringValue == "value")
    }
}
