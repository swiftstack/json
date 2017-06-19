import Test
@testable import JSON

class JSONDecoderTests: TestCase {
    func testKeyed() {
        let json = """
            {"answer":42,"hello":"Hello, World!"}
            """
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        do {
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.answer, 42)
            assertEqual(object.hello, "Hello, World!")
        } catch {
            fail(String(describing: error))
        }
    }

    func testKeyedNested() {
        let json = """
            {"answer":42,"nested":{"hello":"Hello, World!"}}
            """
        struct Model: Decodable {
            struct Nested: Decodable {
                let hello: String
            }
            let answer: Int
            let nested: Nested
        }
        do {
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.answer, 42)
            assertEqual(object.nested.hello, "Hello, World!")
        } catch {
            fail(String(describing: error))
        }
    }

    func testKeyedNestedInTheMiddle() {
        let json = """
            {"nested":{"hello":"Hello, World!"},"answer":42}
            """
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
        let json = """
            {"nested":{"array":[1,2]},"answer":42}
            """
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
        let json = """
            {"nested":{"array":[[1,2],[3,4]]},"answer":42}
            """
        struct Model: Decodable {
            struct Nested: Decodable {
                let array: [[Int]]
            }
            let nested: Nested
            let answer: Int
        }
        do {
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.nested.array.first ?? [], [1,2])
            assertEqual(object.nested.array.last ?? [], [3,4])
            assertEqual(object.answer, 42)
        } catch {
            fail(String(describing: error))
        }
    }

    func testEncodeUnkeyed() {
        do {
            let json = "[1,2,3]"
            let object = try JSONDecoder().decode([Int].self, from: json)
            assertEqual(object, [1,2,3])
        } catch {
            fail(String(describing: error))
        }
    }

    func testEncodeUnkeyedOfUnkeyed() {
        do {
            let json = "[[1,2],[3,4]]"
            let object = try JSONDecoder().decode([[Int]].self, from: json)
            assertEqual(object.first ?? [], [1,2])
            assertEqual(object.last ?? [], [3,4])
        } catch {
            fail(String(describing: error))
        }
    }

    func testEnum() {
        let json = """
            {"single":1,"array":[1,2,3]}
            """
        enum Number: Int, Decodable {
            case one = 1
            case two
            case three
        }
        struct Model: Decodable {
            let single: Number
            let array: [Number] = [.one, .two, .three]
        }
        do {
            let object = try JSONDecoder().decode(Model.self, from: json)
            assertEqual(object.single, .one)
            assertEqual(object.array, [.one, .two, .three])
        } catch {
            fail(String(describing: error))
        }
    }

    func testDecodable() {
        let json = """
            {"answer":42,"hello":"Hello, World!"}
            """
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        do {
            let type: Decodable.Type = Model.self
            let decodable = try JSONDecoder().decode(decodable: type, from: json)
            guard let object = decodable as? Model else {
                fail()
                return
            }
            assertEqual(object.answer, 42)
            assertEqual(object.hello, "Hello, World!")
        } catch {
            fail(String(describing: error))
        }
    }
}
