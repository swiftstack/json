import Testing

@testable import JSON

@Test("JSON.Value.object(_)")
func object() async throws {
    let value = JSON.Value.object(["key": .string("value")])
    #expect(value["key"] == .string("value"))
}

@Test("JSON.Value.array(_)")
func array() async throws {
    let value = JSON.Value.array([.number(.int(42))])
    #expect(value[0] == .number(.int(42)))
}

@Test("SON.Value.bool(_)")
func boolean() async throws {
    let value = JSON.Value.bool(true)
    #expect(value.booleanValue == true)
}

@Test("JSON.Value.number(.int(_))")
func integer() async throws {
    let value = JSON.Value.number(.int(42))
    #expect(value.integerValue == 42)
    #expect(value.unsignedValue == 42)
}

@Test("JSON.Value.number(.uint(_))")
func unsigned() async throws {
    let value = JSON.Value.number(.uint(42))
    #expect(value.unsignedValue == 42)
    #expect(value.integerValue == 42)
}

@Test("JSON.Value.number(.double(_))")
func double() async throws {
    let value = JSON.Value.number(.double(40.2))
    #expect(value.doubleValue == 40.2)
}

@Test("JSON.Value.string(_)")
func string() async throws {
    let value = JSON.Value.string("value")
    #expect(value.stringValue == "value")
}
