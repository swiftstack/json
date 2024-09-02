import Testing

@testable import JSON

@Test("DynamicLookup get")
func dynamicLookupGet() async throws {
    let value = JSON.Value.object(["key": .string("value")])
    #expect(value.key == .string("value"))
}

@Test("DynamicLookup set")
func dynamicLookupSet() async throws {
    var value = JSON.Value.null
    value.key = .string("value")
    #expect(value == .object(["key": .string("value")]))
}
