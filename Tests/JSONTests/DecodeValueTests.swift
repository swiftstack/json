import Test
import Stream
@testable import JSON

class DecodeValueTests: TestCase {
    func testNull() throws {
        let null = try JSON.Value(from: InputByteStream("null"))
        expect(null == .null)
    }

    func testBool() throws {
        let jsonTrue = try JSON.Value(from: InputByteStream("true"))
        expect(jsonTrue == .bool(true))

        let jsonFalse = try JSON.Value(from: InputByteStream("false"))
        expect(jsonFalse == .bool(false))
    }

    func testNumber() throws {
        let uint = try JSON.Value(from: InputByteStream("42"))
        expect(uint == .number(.uint(42)))

        let int = try JSON.Value(from: InputByteStream("-42"))
        expect(int == .number(.int(-42)))

        let double = try JSON.Value(from: InputByteStream("-42.42"))
        expect(double == .number(.double(-42.42)))
    }

    func testString() throws {
        let string = try JSON.Value(from: InputByteStream("\"string\""))
        expect(string == .string("string"))

        let escapedJson = InputByteStream("\"string\\r\\n\"")
        let escapedString = try JSON.Value(from: escapedJson)
        expect(escapedString == .string("string\r\n"))

        let invalidJson = InputByteStream("\"string\r\n\"")
        expect(throws: JSON.Error.invalidJSON) {
            try JSON.Value(from: invalidJson)
        }

        let escapedUnicodeJson = InputByteStream("""
            "\\u3053\\u3093\\u306b\\u3061\\u306f"
        """)
        let escapedUnicode = try JSON.Value(from: escapedUnicodeJson)
        expect(escapedUnicode == .string("こんにちは"))
    }

    func testObject() throws {
        let empty = try JSON.Value(from: InputByteStream("{}"))
        expect(empty == .object([:]))

        let simple = try JSON.Value(from: InputByteStream("""
            {"key":"value"}
            """))
        expect(simple == .object(["key" : .string("value")]))

        let nested = try JSON.Value(from: InputByteStream("""
            {"o":{"k":"v"}}
            """))
        expect(nested == .object(["o":.object(["k" : .string("v")])]))

        let whitespace = try JSON.Value(from: InputByteStream("""
            {"key" : "value"}
            """))
        expect(whitespace == .object(["key" : .string("value")]))

        let separator = try JSON.Value(from: InputByteStream("""
            {"k1":"v1", "k2":"v2"}
            """))
        let expected: JSON.Value = .object(
            ["k1" : .string("v1"), "k2" : .string("v2")])
        expect(separator == expected)
    }

    func testArray() throws {
        let empty = try JSON.Value(from: InputByteStream("[]"))
        expect(empty == .array([]))

        let simple = try JSON.Value(from: InputByteStream("[1,2]"))
        expect(simple == .array([.number(.uint(1)), .number(.uint(2))]))

        let strings = try JSON.Value(from: InputByteStream("""
            ["one", "two"]
            """))
        expect(strings == .array([.string("one"), .string("two")]))
    }

    func testNested() throws {
        let objectInArray = try JSON.Value(from: InputByteStream("""
            ["one", 2, {"key": false}]
            """))
        expect(objectInArray == .array([
            .string("one"),
            .number(.uint(2)),
            .object(["key": .bool(false)])]))

        let arrayInObject = try JSON.Value(from: InputByteStream("""
            {"values" : [1,true]}
            """))
        expect(arrayInObject == .object(
            ["values": .array([.number(.uint(1)), .bool(true)])]))
    }
}
