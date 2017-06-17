extension String.UnicodeScalarView {
    func formIndex(
        from index: inout String.UnicodeScalarView.Index,
        consuming characters: Set<UnicodeScalar>
    ) {
        while index < endIndex, characters.contains(self[index]) {
            formIndex(after: &index)
        }
    }
}

extension Set where Element == UnicodeScalar {
    static var whitespace: Set<UnicodeScalar> = [" ", "\r", "\n", "\t"]
    static let terminator: Set<UnicodeScalar> = [" ", ",", "}", "]", "\r", "\n", "\t"]
    static let control: Set<UnicodeScalar> = ["\r", "\n", "\t"]
}

extension UnicodeScalar {
    func contained(in set: Set<UnicodeScalar>) -> Bool {
        return set.contains(self)
    }
}
