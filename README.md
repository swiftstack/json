# JSON

Fastest JSON implementation written in Swift.

## Package.swift

```swift
.package(url: "https://github.com/swiftstack/json.git", .branch("fiber"))
```

## Usage

### Convenience API

```swift
let bytes = JSON.encode(Model())
let model = JSON.decode(Model.self, from: bytes)
```

### Streaming API

```swift
let output = OutputByteStream()
JSON.encode(Model(), to: output)

let input = InputByteStream(output.bytes)
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

## Performance
`{"message":"Hello, World!"}`<br>

JSON.JSONEncoder: 934 644 tasks/sec<br>
Foundation.JSONEncoder: 92 619 tasks/sec<br>

JSON.JSONDecoder: 236 062 tasks/sec<br>
Foundation.JSONDecoder: 226 515 tasks/sec<br>

`{"message":"\u3053\u3093\u306B\u3061\u306F\u4E16\u754C\uFF01"}`<br>

JSON.JSONDecoder: 179 440 tasks/sec<br>
Foundation.JSONDecoder: 88 614 tasks/sec<br>
