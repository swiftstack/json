import Stream

extension String {
    init<T: StreamReader>(from stream: T) throws {
        guard try stream.consume(.quote) else {
            throw JSONError.invalidJSON
        }

        var result: [UInt8] = []

        func readEscaped() throws {
            switch try stream.read(UInt8.self) {
            case .quote: result.append(.quote)
            case .n: result.append(.lf)
            case .r: result.append(.cr)
            case .t: result.append(.tab)
            case .backslash: result.append(.backslash)
            case .u: try readUnicodeScalar()
            default: throw JSONError.invalidJSON
            }
        }

        func readUnicodeScalar() throws {
            let codeString = try stream.read(count: 4) { buffer in
                return String(decoding: buffer, as: UTF8.self)
            }
            guard let code = Int(codeString, radix: 16),
                let scalar = Unicode.Scalar(code),
                let encoded = UTF8.encode(scalar) else
            {
                throw JSONError.invalidJSON
            }

            result.append(contentsOf: encoded)
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
                result.append(character)
            }
        }

        guard done else {
            throw JSONError.invalidJSON
        }

        self = String(decoding: result, as: UTF8.self)
    }
}
