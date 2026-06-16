import Testing
import Stream

@testable import JSON

@Test("InputStream null")
func inputStreamNull() async throws {
    let null = try await JSON.Value.decode(from: MemoryStream("null"))
    #expect(null == .null)
}

@Test("InputStream bool")
func inputStreamBool() async throws {
    let jsonTrue = try await JSON.Value.decode(from: MemoryStream("true"))
    #expect(jsonTrue == .bool(true))

    let jsonFalse = try await JSON.Value.decode(from: MemoryStream("false"))
    #expect(jsonFalse == .bool(false))
}

@Test("InputStream number")
func inputStreamNumber() async throws {
    let uint = try await JSON.Value.decode(from: MemoryStream("42"))
    #expect(uint == .number(.uint(42)))

    let int = try await JSON.Value.decode(from: MemoryStream("-42"))
    #expect(int == .number(.int(-42)))

    let double = try await JSON.Value.decode(from: MemoryStream("-42.42"))
    #expect(double == .number(.double(-42.42)))

    let dble = try await JSON.Value.decode(from: MemoryStream("-.42"))
    #expect(dble == .number(.double(-0.42)))

    let exp = try await JSON.Value.decode(from: MemoryStream("4.2e1"))
    #expect(exp == .number(.double(42)))

    await #expect(throws: JSON.Error.invalidJSON) {
        try await JSON.Value.decode(from: MemoryStream("-\(UInt.max)"))
    }

    await #expect(throws: Never.self) {
        try await JSON.Value.decode(from: MemoryStream("-\(Int.max)"))
    }
}

@Test("InputStream string")
func inputStreamString() async throws {
    let json = MemoryStream("\"string\"")
    let string = try await JSON.Value.decode(from: json)
    #expect(string == .string("string"))
}

@Test("InputStream escaped string")
func inputStreamEsapedString() async throws {
    let escapedJson = MemoryStream("\"string\\r\\n\"")
    let escapedString = try await JSON.Value.decode(from: escapedJson)
    #expect(escapedString == .string("string\r\n"))
}

@Test("InputStream invalid escaped string")
func inputStreamInvalidEscapedString() async throws {
    let invalidJson = MemoryStream("\"string\r\n\"")
    await #expect(throws: JSON.Error.invalidJSON) {
        try await JSON.Value.decode(from: invalidJson)
    }
}

@Test("InputStream escaped unicode string")
func inputStreamEscapedUnicodeString() async throws {
    let escapedUnicodeJson = MemoryStream(
        #""\u3053\u3093\u306b\u3061\u306f""#)
    let escapedUnicode = try await JSON.Value.decode(from: escapedUnicodeJson)
    #expect(escapedUnicode == .string("こんにちは"))
}

@Test("InputStream empty keyed")
func inputStreamEmptyKeyed() async throws {
    let empty = try await JSON.Value.decode(from: MemoryStream("{}"))
    #expect(empty == .object([:]))
}

@Test("InputStream simple keyed")
func inputStreamSimpleKeyed() async throws {
    let stream = MemoryStream(#"{"key":"value"}"#)
    let simple = try await JSON.Value.decode(from: stream)
    #expect(simple == .object(["key": .string("value")]))
}

@Test("InputStream nested keyed")
func inputStreamNestedKeyed() async throws {
    let stream = MemoryStream(#"{"o":{"k":"v"}}"#)
    let nested = try await JSON.Value.decode(from: stream)
    #expect(nested == .object(["o": .object(["k": .string("v")])]))
}

@Test("InputStream whitespace in keyed")
func inputStreamWhitespaceInKeyed() async throws {
    let whitespace = try await JSON.Value.decode(from: MemoryStream(
        #"{"key" : "value"}"#))
    #expect(whitespace == .object(["key": .string("value")]))
}

@Test("InputStream whitespace between keyed values")
func inputStreamWhitespaceBetweenKeyedValues() async throws {
    let separator = try await JSON.Value.decode(from: MemoryStream(
        #"{"k1":"v1", "k2":"v2"}"#))
    let expected: JSON.Value = .object([
        "k1": .string("v1"),
        "k2": .string("v2")])
    #expect(separator == expected)
}

@Test("InputStream unkeyed")
func inputStreamUnkeyed() async throws {
    let empty = try await JSON.Value.decode(from: MemoryStream("[]"))
    #expect(empty == .array([]))

    let simple = try await JSON.Value.decode(from: MemoryStream("[1,2]"))
    #expect(simple == .array([.number(.uint(1)), .number(.uint(2))]))

    let strings = try await JSON.Value.decode(from: MemoryStream(
        #"["one", "two"]"#))
    #expect(strings == .array([.string("one"), .string("two")]))
}

@Test("InputStream nested")
func inputStreamNested() async throws {
    let objectInArray = try await JSON.Value.decode(from: MemoryStream(
        #"["one", 2, {"key": false}]"#))
    #expect(objectInArray == .array([
        .string("one"),
        .number(.uint(2)),
        .object(["key": .bool(false)])]))

    let arrayInObject = try await JSON.Value.decode(from: MemoryStream(
        #"{"values" : [1,true]}"#))
    #expect(arrayInObject == .object(
        ["values": .array([.number(.uint(1)), .bool(true)])]))
}
