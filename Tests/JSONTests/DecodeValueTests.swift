import Test
import Stream
@testable import JSON

class DecodeValueTests: TestCase {
    func testNull() {
        scope {
            let null = try JSON.Value(from: InputByteStream("null"))
            assertEqual(null, .null)
        }
    }

    func testBool() {
        scope {
            let jsonTrue = try JSON.Value(from: InputByteStream("true"))
            assertEqual(jsonTrue, .bool(true))

            let jsonFalse = try JSON.Value(from: InputByteStream("false"))
            assertEqual(jsonFalse, .bool(false))
        }
    }

    func testNumber() {
        scope {
            let uint = try JSON.Value(from: InputByteStream("42"))
            assertEqual(uint, .number(.uint(42)))

            let int = try JSON.Value(from: InputByteStream("-42"))
            assertEqual(int, .number(.int(-42)))

            let double = try JSON.Value(from: InputByteStream("-42.42"))
            assertEqual(double, .number(.double(-42.42)))
        }
    }

    func testString() {
        scope {
            let string = try JSON.Value(from: InputByteStream("\"string\""))
            assertEqual(string, .string("string"))

            let escapedJson = InputByteStream("\"string\\r\\n\"")
            let escapedString = try JSON.Value(from: escapedJson)
            assertEqual(escapedString, .string("string\r\n"))

            let invalidJson = InputByteStream("\"string\r\n\"")
            assertThrowsError(try JSON.Value(from: invalidJson))

            let escapedUnicodeJson = InputByteStream("""
                "\\u3053\\u3093\\u306b\\u3061\\u306f"
            """)
            let escapedUnicode = try JSON.Value(from: escapedUnicodeJson)
            assertEqual(escapedUnicode, .string("こんにちは"))
        }
    }

    func testObject() {
        scope {
            let empty = try JSON.Value(from: InputByteStream("{}"))
            assertEqual(empty, .object([:]))

            let simple = try JSON.Value(from: InputByteStream("""
                {"key":"value"}
                """))
            assertEqual(simple, .object(["key" : .string("value")]))

            let nested = try JSON.Value(from: InputByteStream("""
                {"o":{"k":"v"}}
                """))
            assertEqual(nested, .object(["o":.object(["k" : .string("v")])]))

            let whitespace = try JSON.Value(from: InputByteStream("""
                {"key" : "value"}
                """))
            assertEqual(whitespace, .object(["key" : .string("value")]))

            let separator = try JSON.Value(from: InputByteStream("""
                {"k1":"v1", "k2":"v2"}
                """))
            let expected: JSON.Value = .object(
                ["k1" : .string("v1"), "k2" : .string("v2")])
            assertEqual(separator, expected)
        }
    }

    func testArray() {
        scope {
            let empty = try JSON.Value(from: InputByteStream("[]"))
            assertEqual(empty, .array([]))

            let simple = try JSON.Value(from: InputByteStream("[1,2]"))
            assertEqual(simple, .array([.number(.uint(1)), .number(.uint(2))]))

            let strings = try JSON.Value(from: InputByteStream("""
                ["one", "two"]
                """))
            assertEqual(strings, .array([.string("one"), .string("two")]))
        }
    }

    func testNested() {
        scope {
            let objectInArray = try JSON.Value(from: InputByteStream("""
                ["one", 2, {"key": false}]
                """))
            assertEqual(objectInArray, .array([
                .string("one"),
                .number(.uint(2)),
                .object(["key": .bool(false)])]))

            let arrayInObject = try JSON.Value(from: InputByteStream("""
                {"values" : [1,true]}
                """))
            assertEqual(arrayInObject, .object(
                ["values": .array([.number(.uint(1)), .bool(true)])]))
        }
    }
}
