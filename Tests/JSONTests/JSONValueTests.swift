import Test
import Stream
@testable import JSON

class JSONValueTests: TestCase {
    func testNull() {
        do {
            let null = try JSONValue(from: InputByteStream("null"))
            assertEqual(null, .null)
        } catch {
            fail(String(describing: error))
        }
    }

    func testBool() {
        do {
            let jsonTrue = try JSONValue(from: InputByteStream("true"))
            assertEqual(jsonTrue, .bool(true))

            let jsonFalse = try JSONValue(from: InputByteStream("false"))
            assertEqual(jsonFalse, .bool(false))
        } catch {
            fail(String(describing: error))
        }
    }

    func testNumber() {
        do {
            let uint = try JSONValue(from: InputByteStream("42"))
            assertEqual(uint, .number(.uint(42)))

            let int = try JSONValue(from: InputByteStream("-42"))
            assertEqual(int, .number(.int(-42)))

            let double = try JSONValue(from: InputByteStream("-42.42"))
            assertEqual(double, .number(.double(-42.42)))
        } catch {
            fail(String(describing: error))
        }
    }

    func testString() {
        do {
            let string = try JSONValue(from: InputByteStream("\"string\""))
            assertEqual(string, .string("string"))

            let escapedString = try JSONValue(from: InputByteStream("\"string\\r\\n\""))
            assertEqual(escapedString, .string("string\r\n"))

            assertThrowsError(try JSONValue(from: InputByteStream("\"string\r\n\"")))

            let json = InputByteStream("\"\\u3053\\u3093\\u306b\\u3061\\u306f\"")
            let escapedUnicode = try JSONValue(from: json)
            assertEqual(escapedUnicode, .string("こんにちは"))
        } catch {
            fail(String(describing: error))
        }
    }

    func testObject() {
        do {
            let empty = try JSONValue(from: InputByteStream("{}"))
            assertEqual(empty, .object([:]))

            let simple = try JSONValue(from: InputByteStream("""
                {"key":"value"}
                """))
            assertEqual(simple, .object(["key" : .string("value")]))

            let nested = try JSONValue(from: InputByteStream("""
                {"o":{"k":"v"}}
                """))
            assertEqual(nested, .object(["o":.object(["k" : .string("v")])]))

            let whitespace = try JSONValue(from: InputByteStream("""
                {"key" : "value"}
                """))
            assertEqual(whitespace, .object(["key" : .string("value")]))

            let separator = try JSONValue(from: InputByteStream("""
                {"k1":"v1", "k2":"v2"}
                """))
            let expected: JSONValue = .object(
                ["k1" : .string("v1"), "k2" : .string("v2")])
            assertEqual(separator, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testArray() {
        do {
            let empty = try JSONValue(from: InputByteStream("[]"))
            assertEqual(empty, .array([]))

            let simple = try JSONValue(from: InputByteStream("[1,2]"))
            assertEqual(simple, .array([.number(.uint(1)), .number(.uint(2))]))

            let strings = try JSONValue(from: InputByteStream("""
                ["one", "two"]
                """))
            assertEqual(strings, .array([.string("one"), .string("two")]))

        } catch {
            fail(String(describing: error))
        }
    }

    func testNested() {
        do {
            let objectInArray = try JSONValue(from: InputByteStream("""
                ["one", 2, {"key": false}]
                """))
            assertEqual(objectInArray, .array([
                .string("one"),
                .number(.uint(2)),
                .object(["key": .bool(false)])
                ]))

            let arrayInObject = try JSONValue(from: InputByteStream("""
                {"values" : [1,true]}
                """))
            assertEqual(arrayInObject, .object(
                ["values": .array([.number(.uint(1)), .bool(true)])]
                ))
        } catch {
            fail(String(describing: error))
        }
    }
}
