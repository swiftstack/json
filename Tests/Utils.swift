@testable import Stream

extension String {
    var bytes: [UInt8] {
        .init(utf8)
    }
}

extension MemoryStream {
    var bytesValue: [UInt8] {
        [UInt8](buffer[..<position])
    }

    var stringValue: String {
        String(decoding: buffer[..<position], as: UTF8.self)
    }
}
