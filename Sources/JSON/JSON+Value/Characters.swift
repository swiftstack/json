import ASCII

extension Set where Element == UInt8 {
    static let controls: Set<UInt8> = [.cr, .lf, .ht]
    static let whitespaces: Set<UInt8> = [.space, .cr, .lf, .ht]
}
