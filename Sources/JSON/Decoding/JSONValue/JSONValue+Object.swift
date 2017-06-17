extension Dictionary where Key == String, Value == JSONValue {
    init(
        from json: String.UnicodeScalarView,
        at index: inout String.UnicodeScalarView.Index
    ) throws {
        guard json[index] == "{" else {
            throw JSONError.invalidJSON
        }
        json.formIndex(after: &index)

        var done = false
        var result = [String : JSONValue]()
        while !done, index < json.endIndex {
            json.formIndex(from: &index, consuming: .whitespace)
            switch json[index] {
            case "}":
                json.formIndex(after: &index)
                done = true
            case "\"":
                let key = try String(from: json, at: &index)
                json.formIndex(from: &index, consuming: .whitespace)
                guard json[index] == ":" else {
                    throw JSONError.invalidJSON
                }
                json.formIndex(after: &index)
                json.formIndex(from: &index, consuming: .whitespace)
                result[key] = try JSONValue(from: json, at: &index)
            case ",":
                json.formIndex(after: &index)
            default:
                throw JSONError.invalidJSON
            }
        }

        self = result
    }
}
