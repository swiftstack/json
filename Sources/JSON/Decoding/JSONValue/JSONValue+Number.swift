extension JSONValue {
    public enum Number {
        case int(Int)
        case uint(UInt)
        case double(Double)
    }
}

extension JSONValue.Number {
    init(
        from json: [UInt8],
        at index: inout Int
    ) throws {
        guard index < json.endIndex else {
            throw JSONError.invalidJSON
        }

        var isNegative = false
        if json[index] == .hyphen {
            isNegative = true
            json.formIndex(after: &index)
        }

        var isInteger = true

        var integer: UInt = 0
        var fract = 0
        var divider = 1

        loop: while index < json.endIndex {
            switch json[index] {
            case (.zero)...(.nine):
                switch isInteger {
                case true:
                    integer *= 10
                    integer += UInt(json[index] - .zero)
                case false:
                    fract *= 10
                    fract += Int(json[index] - .zero)
                    divider *= 10
                }
                json.formIndex(after: &index)

            case .dot:
                guard isInteger else {
                    throw JSONError.invalidJSON
                }
                isInteger = false
                json.formIndex(after: &index)

            case _ where json[index].contained(in: .terminator):
                break loop

            default:
                throw JSONError.invalidJSON
            }
        }

        if isInteger {
            if isNegative {
                guard integer <= (UInt(Int.max)+1) else {
                    throw JSONError.invalidJSON
                }
                self = .int(-Int(integer))
            } else {
                self = .uint(integer)
            }
        } else {
            var value = Double(integer) + Double(fract) / Double(divider)
            if isNegative {
                value = -value
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
