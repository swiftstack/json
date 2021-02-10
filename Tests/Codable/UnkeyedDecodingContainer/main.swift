import Test
import Stream

@testable import JSON

test.case("Container") {
    let decoder = try await JSON.Decoder.asyncInit(InputByteStream("[1,2]"))
    var unkeyedContainer = try decoder.unkeyedContainer()
    expect(unkeyedContainer.count == 2)
    expect(unkeyedContainer.isAtEnd == false)

    let int1 = try unkeyedContainer.decode(Int.self)
    let int2 = try unkeyedContainer.decode(Int.self)
    expect(unkeyedContainer.isAtEnd == true)
    expect(int1 == 1)
    expect(int2 == 2)
}

test.case("NestedContainer") {
    let decoder = try await JSON.Decoder.asyncInit(InputByteStream("[[1],[2]]"))
    var unkeyedContainer = try decoder.unkeyedContainer()
    expect(unkeyedContainer.count == 2)
    expect(unkeyedContainer.isAtEnd == false)

    var nested1 = try unkeyedContainer.nestedUnkeyedContainer()
    expect(nested1.count == 1)
    expect(nested1.isAtEnd == false)
    let int1 = try nested1.decode(Int.self)
    expect(int1 == 1)
    expect(nested1.isAtEnd == true)

    var nested2 = try unkeyedContainer.nestedUnkeyedContainer()
    expect(nested2.count == 1)
    expect(nested2.isAtEnd == false)
    let int2 = try nested2.decode(Int.self)
    expect(int2 == 2)
    expect(nested2.isAtEnd == true)

    expect(unkeyedContainer.isAtEnd == true)
}

test.run()
