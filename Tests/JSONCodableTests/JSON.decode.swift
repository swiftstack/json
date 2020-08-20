import Test
import Stream
@testable import JSON

class JSONDecoderTests: TestCase {
    func testKeyed() throws {
        let json = InputByteStream(#"{"answer":42,"hello":"Hello, World!"}"#)
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        let model = try JSON.decode(Model.self, from: json)
        expect(model.answer == 42)
        expect(model.hello == "Hello, World!")
    }

    func testDecodeEscaped() throws {
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
        let model = try JSON.decode(Model.self, from: json)
        expect(model.answer == 42)
        expect(model.hello == "Hello, World!")
    }

    func testDecodeEscapedUnicode() throws {
        let json = InputByteStream(
            #"{"hello":"\u3053\u3093\u306b\u3061\u306f"}"#)
        struct Model: Decodable {
            let hello: String
        }
        let model = try JSON.decode(Model.self, from: json)
        expect(model.hello == "こんにちは")
    }

    func testKeyedNested() throws {
        let json = InputByteStream(
            #"{"answer":42,"nested":{"hello":"Hello, World!"}}"#)
        struct Model: Decodable {
            struct Nested: Decodable {
                let hello: String
            }
            let answer: Int
            let nested: Nested
        }
        let object = try JSON.decode(Model.self, from: json)
        expect(object.answer == 42)
        expect(object.nested.hello == "Hello, World!")
    }

    func testKeyedNestedInTheMiddle() throws {
        let json = InputByteStream(
            #"{"nested":{"hello":"Hello, World!"},"answer":42}"#)
        struct Model: Decodable {
            struct Nested: Decodable {
                let hello: String
            }
            let nested: Nested
            let answer: Int
        }
        let object = try JSON.decode(Model.self, from: json)
        expect(object.nested.hello == "Hello, World!")
        expect(object.answer == 42)
    }

    func testNestedArrayInTheMiddle() throws {
        let json = InputByteStream(
            #"{"nested":{"array":[1,2]},"answer":42}"#)
        struct Model: Decodable {
            struct Nested: Decodable {
                let array: [Int]
            }
            let nested: Nested
            let answer: Int
        }
        let object = try JSON.decode(Model.self, from: json)
        expect(object.nested.array == [1,2])
        expect(object.answer == 42)
    }

    func testNestedArraysInTheMiddle() throws {
        let json = InputByteStream(
            #"{"nested":{"array":[[1,2],[3,4]]},"answer":42}"#)
        struct Model: Decodable {
            struct Nested: Decodable {
                let array: [[Int]]
            }
            let nested: Nested
            let answer: Int
        }
        let object = try JSON.decode(Model.self, from: json)
        expect(object.nested.array.first ?? [] == [1,2])
        expect(object.nested.array.last ?? [] == [3,4])
        expect(object.answer == 42)
    }

    func testUnkeyed() throws {
        let json = InputByteStream("[1,2,3]")
        let object = try JSON.decode([Int].self, from: json)
        expect(object == [1,2,3])
    }

    func testUnkeyedOfUnkeyed() throws {
        let json = InputByteStream("[[1,2],[3,4]]")
        let object = try JSON.decode([[Int]].self, from: json)
        expect(object.first ?? [] == [1,2])
        expect(object.last ?? [] == [3,4])
    }

    func testEnum() throws {
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
        let object = try JSON.decode(Model.self, from: json)
        expect(object.single == .one)
        expect(object.array == [.one, .two, .three])
    }

    func testDecodable() throws {
        let json = InputByteStream(#"{"answer":42,"hello":"Hello, World!"}"#)
        struct Model: Decodable {
            let answer: Int
            let hello: String
        }
        let type: Decodable.Type = Model.self
        let decodable = try JSON.decode(decodable: type, from: json)
        guard let object = decodable as? Model else {
            fail()
            return
        }
        expect(object.answer == 42)
        expect(object.hello == "Hello, World!")
    }
}
