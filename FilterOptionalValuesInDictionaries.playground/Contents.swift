//: Playground - noun: a place where people can play

import UIKit

func unwrap(any :Any) -> Any? {
    let mirror = Mirror(reflecting: any)
    if mirror.displayStyle != .optional {
        return any
    }

    if mirror.children.count == 0 { return nil }
    let (_, some) = mirror.children.first!
    return some
}


extension Dictionary where Value: ExpressibleByNilLiteral {
    func nonNilValues() -> Dictionary<Key, Any> {
        var dict = [Key: Any]()

        for (key, value) in self {
            guard
                let value = unwrap(any: value),
                !(value is NSNull)
            else { continue }
            dict[key] = value
        }
        return dict
    }
}

let withOptionals: [String: Any?] = ["Nil" : nil, "Foo": "Bar", "Null": NSNull(), "Baz": "Buz"]
print(withOptionals) // prints: ["Foo": Optional("Bar"), "Nil": nil]
print(withOptionals.nonNilValues()) // prints: ["Foo": "Bar"]
