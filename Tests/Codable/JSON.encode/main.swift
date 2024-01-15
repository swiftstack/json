import Test

@testable import JSON

test("Keyed") {
    let expected = #"{"answer":42,"hello":"Hello, World"}"#
    struct Model: Encodable {
        let answer: Int = 42
        let hello: String = "Hello, World"
    }
    let bytes = try JSON.encode(Model())
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == expected)
}

test("KeyedNested") {
    let expected = #"{"answer":42,"nested":{"hello":"Hello, World"}}"#
    struct Model: Encodable {
        struct Nested: Encodable {
            let hello = "Hello, World"
        }
        let answer: Int = 42
        let nested = Nested()
    }
    let bytes = try JSON.encode(Model())
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == expected)
}

test("KeyedInTheMiddle") {
    let expected = #"{"nested":{"hello":"Hello, World"},"answer":42}"#
    struct Model: Encodable {
        struct Nested: Encodable {
            let hello = "Hello, World"
        }
        let nested = Nested()
        let answer: Int = 42
    }
    let bytes = try JSON.encode(Model())
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == expected)
}

test("NestedInTheMiddle") {
    let expected = #"{"nested":{"array":[1,2]},"answer":42}"#
    struct Model: Encodable {
        struct Nested: Encodable {
            let array: [Int] = [1,2]
        }
        let nested = Nested()
        let answer: Int = 42
    }
    let bytes = try JSON.encode(Model())
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == expected)
}

test("NestedArrayInTheMiddle") {
    let expected = #"{"nested":{"array":[[1,2],[3,4]]},"answer":42}"#
    struct Model: Encodable {
        struct Nested: Encodable {
            let array: [[Int]] = [[1,2],[3,4]]
        }
        let nested = Nested()
        let answer: Int = 42
    }
    let bytes = try JSON.encode(Model())
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == expected)
}

test("Unkeyed") {
    let bytes = try JSON.encode([1,2,3])
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == "[1,2,3]")
}

test("UnkeyedOfUnkeyed") {
    let bytes = try JSON.encode([[1,2],[3,4]])
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == "[[1,2],[3,4]]")
}

test("Enum") {
    let expected = #"{"single":1,"array":[1,2,3]}"#
    enum Number: Int, Encodable {
        case one = 1
        case two
        case three
    }
    struct Model: Encodable {
        let single: Number = .one
        let array: [Number] = [.one, .two, .three]
    }
    let bytes = try JSON.encode(Model())
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == expected)
}

test("Encodable") {
    let expected = #"{"answer":42,"hello":"Hello, World"}"#
    struct Model: Encodable {
        let answer: Int = 42
        let hello: String = "Hello, World"
    }
    let encodable = Model() as Encodable
    let bytes = try JSON.encode(encodable: encodable)
    let json = String(decoding: bytes, as: UTF8.self)
    expect(json == expected)
}

await run()
