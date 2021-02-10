import Stream

extension String {
    static func decode(from stream: StreamReader) async throws -> Self {
        guard try await stream.consume(.doubleQuote) else {
            throw JSON.Error.invalidJSON
        }

        var result: [UInt8] = []

        func readEscaped() async throws {
            switch try await stream.read(UInt8.self) {
            case .doubleQuote: result.append(.doubleQuote)
            case .n: result.append(.lf)
            case .r: result.append(.cr)
            case .t: result.append(.tab)
            case .backslash: result.append(.backslash)
            case .u: try await readUnicodeScalar()
            default: throw JSON.Error.invalidJSON
            }
        }

        func readUnicodeScalar() async throws {
            let code = try await stream.read(count: 4) { buffer in
                return Int(hex: buffer)
            }
            guard let scalar = Unicode.Scalar(code),
                let encoded = UTF8.encode(scalar) else
            {
                throw JSON.Error.invalidJSON
            }

            result.append(contentsOf: encoded)
        }

        loop: while true {
            let byte = try await stream.read(UInt8.self)
            switch byte {
            case .doubleQuote: break loop
            case .backslash: try await readEscaped()
            case _ where !byte.isControl: result.append(byte)
            default: throw JSON.Error.invalidJSON
            }
        }

        return String(decoding: result, as: UTF8.self)
    }
}

extension UInt8 {
    var isControl: Bool { Set<UInt8>.controls.contains(self) }
}
