# JSON

Obsolete JSON implementation written in Swift.

## Package.swift

```swift
.package(url: "https://github.com/swiftstack/json.git", .branch("dev"))
```

## Usage

### Convenience API

```swift
let bytes = JSON.encode(Model())
let model = JSON.decode(Model.self, from: bytes)
```

### Streaming API

```swift
let output = ByteArrayOutputStream()
JSON.encode(Model(), to: output)

let input = ByteArrayInputStream(output.bytes)
let model = JSON.decode(Model.self, from: input)
```

### Encoder / Decoder + Streaming API

```swift
let bytes = JSONEncoder().encode(Model())
JSONEncoder().encode(Model(), to: stream)
...
```

### JSON Value

```swift
public struct JSON {
    public enum Value {
        case null
        case bool(Bool)
        case number(Number)
        case string(String)
        case array([JSON.Value])
        case object([String : JSON.Value])

        public enum Number {
            case int(Int)
            case uint(UInt)
            case double(Double)
        }
    }
}
```

## Performance (MacBook Pro 16 / M2 Max)

```json
{
  "orderId": "ORD-2025-12345",
  "orderDate": "2025-01-15T10:30:00Z",
  "customer": {
    "customerId": 5678,
    "name": "Michael Chen",
    "email": "michael.chen@example.com"
  },
  "items": [
    {
      "productId": "PROD-001",
      "name": "Wireless Mouse",
      "quantity": 2,
      "price": 29.99
    },
    {
      "productId": "PROD-002",
      "name": "USB Cable",
      "quantity": 3,
      "price": 9.99
    }
  ],
  "shipping": {
    "method": "Express",
    "cost": 15.00,
    "address": {
      "street": "789 Pine Street",
      "city": "Seattle",
      "state": "WA",
      "zipCode": "98101"
    }
  },
  "payment": {
    "method": "credit_card",
    "last4": "4242",
    "status": "paid"
  },
  "subtotal": 89.95,
  "tax": 8.10,
  "total": 113.05,
  "status": "processing"
}
```

JSON encode: 33053 ops/s
Stdlib encode: 42387 ops/s
JSON decode: 9592 ops/s
Stdlib decode: 43396 ops/s
