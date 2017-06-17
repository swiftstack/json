import Test
@testable import JSON

class JSONEncoderTests: TestCase {
    func testKeyed() {
        let expected = """
            {"answer":42,"hello":"Hello, World"}
            """
        struct Model: Encodable {
            let answer: Int = 42
            let hello: String = "Hello, World"
        }
        let json = try? JSONEncoder().encode(Model())
        assertEqual(json, expected)
    }

    func testKeyedNested() {
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
        let json = try? JSONEncoder().encode(Model())
        assertEqual(json, expected)
    }

    func testKeyedInTheMiddle() {
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
        let json = try? JSONEncoder().encode(Model())
        assertEqual(json, expected)
    }

    func testNestedInTheMiddle() {
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
        let json = try? JSONEncoder().encode(Model())
        assertEqual(json, expected)
    }

    func testNestedArrayInTheMiddle() {
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
        let json = try? JSONEncoder().encode(Model())
        assertEqual(json, expected)
    }

    func testEncodeUnkeyed() {
        let expected = "[1,2,3]"
        let json = try? JSONEncoder().encode([1,2,3])
        assertEqual(json, expected)
    }

    func testEncodeUnkeyedOfUnkeyed() {
        let expected = "[[1,2],[3,4]]"
        let json = try? JSONEncoder().encode([[1,2],[3,4]])
        assertEqual(json, expected)
    }

    func testEnum() {
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
        let json = try? JSONEncoder().encode(Model())
        assertEqual(json, expected)
    }
}
