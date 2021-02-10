import Test
import Stream

@testable import JSON

test.case("Keyed") {
    let json = InputByteStream(#"{"answer":42,"hello":"Hello, World!"}"#)
    struct Model: Decodable {
        let answer: Int
        let hello: String
    }
    let model = try await JSON.decode(Model.self, from: json)
    expect(model.answer == 42)
    expect(model.hello == "Hello, World!")
}

test.case("DecodeEscaped") {
    let json = InputByteStream("""
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
    expect(model.answer == 42)
    expect(model.hello == "Hello, World!")
}

test.case("DecodeEscapedUnicode") {
    let json = InputByteStream(
        #"{"hello":"\u3053\u3093\u306b\u3061\u306f"}"#)
    struct Model: Decodable {
        let hello: String
    }
    let model = try await JSON.decode(Model.self, from: json)
    expect(model.hello == "こんにちは")
}

test.case("KeyedNested") {
    let json = InputByteStream(
        #"{"answer":42,"nested":{"hello":"Hello, World!"}}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let hello: String
        }
        let answer: Int
        let nested: Nested
    }
    let object = try await JSON.decode(Model.self, from: json)
    expect(object.answer == 42)
    expect(object.nested.hello == "Hello, World!")
}

test.case("KeyedNestedInTheMiddle") {
    let json = InputByteStream(
        #"{"nested":{"hello":"Hello, World!"},"answer":42}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let hello: String
        }
        let nested: Nested
        let answer: Int
    }
    let object = try await JSON.decode(Model.self, from: json)
    expect(object.nested.hello == "Hello, World!")
    expect(object.answer == 42)
}

test.case("NestedArrayInTheMiddle") {
    let json = InputByteStream(
        #"{"nested":{"array":[1,2]},"answer":42}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let array: [Int]
        }
        let nested: Nested
        let answer: Int
    }
    let object = try await JSON.decode(Model.self, from: json)
    expect(object.nested.array == [1,2])
    expect(object.answer == 42)
}

test.case("NestedArraysInTheMiddle") {
    let json = InputByteStream(
        #"{"nested":{"array":[[1,2],[3,4]]},"answer":42}"#)
    struct Model: Decodable {
        struct Nested: Decodable {
            let array: [[Int]]
        }
        let nested: Nested
        let answer: Int
    }
    let object = try await JSON.decode(Model.self, from: json)
    expect(object.nested.array.first ?? [] == [1,2])
    expect(object.nested.array.last ?? [] == [3,4])
    expect(object.answer == 42)
}

test.case("Unkeyed") {
    let json = InputByteStream("[1,2,3]")
    let object = try await JSON.decode([Int].self, from: json)
    expect(object == [1,2,3])
}

test.case("UnkeyedOfUnkeyed") {
    let json = InputByteStream("[[1,2],[3,4]]")
    let object = try await JSON.decode([[Int]].self, from: json)
    expect(object.first ?? [] == [1,2])
    expect(object.last ?? [] == [3,4])
}

test.case("Enum") {
    let json = InputByteStream(#"{"single":1,"array":[1,2,3]}"#)
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
    expect(object.single == .one)
    expect(object.array == [.one, .two, .three])
}

test.case("Decodable") {
    let json = InputByteStream(#"{"answer":42,"hello":"Hello, World!"}"#)
    struct Model: Decodable {
        let answer: Int
        let hello: String
    }
    let type: Decodable.Type = Model.self
    let decodable = try await JSON.decode(decodable: type, from: json)
    guard let object = decodable as? Model else {
        fail()
        return
    }
    expect(object.answer == 42)
    expect(object.hello == "Hello, World!")
}

test.run()
