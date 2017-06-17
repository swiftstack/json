extension Array where Element == JSONValue {
    init(
        from json: String.UnicodeScalarView,
        at index: inout String.UnicodeScalarView.Index
    ) throws {
        guard json[index] == "[" else {
            throw JSONError.invalidJSON
        }
        json.formIndex(after: &index)

        var done = false
        var result = [JSONValue]()
        while !done, index < json.endIndex {
            json.formIndex(from: &index, consuming: .whitespace)
            switch json[index] {
            case "]":
                json.formIndex(after: &index)
                done = true
            case ",":
                json.formIndex(after: &index)
            default:
                result.append(try JSONValue(from: json, at: &index))
            }
        }

        self = result
    }
}
