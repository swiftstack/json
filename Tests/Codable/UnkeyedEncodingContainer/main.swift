import Test
import Stream

@testable import JSON

test("Container") {
    let output = OutputByteStream()
    let encoder = JSON.Encoder(output)
    var unkeyedContainer = encoder.unkeyedContainer()
    try unkeyedContainer.encode(1)
    try unkeyedContainer.encode(2)
    try encoder.close()
    expect(output.stringValue == "[1,2]")
}

test("NestedContainer") {
    let output = OutputByteStream()
    let encoder = JSON.Encoder(output)
    var unkeyedContainer = encoder.unkeyedContainer()
    var nested1 = unkeyedContainer.nestedUnkeyedContainer()
    try nested1.encode(1)
    var nested2 = unkeyedContainer.nestedUnkeyedContainer()
    try nested2.encode(2)
    try encoder.close()
    expect(output.stringValue == "[[1],[2]]")
}

test("Null") {
    let output = OutputByteStream()
    let encoder = JSON.Encoder(output)
    var unkeyedContainer = encoder.unkeyedContainer()
    try unkeyedContainer.encodeNil()
    try unkeyedContainer.encodeNil()
    try encoder.close()
    expect(output.stringValue == "[null,null]")
}

await run()
