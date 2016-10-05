//: Playground - noun: a place where people can play

import UIKit

protocol StringKey: CustomStringConvertible {}
extension String: StringKey { var description: String { return self } }

func unwrap(any: Any) -> Any? {
    let mirror = Mirror(reflecting: any)
    guard
        mirror.children.count > 0,
        let child = mirror.children.first
    else { return nil }
    
    if mirror.displayStyle != .optional {
        return any
    } else {
        return child.value
    }
}

extension Dictionary where Key: StringKey {
    var unwrapped: Dictionary<String, Any> {
        var non: Dictionary<String, Any> = [:]
        for (key, value) in self {
            guard let key = key as? String else { continue }
            let value = unwrap(any: value)
            non[key] = value
        }
        return non
    }
}

let a: String? = "banan"
let b: String? = nil
let c: String = "apa"

let dict: [String : Any?] = ["a": a, "b": b, "c": c]

for (key, value) in dict.unwrapped {
    print("dict[\(key)] == \(value)")
}
