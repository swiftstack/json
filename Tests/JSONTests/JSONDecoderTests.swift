import Test
import Stream
@testable import JSON

class JSONDecoderTests: TestCase {
    func testKeyed() {
        scope {
            let json = InputByteStream("""
            {"answer":42,"hello":"Hello, World!"}
            """)
            struct Model: Decodable {
                let answer: Int
                let hello: String
            }
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.answer, 42)
            assertEqual(object.hello, "Hello, World!")
        }
    }

    func testKeyedNested() {
        scope {
            let json = InputByteStream("""
            {"answer":42,"nested":{"hello":"Hello, World!"}}
            """)
            struct Model: Decodable {
                struct Nested: Decodable {
                    let hello: String
                }
                let answer: Int
                let nested: Nested
            }
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.answer, 42)
            assertEqual(object.nested.hello, "Hello, World!")
        }
    }

    func testKeyedNestedInTheMiddle() {
        scope {

        }
        let json = InputByteStream("""
        {"nested":{"hello":"Hello, World!"},"answer":42}
        """)
        struct Model: Decodable {
            struct Nested: Decodable {
                let hello: String
            }
            let nested: Nested
            let answer: Int
        }
        do {
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.nested.hello, "Hello, World!")
            assertEqual(object.answer, 42)
        } catch {
            fail(String(describing: error))
        }
    }

    func testNestedArrayInTheMiddle() {
        scope {

        }
        let json = InputByteStream("""
        {"nested":{"array":[1,2]},"answer":42}
        """)
        struct Model: Decodable {
            struct Nested: Decodable {
                let array: [Int]
            }
            let nested: Nested
            let answer: Int
        }
        do {
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.nested.array, [1,2])
            assertEqual(object.answer, 42)
        } catch {
            fail(String(describing: error))
        }
    }

    func testNestedArraysInTheMiddle() {
        scope {
            let json = InputByteStream("""
            {"nested":{"array":[[1,2],[3,4]]},"answer":42}
            """)
            struct Model: Decodable {
                struct Nested: Decodable {
                    let array: [[Int]]
                }
                let nested: Nested
                let answer: Int
            }
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.nested.array.first ?? [], [1,2])
            assertEqual(object.nested.array.last ?? [], [3,4])
            assertEqual(object.answer, 42)
        }
    }

    func testUnkeyed() {
        scope {
            let json = InputByteStream("[1,2,3]")
            let object = try JSONDecoder().decode([Int].self, from: json)
            assertEqual(object, [1,2,3])
        }
    }

    func testUnkeyedOfUnkeyed() {
        scope {
            let json = InputByteStream("[[1,2],[3,4]]")
            let object = try JSONDecoder().decode([[Int]].self, from: json)
            assertEqual(object.first ?? [], [1,2])
            assertEqual(object.last ?? [], [3,4])
        }
    }

    func testEnum() {
        scope {
            let json = InputByteStream("""
            {"single":1,"array":[1,2,3]}
            """)
            enum Number: Int, Decodable {
                case one = 1
                case two
                case three
            }
            struct Model: Decodable {
                let single: Number
                let array: [Number] = [.one, .two, .three]
            }
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.single, .one)
            assertEqual(object.array, [.one, .two, .three])
        }
    }

    func testDecodable() {
        scope {
            let json = InputByteStream("""
            {"answer":42,"hello":"Hello, World!"}
            """)
            struct Model: Decodable {
                let answer: Int
                let hello: String
            }
            let type: Decodable.Type = Model.self
            let decodable = try JSONDecoder().decode(decodable: type, from: json)
            guard let object = decodable as? Model else {
                fail()
                return
            }
            assertEqual(object.answer, 42)
            assertEqual(object.hello, "Hello, World!")
        }
    }
}
