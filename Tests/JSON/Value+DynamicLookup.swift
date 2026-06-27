import Testing

@testable import JSON

@Test("DynamicLookup get")
func dynamicLookupGet() async throws {
    let value = JSON.Value.object(["key": .string("value")])
    #expect(value.key == .string("value"))
}

@Test("DynamicLookup set")
func dynamicLookupSet() async throws {
    var value = JSON.Value.object([:])
    value.key = .string("value")
    #expect(value == .object(["key": .string("value")]))
}

@Test("DynamicLookup invalid type")
func dynamicLookupInvalidType() async throws {
    var value = JSON.Value.number(.uint(42))
    value.key = .string("value")
    #expect(value == .number(.uint(42)))
}
