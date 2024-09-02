extension Set where Element == UInt8 {
    static let controls: Set<UInt8> = [.cr, .lf, .tab]
    static let whitespaces: Set<UInt8> = [.whitespace, .cr, .lf, .tab]
}
