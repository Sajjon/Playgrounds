//: Playground - noun: a place where people can play

import UIKit

prefix operator❗️
prefix func ❗️ (bool: Bool) -> Bool {
    return !bool
}


let truly = true
let falsy = ❗️truly
print(falsy)

postfix operator ⁉️
postfix func ⁉️ <Value>(optional: Optional<Value>) -> Value {
    return optional! as Value
}

let maybeString: String? = "Alex"
let maybeString2: String? = nil

print(maybeString⁉️) //prints "Alex"
print(maybeString2⁉️) //fatalError: unexpectedly found nil while unwrapping an Optional value
