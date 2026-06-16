import Testing
import Stream

@testable import JSON

@Test("OutputStream null")
func outputStreamNull() async throws {
    let stream = MemoryStream()
    let value: JSON.Value = .null
    try await value.encode(to: stream)
    #expect(stream.stringValue == "null")
}

@Test("OutputStream bool")
func outputStreamBool() async throws {
    var stream = MemoryStream()
    let jsonTrue: JSON.Value = .bool(true)
    try await jsonTrue.encode(to: stream)
    #expect(stream.stringValue == "true")

    stream = MemoryStream()
    let jsonFalse: JSON.Value = .bool(false)
    try await jsonFalse.encode(to: stream)
    #expect(stream.stringValue == "false")
}

@Test("OutputStream number")
func outputStreamNumber() async throws {
    var stream = MemoryStream()
    let uint: JSON.Value = .number(.uint(42))
    try await uint.encode(to: stream)
    #expect(stream.stringValue == "42")

    stream = MemoryStream()
    let int: JSON.Value = .number(.int(-42))
    try await int.encode(to: stream)
    #expect(stream.stringValue == "-42")

    stream = MemoryStream()
    let double: JSON.Value = .number(.double(-42.42))
    try await double.encode(to: stream)
    #expect(stream.stringValue == "-42.42")
}

@Test("OutputStream string")
func outputStreamString() async throws {
    var stream = MemoryStream()
    let string: JSON.Value = .string("string")
    try await string.encode(to: stream)
    #expect(stream.stringValue == "\"string\"")

    stream = MemoryStream()
    let escapedJson: JSON.Value = .string("string\r\n")
    try await escapedJson.encode(to: stream)
    #expect(stream.stringValue == "\"string\r\n\"")

    stream = MemoryStream()
    let escapedUnicode: JSON.Value = .string("こんにちは")
    try await escapedUnicode.encode(to: stream)
    // TODO: Do we need to escape?
    #expect(stream.stringValue == "\"こんにちは\"")
}

@Test("OutputStream keyed")
func outputStreamKeyed() async throws {
    var stream = MemoryStream()
    let empty: JSON.Value = .object([:])
    try await empty.encode(to: stream)
    #expect(stream.stringValue == "{}")

    stream = MemoryStream()
    let simple: JSON.Value = .object(["key": .string("value")])
    try await simple.encode(to: stream)
    #expect(stream.stringValue == #"{"key":"value"}"#)

    stream = MemoryStream()
    let nested: JSON.Value = .object(["o": .object(["k": .string("v")])])
    try await nested.encode(to: stream)
    #expect(stream.stringValue == #"{"o":{"k":"v"}}"#)
}

@Test("OutputStream unkeyed")
func outputStreamUnkeyed() async throws {
    var stream = MemoryStream()
    let empty: JSON.Value = .array([])
    try await empty.encode(to: stream)
    #expect(stream.stringValue == "[]")

    stream = MemoryStream()
    let simple: JSON.Value = .array([.number(.uint(1)), .number(.uint(2))])
    try await simple.encode(to: stream)
    #expect(stream.stringValue == "[1,2]")

    stream = MemoryStream()
    let strings: JSON.Value = .array([.string("one"), .string("two")])
    try await strings.encode(to: stream)
    #expect(stream.stringValue == #"["one","two"]"#)
}

@Test("OutputStream nested")
func outputStreamNested() async throws {
    var stream = MemoryStream()
    let objectInArray: JSON.Value = .array([
        .string("one"),
        .number(.uint(2)),
        .object(["key": .bool(false)])])
    try await objectInArray.encode(to: stream)
    #expect(stream.stringValue == #"["one",2,{"key":false}]"#)

    stream = MemoryStream()
    let arrayInObject: JSON.Value = .object(
        ["values": .array([.number(.uint(1)), .bool(true)])])
    try await arrayInObject.encode(to: stream)
    #expect(stream.stringValue == #"{"values":[1,true]}"#)
}
