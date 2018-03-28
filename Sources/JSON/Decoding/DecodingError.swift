extension DecodingError.Context {
    static func description(_ string: String) -> DecodingError.Context {
        return DecodingError.Context(codingPath: [], debugDescription: string)
    }

    static func incompatible(with value: JSON.Value) -> DecodingError.Context {
        return .description("incompatible with \(value)")
    }

    static func incompatible<T: CodingKey>(
        with value: JSON.Value, for key: T
    ) -> DecodingError.Context {
        return .description("incompatible with \(value) for \(key)")
    }

    static func unexpectedNull() -> DecodingError.Context {
        return .description("unexpected null")
    }
}

extension DecodingError.Context: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(codingPath: [], debugDescription: value)
    }
}

extension DecodingError.Context: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(codingPath: [], debugDescription: "")
    }
}
