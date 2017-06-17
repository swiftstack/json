extension JSONValue {
    public enum Number {
        case int(Int)
        case uint(UInt)
        case double(Double)
    }
}

extension JSONValue.Number {
    init(
        from json: String.UnicodeScalarView,
        at index: inout String.UnicodeScalarView.Index
    ) throws {
        guard index < json.endIndex else {
            throw JSONError.invalidJSON
        }
        let startIndex = index

        var negative = false
        if json[index] == "-" {
            negative = true
            json.formIndex(after: &index)
        }

        var done = false
        var integer = true
        while !done, index < json.endIndex {
            switch json[index] {
            case "0"..."9":
                json.formIndex(after: &index)

            case ".":
                guard integer else {
                    throw JSONError.invalidJSON
                }
                integer = false
                json.formIndex(after: &index)

            case _ where json[index].contained(in: .terminator):
                done = true

            default:
                throw JSONError.invalidJSON
            }
        }

        if integer {
            if negative {
                guard let value = Int(String(json[startIndex..<index])) else {
                    throw JSONError.invalidJSON
                }
                self = .int(value)
            } else {
                guard let value = UInt(String(json[startIndex..<index])) else {
                    throw JSONError.invalidJSON
                }
                self = .uint(value)
            }
        } else {
            guard let value = Double(String(json[startIndex..<index])) else {
                throw JSONError.invalidJSON
            }
            self = .double(value)
        }
    }
}

extension JSONValue.Number: Equatable {
    public static func ==(lhs: JSONValue.Number, rhs: JSONValue.Number) -> Bool {
        switch (lhs, rhs) {
        case let (.int(lhs), .int(rhs)): return lhs == rhs
        case let (.uint(lhs), .uint(rhs)): return lhs == rhs
        case let (.double(lhs), .double(rhs)): return lhs == rhs
        default: return false
        }
    }
}

extension JSONValue.Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int(let int): return int.description
        case .uint(let uint): return uint.description
        case .double(let double): return double.description
        }
    }
}
