import Foundation
import JSON

let data = Data(input.utf8)
let bytes = [UInt8](input.utf8)

let model = try JSONDecoder().decode(Model.self, from: data)

await measure(name: "JSON encode", duration: .seconds(3)) {
    blackHole(try! await JSON.encode(model))
}

await measure(name: "Stdlib encode", duration: .seconds(3)) {
    blackHole(try! await encode(model))
}

await measure(name: "JSON decode", duration: .seconds(3)) {
    blackHole(try! await JSON.decode(Model.self, from: bytes))
}

await measure(name: "Stdlib decode", duration: .seconds(3)) {
    blackHole(try! await decode(Model.self, from: data))
}
