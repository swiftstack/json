import Test
@testable import JSON

class JSONEncoderTests: TestCase {
    func testKeyed() {
        scope {
            let expected = """
            {"answer":42,"hello":"Hello, World"}
            """
            struct Model: Encodable {
                let answer: Int = 42
                let hello: String = "Hello, World"
            }
            let bytes = try JSONEncoder().encode(Model())
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }

    func testKeyedNested() {
        scope {
            let expected = """
            {"answer":42,"nested":{"hello":"Hello, World"}}
            """
            struct Model: Encodable {
                struct Nested: Encodable {
                    let hello = "Hello, World"
                }
                let answer: Int = 42
                let nested = Nested()
            }
            let bytes = try JSONEncoder().encode(Model())
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }

    func testKeyedInTheMiddle() {
        scope {
            let expected = """
            {"nested":{"hello":"Hello, World"},"answer":42}
            """
            struct Model: Encodable {
                struct Nested: Encodable {
                    let hello = "Hello, World"
                }
                let nested = Nested()
                let answer: Int = 42
            }
            let bytes = try JSONEncoder().encode(Model())
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }

    func testNestedInTheMiddle() {
        scope {
            let expected = """
            {"nested":{"array":[1,2]},"answer":42}
            """
            struct Model: Encodable {
                struct Nested: Encodable {
                    let array: [Int] = [1,2]
                }
                let nested = Nested()
                let answer: Int = 42
            }
            let bytes = try JSONEncoder().encode(Model())
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }

    func testNestedArrayInTheMiddle() {
        scope {
            let expected = """
            {"nested":{"array":[[1,2],[3,4]]},"answer":42}
            """
            struct Model: Encodable {
                struct Nested: Encodable {
                    let array: [[Int]] = [[1,2],[3,4]]
                }
                let nested = Nested()
                let answer: Int = 42
            }
            let bytes = try JSONEncoder().encode(Model())
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }

    func testUnkeyed() {
        scope {
            let bytes = try JSONEncoder().encode([1,2,3])
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, "[1,2,3]")
        }
    }

    func testUnkeyedOfUnkeyed() {
        scope {
            let bytes = try JSONEncoder().encode([[1,2],[3,4]])
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, "[[1,2],[3,4]]")
        }
    }

    func testEnum() {
        scope {
            let expected = """
            {"single":1,"array":[1,2,3]}
            """
            enum Number: Int, Encodable {
                case one = 1
                case two
                case three
            }
            struct Model: Encodable {
                let single: Number = .one
                let array: [Number] = [.one, .two, .three]
            }
            let bytes = try JSONEncoder().encode(Model())
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }

    func testEncodable() {
        scope {
            let expected = """
            {"answer":42,"hello":"Hello, World"}
            """
            struct Model: Encodable {
                let answer: Int = 42
                let hello: String = "Hello, World"
            }
            let encodable = Model() as Encodable
            let bytes = try JSONEncoder().encode(encodable: encodable)
            let json = String(decoding: bytes, as: UTF8.self)
            assertEqual(json, expected)
        }
    }
}
