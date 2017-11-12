import Test
@testable import JSON

class _JSONDecoderTests: TestCase {
    func testKeyedContainer() {
        do {
            let json = [UInt8]("""
                {"answer":42}
                """.utf8)
            let decoder = try _JSONDecoder(json)
            enum Keys: CodingKey {
                case answer
            }
            let container = try decoder.container(keyedBy: Keys.self)
            let answer = try? container.decode(Int.self, forKey: .answer)
            assertEqual(answer, 42)
        } catch {
            fail(String(describing: error))
        }
    }

    func testUnkeyedContainer() {
        do {
            let json = [UInt8]("[1,[2],[3],4]".utf8)
            let decoder = try _JSONDecoder(json)
            var container = try decoder.unkeyedContainer()
            let int1 = try container.decode(Int.self)
            var nested1 = try container.nestedUnkeyedContainer()
            let int2 = try nested1.decode(Int.self)
            var nested2 = try container.nestedUnkeyedContainer()
            let int3 = try nested2.decode(Int.self)
            let int4 = try container.decode(Int.self)
            assertEqual(int1, 1)
            assertEqual(int2, 2)
            assertEqual(int3, 3)
            assertEqual(int4, 4)
        } catch {
            fail(String(describing: error))
        }
    }

    func testSingleValueContainer() {
        do {
            let json = [UInt8]("true".utf8)
            let decoder = try _JSONDecoder(json)
            let container = try decoder.singleValueContainer()
            let bool = try container.decode(Bool.self)
            assertEqual(bool, true)
        } catch {
            fail(String(describing: error))
        }
    }
}
