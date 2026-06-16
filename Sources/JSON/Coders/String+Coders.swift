import Constants
import Stream

extension String {
    static func decode(from stream: MemoryStream) throws -> Self {
        guard try stream.consume(.quote) else {
            throw JSON.Error.invalidJSON
        }

        var result: [UInt8] = []

        func readEscaped() throws {
            switch try stream.read(UInt8.self) {
            case .quote: result.append(.quote)
            case .n: result.append(.lf)
            case .r: result.append(.cr)
            case .t: result.append(.ht)
            case .backslash: result.append(.backslash)
            case .u: try readUnicodeScalar()
            default: throw JSON.Error.invalidJSON
            }
        }

        func readUnicodeScalar() throws {
            let code = try stream.read(count: 4) { buffer in
                return Int(hex: buffer)
            }
            guard
                let scalar = Unicode.Scalar(code),
                let encoded = UTF8.encode(scalar)
            else {
                throw JSON.Error.invalidJSON
            }

            result.append(contentsOf: encoded)
        }

        loop: while true {
            let byte = try stream.read(UInt8.self)
            switch byte {
            case .quote: break loop
            case .backslash: try readEscaped()
            case _ where !byte.isControl: result.append(byte)
            default: throw JSON.Error.invalidJSON
            }
        }

        return String(decoding: result, as: UTF8.self)
    }
}


