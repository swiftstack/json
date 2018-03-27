import Stream

extension String {
    init<T: StreamReader>(from stream: T) throws {
        guard try stream.consume(.quote) else {
            throw JSONError.invalidJSON
        }

        var result = ""

        func readEscaped() throws {
            switch try stream.read(UInt8.self) {
            case .quote: result.append("\"")
            case .n: result.append("\n")
            case .r: result.append("\r")
            case .t: result.append("\t")
            case .backslash: result.append("\\")
            case .u: result.unicodeScalars.append(try readUnicodeScalar())
            default: throw JSONError.invalidJSON
            }
        }

        func readUnicodeScalar() throws -> Unicode.Scalar {
            let codeString = try stream.read(count: 4) { buffer in
                return String(decoding: buffer, as: UTF8.self)
            }
            guard let code = Int(codeString, radix: 16),
                let scalar = Unicode.Scalar(code) else
            {
                throw JSONError.invalidJSON
            }
            return scalar
        }

        var done = false
        while !done {
            let character = try stream.read(UInt8.self)
            switch character {
            case .quote:
                done = true
            case .backslash:
                try readEscaped()
            case _ where character.contained(in: .control):
                throw JSONError.invalidJSON
            default:
                result.unicodeScalars.append(Unicode.Scalar(character))
            }
        }

        guard done else {
            throw JSONError.invalidJSON
        }

        self = result
    }
}
