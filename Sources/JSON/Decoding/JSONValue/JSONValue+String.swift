extension String {
    init(
        from json: [UInt8],
        at index: inout Int
    ) throws {
        guard json[index] == .quote else {
            throw JSONError.invalidJSON
        }
        json.formIndex(after: &index)

        var result = ""

        func readEscaped() throws {
            json.formIndex(after: &index)
            guard index < json.endIndex else {
                throw JSONError.invalidJSON
            }
            switch json[index] {
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
            json.formIndex(after: &index)
            guard index < json.endIndex else {
                throw JSONError.invalidJSON
            }
            let start = index
            guard json.formIndex(
                &index, offsetBy: 3, limitedBy: json.endIndex) else {
                    throw JSONError.invalidJSON
            }
            guard let code = Int(String(decoding: json[start...index], as: UTF8.self), radix: 16),
                let scalar = Unicode.Scalar(code) else {
                    throw JSONError.invalidJSON
            }
            return scalar
        }

        var done = false
        while !done, index < json.endIndex {
            let character =  json[index]
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
            json.formIndex(after: &index)
        }

        guard done else {
            throw JSONError.invalidJSON
        }

        self = result
    }
}
