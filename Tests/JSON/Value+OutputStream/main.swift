import Test
import Stream

@testable import JSON

test("Null") {
    let stream = OutputByteStream()
    let value: JSON.Value = .null
    try await value.encode(to: stream)
    expect(stream.stringValue == "null")
}

test("Bool") {
    var stream = OutputByteStream()
    let jsonTrue: JSON.Value = .bool(true)
    try await jsonTrue.encode(to: stream)
    expect(stream.stringValue == "true")

    stream = OutputByteStream()
    let jsonFalse: JSON.Value = .bool(false)
    try await jsonFalse.encode(to: stream)
    expect(stream.stringValue == "false")
}

test("Number") {
    var stream = OutputByteStream()
    let uint: JSON.Value = .number(.uint(42))
    try await uint.encode(to: stream)
    expect(stream.stringValue == "42")

    stream = OutputByteStream()
    let int: JSON.Value = .number(.int(-42))
    try await int.encode(to: stream)
    expect(stream.stringValue == "-42")

    stream = OutputByteStream()
    let double: JSON.Value = .number(.double(-42.42))
    try await double.encode(to: stream)
    expect(stream.stringValue == "-42.42")
}

test("String") {
    var stream = OutputByteStream()
    let string: JSON.Value = .string("string")
    try await string.encode(to: stream)
    expect(stream.stringValue == "\"string\"")

    stream = OutputByteStream()
    let escapedJson: JSON.Value = .string("string\r\n")
    try await escapedJson.encode(to: stream)
    expect(stream.stringValue == "\"string\r\n\"")

    stream = OutputByteStream()
    let escapedUnicode: JSON.Value = .string("こんにちは")
    try await escapedUnicode.encode(to: stream)
    // TODO: Do we need to escape?
    expect(stream.stringValue == "\"こんにちは\"")
}

test("Object") {
    var stream = OutputByteStream()
    let empty: JSON.Value = .object([:])
    try await empty.encode(to: stream)
    expect(stream.stringValue == "{}")

    stream = OutputByteStream()
    let simple: JSON.Value = .object(["key": .string("value")])
    try await simple.encode(to: stream)
    expect(stream.stringValue == #"{"key":"value"}"#)

    stream = OutputByteStream()
    let nested: JSON.Value = .object(["o": .object(["k": .string("v")])])
    try await nested.encode(to: stream)
    expect(stream.stringValue == #"{"o":{"k":"v"}}"#)
}

test("Array") {
    var stream = OutputByteStream()
    let empty: JSON.Value = .array([])
    try await empty.encode(to: stream)
    expect(stream.stringValue == "[]")

    stream = OutputByteStream()
    let simple: JSON.Value = .array([.number(.uint(1)), .number(.uint(2))])
    try await simple.encode(to: stream)
    expect(stream.stringValue == "[1,2]")

    stream = OutputByteStream()
    let strings: JSON.Value = .array([.string("one"), .string("two")])
    try await strings.encode(to: stream)
    expect(stream.stringValue == #"["one","two"]"#)
}

test("Nested") {
    var stream = OutputByteStream()
    let objectInArray: JSON.Value = .array([
        .string("one"),
        .number(.uint(2)),
        .object(["key": .bool(false)])])
    try await objectInArray.encode(to: stream)
    expect(stream.stringValue == #"["one",2,{"key":false}]"#)

    stream = OutputByteStream()
    let arrayInObject: JSON.Value = .object(
        ["values": .array([.number(.uint(1)), .bool(true)])])
    try await arrayInObject.encode(to: stream)
    expect(stream.stringValue == #"{"values":[1,true]}"#)
}

await run()
