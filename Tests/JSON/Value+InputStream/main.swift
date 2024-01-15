import Test
import Stream

@testable import JSON

test("Null") {
    let null = try await JSON.Value.decode(from: InputByteStream("null"))
    expect(null == .null)
}

test("Bool") {
    let jsonTrue = try await JSON.Value.decode(from: InputByteStream("true"))
    expect(jsonTrue == .bool(true))

    let jsonFalse = try await JSON.Value.decode(from: InputByteStream("false"))
    expect(jsonFalse == .bool(false))
}

test("Number") {
    let uint = try await JSON.Value.decode(from: InputByteStream("42"))
    expect(uint == .number(.uint(42)))

    let int = try await JSON.Value.decode(from: InputByteStream("-42"))
    expect(int == .number(.int(-42)))

    let double = try await JSON.Value.decode(from: InputByteStream("-42.42"))
    expect(double == .number(.double(-42.42)))
}

test("String") {
    let json = InputByteStream("\"string\"")
    let string = try await JSON.Value.decode(from: json)
    expect(string == .string("string"))
}

test("EsapedString") {
    let escapedJson = InputByteStream("\"string\\r\\n\"")
    let escapedString = try await JSON.Value.decode(from: escapedJson)
    expect(escapedString == .string("string\r\n"))
}

test("InvalidEscapedString") {
    let invalidJson = InputByteStream("\"string\r\n\"")
    await expect(throws: JSON.Error.invalidJSON) {
        try await JSON.Value.decode(from: invalidJson)
    }
}

test("EscapedUnicodeString") {
    let escapedUnicodeJson = InputByteStream(
        #""\u3053\u3093\u306b\u3061\u306f""#)
    let escapedUnicode = try await JSON.Value.decode(from: escapedUnicodeJson)
    expect(escapedUnicode == .string("こんにちは"))
}

test("EmptyObject") {
    let empty = try await JSON.Value.decode(from: InputByteStream("{}"))
    expect(empty == .object([:]))
}

test("SimpleObject") {
    let stream = InputByteStream(#"{"key":"value"}"#)
    let simple = try await JSON.Value.decode(from: stream)
    expect(simple == .object(["key": .string("value")]))
}

test("NestedObject") {
    let stream = InputByteStream(#"{"o":{"k":"v"}}"#)
    let nested = try await JSON.Value.decode(from: stream)
    expect(nested == .object(["o": .object(["k": .string("v")])]))
}

test("WhitespaceInObject") {
    let whitespace = try await JSON.Value.decode(from: InputByteStream(
        #"{"key" : "value"}"#))
    expect(whitespace == .object(["key": .string("value")]))
}

test("WhitespacBetweenObjects") {
    let separator = try await JSON.Value.decode(from: InputByteStream(
        #"{"k1":"v1", "k2":"v2"}"#))
    let expected: JSON.Value = .object([
        "k1": .string("v1"),
        "k2": .string("v2")])
    expect(separator == expected)
}

test("Array") {
    let empty = try await JSON.Value.decode(from: InputByteStream("[]"))
    expect(empty == .array([]))

    let simple = try await JSON.Value.decode(from: InputByteStream("[1,2]"))
    expect(simple == .array([.number(.uint(1)), .number(.uint(2))]))

    let strings = try await JSON.Value.decode(from: InputByteStream(
        #"["one", "two"]"#))
    expect(strings == .array([.string("one"), .string("two")]))
}

test("Nested") {
    let objectInArray = try await JSON.Value.decode(from: InputByteStream(
        #"["one", 2, {"key": false}]"#))
    expect(objectInArray == .array([
        .string("one"),
        .number(.uint(2)),
        .object(["key": .bool(false)])]))

    let arrayInObject = try await JSON.Value.decode(from: InputByteStream(
        #"{"values" : [1,true]}"#))
    expect(arrayInObject == .object(
        ["values": .array([.number(.uint(1)), .bool(true)])]))
}

await run()
