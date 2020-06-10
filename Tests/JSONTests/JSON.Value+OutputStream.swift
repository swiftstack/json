import Test
import Stream
@testable import JSON

class JSONValueToStreamTests: TestCase {
    func testNull() throws {
        let stream = OutputByteStream()
        let value: JSON.Value = .null
        try value.encode(to: stream)
        expect(stream.stringValue == "null")
    }

    func testBool() throws {
        var stream = OutputByteStream()
        let jsonTrue: JSON.Value = .bool(true)
        try jsonTrue.encode(to: stream)
        expect(stream.stringValue == "true")

        stream = OutputByteStream()
        let jsonFalse: JSON.Value = .bool(false)
        try jsonFalse.encode(to: stream)
        expect(stream.stringValue == "false")
    }

    func testNumber() throws {
        var stream = OutputByteStream()
        let uint: JSON.Value = .number(.uint(42))
        try uint.encode(to: stream)
        expect(stream.stringValue == "42")

        stream = OutputByteStream()
        let int: JSON.Value = .number(.int(-42))
        try int.encode(to: stream)
        expect(stream.stringValue == "-42")

        stream = OutputByteStream()
        let double: JSON.Value = .number(.double(-42.42))
        try double.encode(to: stream)
        expect(stream.stringValue == "-42.42")
    }

    func testString() throws {
        var stream = OutputByteStream()
        let string: JSON.Value = .string("string")
        try string.encode(to: stream)
        expect(stream.stringValue == "\"string\"")

        stream = OutputByteStream()
        let escapedJson: JSON.Value = .string("string\r\n")
        try escapedJson.encode(to: stream)
        expect(stream.stringValue == "\"string\r\n\"")

        stream = OutputByteStream()
        let escapedUnicode: JSON.Value = .string("こんにちは")
        try escapedUnicode.encode(to: stream)
        // TODO: Do we need to escape?
        expect(stream.stringValue == "\"こんにちは\"")
    }

    func testObject() throws {
        var stream = OutputByteStream()
        let empty: JSON.Value = .object([:])
        try empty.encode(to: stream)
        expect(stream.stringValue == "{}")

        stream = OutputByteStream()
        let simple: JSON.Value = .object(["key": .string("value")])
        try simple.encode(to: stream)
        expect(stream.stringValue == #"{"key":"value"}"#)

        stream = OutputByteStream()
        let nested: JSON.Value = .object(["o":.object(["k":.string("v")])])
        try nested.encode(to: stream)
        expect(stream.stringValue == #"{"o":{"k":"v"}}"#)
    }

    func testArray() throws {
        var stream = OutputByteStream()
        let empty: JSON.Value = .array([])
        try empty.encode(to: stream)
        expect(stream.stringValue == "[]")

        stream = OutputByteStream()
        let simple: JSON.Value = .array([.number(.uint(1)), .number(.uint(2))])
        try simple.encode(to: stream)
        expect(stream.stringValue == "[1,2]")

        stream = OutputByteStream()
        let strings: JSON.Value = .array([.string("one"), .string("two")])
        try strings.encode(to: stream)
        expect(stream.stringValue == #"["one","two"]"#)
    }

    func testNested() throws {
        var stream = OutputByteStream()
        let objectInArray: JSON.Value = .array([
            .string("one"),
            .number(.uint(2)),
            .object(["key": .bool(false)])])
        try objectInArray.encode(to: stream)
        expect(stream.stringValue == #"["one",2,{"key":false}]"#)

        stream = OutputByteStream()
        let arrayInObject: JSON.Value = .object(
            ["values": .array([.number(.uint(1)), .bool(true)])])
        try arrayInObject.encode(to: stream)
        expect(stream.stringValue == #"{"values":[1,true]}"#)
    }
}
