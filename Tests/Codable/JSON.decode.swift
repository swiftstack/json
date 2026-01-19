import Testing
import Stream

@testable import JSON

@Test("JSON.decode keyed")
func decodeKeyed() async throws {
    let json = ByteArrayInputStream(#"{"answer":42,"hello":"Hello, World!"}"#)
    struct Model: Decodable {
        let answer: Int
        let hello: String
    }
    let model = try await JSON.decode(Model.self, from: json)
    #expect(model.answer == 42)
    #expect(model.hello == "Hello, World!")
}

@Test("JSON.decode formatted")
func decodeEscaped() async throws {
    let json = ByteArrayInputStream("""
        {
            "answer":42,
            "hello":"Hello, World!"
        }
        """)
    struct Model: Decodable {
        let answer: Int
        let hello: String
    }
    let model = try await JSON.decode(Model.self, from: json)
    #expect(model.answer == 42)
    #expect(model.hello == "Hello, World!")
}

@Test("JSON.decode escaped unicode")
func decodeEscapedUnicode() async throws {
    let json = ByteArrayInputStream(
        #"{"hello":"\u3053\u3093\u306b\u3061\u306f"}"#)
    struct Model: Decodable {
        let hello: String
    }
    let model = try await JSON.decode(Model.self, from: json)
    #expect(model.hello == "こんにちは")
}

@Test("JSON.decode nested keyed")
func decodeKeyedNested() async throws {
    let json = ByteArrayInputStream(
        #"{"answer":42,"nested":{"hello":"Hello, World!"}}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let hello: String
        }
        let answer: Int
        let nested: Nested
    }
    let object = try await JSON.decode(Model.self, from: json)
    #expect(object.answer == 42)
    #expect(object.nested.hello == "Hello, World!")
}

@Test("JSON.decode nested keyed in the middle")
func decodeKeyedNestedInTheMiddle() async throws {
    let json = ByteArrayInputStream(
        #"{"nested":{"hello":"Hello, World!"},"answer":42}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let hello: String
        }
        let nested: Nested
        let answer: Int
    }
    let object = try await JSON.decode(Model.self, from: json)
    #expect(object.nested.hello == "Hello, World!")
    #expect(object.answer == 42)
}

@Test("JSON.decode nested array in the middle")
func decodeNestedArrayInTheMiddle() async throws {
    let json = ByteArrayInputStream(
        #"{"nested":{"array":[1,2]},"answer":42}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let array: [Int]
        }
        let nested: Nested
        let answer: Int
    }
    let object = try await JSON.decode(Model.self, from: json)
    #expect(object.nested.array == [1, 2])
    #expect(object.answer == 42)
}

@Test("JSON.decode nested arrays in the middle")
func decodeNestedArraysInTheMiddle() async throws {
    let json = ByteArrayInputStream(
        #"{"nested":{"array":[[1,2],[3,4]]},"answer":42}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let array: [[Int]]
        }
        let nested: Nested
        let answer: Int
    }
    let object = try await JSON.decode(Model.self, from: json)
    #expect(object.nested.array.first ?? [] == [1, 2])
    #expect(object.nested.array.last ?? [] == [3, 4])
    #expect(object.answer == 42)
}

@Test("JSON.decode unkeyed")
func decodeUnkeyed() async throws {
    let json = ByteArrayInputStream("[1,2,3]")
    let object = try await JSON.decode([Int].self, from: json)
    #expect(object == [1, 2, 3])
}

@Test("Decode unkeyed of unkeyed")
func decodeUnkeyedOfUnkeyed() async throws {
    let json = ByteArrayInputStream("[[1,2],[3,4]]")
    let object = try await JSON.decode([[Int]].self, from: json)
    #expect(object.first ?? [] == [1, 2])
    #expect(object.last ?? [] == [3, 4])
}

@Test("Decode enum")
func decodeEnum() async throws {
    let json = ByteArrayInputStream(#"{"single":1,"array":[1,2,3]}"#)
    enum Number: Int, Decodable {
        case one = 1
        case two
        case three
    }
    struct Model: Decodable {
        let single: Number
        let array: [Number]
    }
    let object = try await JSON.decode(Model.self, from: json)
    #expect(object.single == .one)
    #expect(object.array == [.one, .two, .three])
}

@Test("Decode Decodable")
func decodeDecodable() async throws {
    let json = ByteArrayInputStream(#"{"answer":42,"hello":"Hello, World!"}"#)
    struct Model: Decodable {
        let answer: Int
        let hello: String
    }
    let type: Decodable.Type = Model.self
    let decodable = try await JSON.decode(decodable: type, from: json)
    let object = try #require(decodable as? Model)
    #expect(object.answer == 42)
    #expect(object.hello == "Hello, World!")
}
