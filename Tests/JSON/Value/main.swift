import Test

@testable import JSON

test.case("Object") {
    let value = JSON.Value.object(["key": .string("value")])
    expect(value["key"] == .string("value"))
}

test.case("Array") {
    let value = JSON.Value.array([.number(.int(42))])
    expect(value[0] == .number(.int(42)))
}

test.case("Boolean") {
    let value = JSON.Value.bool(true)
    expect(value.booleanValue == true)
}

test.case("Integer") {
    let value = JSON.Value.number(.int(42))
    expect(value.integerValue == 42)
    expect(value.unsignedValue == 42)
}

test.case("Unsigned") {
    let value = JSON.Value.number(.uint(42))
    expect(value.unsignedValue == 42)
    expect(value.integerValue == 42)
}

test.case("Double") {
    let value = JSON.Value.number(.double(40.2))
    expect(value.doubleValue == 40.2)
}

test.case("String") {
    let value = JSON.Value.string("value")
    expect(value.stringValue == "value")
}

test.run()
