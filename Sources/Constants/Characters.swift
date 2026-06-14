import ASCII

public extension Set where Element == UInt8 {
    static let controls: Set<UInt8> = [.cr, .lf, .ht]
    static let whitespaces: Set<UInt8> = controls.union([.space])
}

public extension UInt8 {
    var isControl: Bool { Set<UInt8>.controls.contains(self) }
}
