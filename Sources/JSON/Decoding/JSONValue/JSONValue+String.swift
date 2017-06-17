extension String {
    init(
        from json: String.UnicodeScalarView,
        at index: inout String.UnicodeScalarView.Index
    ) throws {
        guard json[index] == "\"" else {
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
            case "\"": result.append("\"")
            case "n": result.append("\n")
            case "r": result.append("\r")
            case "t": result.append("\t")
            case "\\": result.append("\\")
            // TODO:
            case "u": throw JSONError.invalidJSON
            default: throw JSONError.invalidJSON
            }
        }

        var done = false
        while !done, index < json.endIndex {
            let character =  json[index]
            switch character {
            case "\"":
                done = true
            case "\\":
                try readEscaped()
            case _ where character.contained(in: .control):
                throw JSONError.invalidJSON
            default:
                result.unicodeScalars.append(character)
            }
            json.formIndex(after: &index)
        }

        guard done else {
            throw JSONError.invalidJSON
        }

        self = result
    }
}
