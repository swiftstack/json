final class Storage {
    var json = String()

    init() {}

    init(reservingCapacity capacity: Int) {
        json.reserveCapacity(capacity)
    }

    func write(_ string: String) {
        json.append(string)
    }
}
