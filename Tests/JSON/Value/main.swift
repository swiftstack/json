import Test

@testable import JSON

test("Object") {
    let value = JSON.Value.object(["key": .string("value")])
    expect(value["key"] == .string("value"))
}

test("Array") {
    let value = JSON.Value.array([.number(.int(42))])
    expect(value[0] == .number(.int(42)))
}

test("Boolean") {
    let value = JSON.Value.bool(true)
    expect(value.booleanValue == true)
}

test("Integer") {
    let value = JSON.Value.number(.int(42))
    expect(value.integerValue == 42)
    expect(value.unsignedValue == 42)
}

test("Unsigned") {
    let value = JSON.Value.number(.uint(42))
    expect(value.unsignedValue == 42)
    expect(value.integerValue == 42)
}

test("Double") {
    let value = JSON.Value.number(.double(40.2))
    expect(value.doubleValue == 40.2)
}

test("String") {
    let value = JSON.Value.string("value")
    expect(value.stringValue == "value")
}

await run()
