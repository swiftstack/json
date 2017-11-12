final class Storage {
    var json = [UInt8]()

    init() {}

    init(reservingCapacity capacity: Int) {
        json.reserveCapacity(capacity)
    }

    @inline(__always)
    func write(_ byte: UInt8) {
        json.append(byte)
    }

    @inline(__always)
    func write(_ bytes: [UInt8]) {
        json.append(contentsOf: bytes)
    }

    @inline(__always)
    func write(_ string: String) {
        json.append(contentsOf: string.utf8)
    }
}
