import Test
@testable import JSON

class JSONValueTests: TestCase {
    func testNull() {
        do {
            let null = try JSONValue(from: [UInt8]("null".utf8))
            assertEqual(null, .null)
        } catch {
            fail(String(describing: error))
        }
    }

    func testBool() {
        do {
            let jsonTrue = try JSONValue(from: [UInt8]("true".utf8))
            assertEqual(jsonTrue, .bool(true))

            let jsonFalse = try JSONValue(from: [UInt8]("false".utf8))
            assertEqual(jsonFalse, .bool(false))
        } catch {
            fail(String(describing: error))
        }
    }

    func testNumber() {
        do {
            let uint = try JSONValue(from: [UInt8]("42".utf8))
            assertEqual(uint, .number(.uint(42)))

            let int = try JSONValue(from: [UInt8]("-42".utf8))
            assertEqual(int, .number(.int(-42)))

            let double = try JSONValue(from: [UInt8]("-42.42".utf8))
            assertEqual(double, .number(.double(-42.42)))
        } catch {
            fail(String(describing: error))
        }
    }

    func testString() {
        do {
            let string = try JSONValue(from: [UInt8]("\"string\"".utf8))
            assertEqual(string, .string("string"))

            let escapedString = try JSONValue(from: [UInt8]("\"string\\r\\n\"".utf8))
            assertEqual(escapedString, .string("string\r\n"))

            assertThrowsError(try JSONValue(from: [UInt8]("\"string\r\n\"".utf8)))

            let json = [UInt8]("\"\\u3053\\u3093\\u306b\\u3061\\u306f\"".utf8)
            let escapedUnicode = try JSONValue(from: json)
            assertEqual(escapedUnicode, .string("こんにちは"))
        } catch {
            fail(String(describing: error))
        }
    }

    func testObject() {
        do {
            let empty = try JSONValue(from: [UInt8]("{}".utf8))
            assertEqual(empty, .object([:]))

            let simple = try JSONValue(from: [UInt8]("""
                {"key":"value"}
                """.utf8))
            assertEqual(simple, .object(["key" : .string("value")]))

            let nested = try JSONValue(from: [UInt8]("""
                {"o":{"k":"v"}}
                """.utf8))
            assertEqual(nested, .object(["o":.object(["k" : .string("v")])]))

            let whitespace = try JSONValue(from: [UInt8]("""
                {"key" : "value"}
                """.utf8))
            assertEqual(whitespace, .object(["key" : .string("value")]))

            let separator = try JSONValue(from: [UInt8]("""
                {"k1":"v1", "k2":"v2"}
                """.utf8))
            let expected: JSONValue = .object(
                ["k1" : .string("v1"), "k2" : .string("v2")])
            assertEqual(separator, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testArray() {
        do {
            let empty = try JSONValue(from: [UInt8]("[]".utf8))
            assertEqual(empty, .array([]))

            let simple = try JSONValue(from: [UInt8]("[1,2]".utf8))
            assertEqual(simple, .array([.number(.uint(1)), .number(.uint(2))]))

            let strings = try JSONValue(from: [UInt8]("""
                ["one", "two"]
                """.utf8))
            assertEqual(strings, .array([.string("one"), .string("two")]))

        } catch {
            fail(String(describing: error))
        }
    }

    func testNested() {
        do {
            let objectInArray = try JSONValue(from: [UInt8]("""
                ["one", 2, {"key": false}]
                """.utf8))
            assertEqual(objectInArray, .array([
                .string("one"),
                .number(.uint(2)),
                .object(["key": .bool(false)])
                ]))

            let arrayInObject = try JSONValue(from: [UInt8]("""
                {"values" : [1,true]}
                """.utf8))
            assertEqual(arrayInObject, .object(
                ["values": .array([.number(.uint(1)), .bool(true)])]
                ))
        } catch {
            fail(String(describing: error))
        }
    }
}
