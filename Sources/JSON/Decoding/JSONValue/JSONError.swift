enum JSONError: Error {
    case invalidJSON
    case cantEncodeNil
    case cantDecodeNil
}
