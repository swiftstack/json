import Testing
import Stream

@testable import JSON

@Test("Decoder KeyedContainer")
func decoderKeyedContainer() async throws {
    let stream = MemoryStream("""
        {"answer":42}
        """)
    let value = try await JSON.Value.decode(from: stream)
    let decoder = try JSON.Decoder(value)
    enum Keys: CodingKey {
        case answer
    }
    let container = try decoder.container(keyedBy: Keys.self)
    let answer = try container.decode(Int.self, forKey: .answer)
    #expect(answer == 42)
}

@Test("Decoder UnkeyedContainer")
func decoderUnkeyedContainer() async throws {
    let stream = MemoryStream("[1,[2],[3],4]")
    let value = try await JSON.Value.decode(from: stream)
    let decoder = try JSON.Decoder(value)
    var container = try decoder.unkeyedContainer()
    let int1 = try container.decode(Int.self)
    var nested1 = try container.nestedUnkeyedContainer()
    let int2 = try nested1.decode(Int.self)
    var nested2 = try container.nestedUnkeyedContainer()
    let int3 = try nested2.decode(Int.self)
    let int4 = try container.decode(Int.self)
    #expect(int1 == 1)
    #expect(int2 == 2)
    #expect(int3 == 3)
    #expect(int4 == 4)
}

@Test("Decoder SingleValueContainer")
func decoderSingleValueContainer() async throws {
    let stream = MemoryStream("true")
    let value = try await JSON.Value.decode(from: stream)
    let decoder = try JSON.Decoder(value)
    let container = try decoder.singleValueContainer()
    let bool = try container.decode(Bool.self)
    #expect(bool == true)
}
