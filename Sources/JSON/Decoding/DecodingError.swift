public extension DecodingError.Context {
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

public extension DecodingError {
    static func keyNotFound(_ key: any CodingKey) -> Self {
        .keyNotFound(key, .init(codingPath: [], debugDescription: ""))
    }

    static func typeMismatch(_ key: any Any.Type) -> Self {
        .typeMismatch(key, .init(codingPath: [], debugDescription: ""))
    }
}
