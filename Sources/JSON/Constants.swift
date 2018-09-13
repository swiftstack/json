extension Array where Element == UInt8 {
    static let null = [UInt8]("null".utf8)
    static let `true` = [UInt8]("true".utf8)
    static let `false` = [UInt8]("false".utf8)
}
