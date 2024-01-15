import Test

@testable import JSON

test("Get") {
    let value = JSON.Value.object(["key": .string("value")])
    expect(value.key == .string("value"))
}

test("Set") {
    var value = JSON.Value.null
    value.key = .string("value")
    expect(value == .object(["key": .string("value")]))
}

await run()
