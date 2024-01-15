import Test
import Stream

@testable import JSON

test("KeyedContainer") {
    let stream = InputByteStream("""
        {"answer":42}
        """)
    let decoder = try await JSON.Decoder(stream)
    enum Keys: CodingKey {
        case answer
    }
    let container = try decoder.container(keyedBy: Keys.self)
    let answer = try container.decode(Int.self, forKey: .answer)
    expect(answer == 42)
}

test("UnkeyedContainer") {
    let stream = InputByteStream("[1,[2],[3],4]")
    let decoder = try await JSON.Decoder(stream)
    var container = try decoder.unkeyedContainer()
    let int1 = try container.decode(Int.self)
    var nested1 = try container.nestedUnkeyedContainer()
    let int2 = try nested1.decode(Int.self)
    var nested2 = try container.nestedUnkeyedContainer()
    let int3 = try nested2.decode(Int.self)
    let int4 = try container.decode(Int.self)
    expect(int1 == 1)
    expect(int2 == 2)
    expect(int3 == 3)
    expect(int4 == 4)
}

test("SingleValueContainer") {
    let stream = InputByteStream("true")
    let decoder = try await JSON.Decoder(stream)
    let container = try decoder.singleValueContainer()
    let bool = try container.decode(Bool.self)
    expect(bool == true)
}

await run()
