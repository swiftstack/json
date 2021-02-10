import Test

@testable import JSON

test.case("Get") {
    let value = JSON.Value.object(["key": .string("value")])
    expect(value.key == .string("value"))
}

test.case("Set") {
    var value = JSON.Value.null
    value.key = .string("value")
    expect(value == .object(["key": .string("value")]))
}

test.run()
