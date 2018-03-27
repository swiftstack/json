import Stream

extension InputByteStream {
    convenience init(_ string: String) {
        self.init([UInt8](string.utf8))
    }
}
