extension JSON {
    public enum Error: Swift.Error {
        case invalidJSON
        case cantEncodeNil
        case cantDecodeNil
    }
}
