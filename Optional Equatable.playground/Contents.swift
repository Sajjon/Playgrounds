//: Playground - noun: a place where people can play

import UIKit

class IntHolder {
    let value: Int
    init(_ value: Int) { self.value = value }
}
extension IntHolder: Equatable {
    static func ==(lhs: IntHolder, rhs: IntHolder) -> Bool {
        return lhs.value == rhs.value
    }
}

//func ==<Value: Equatable>(lhs: Value?, rhs: Value?) -> Bool {
//    guard
//        let unwrappedLeft = lhs,
//        let unwrappedRight = rhs
//    else { return false }
//    return unwrappedLeft == unwrappedRight
//}

let maybe1: Int? = nil
let idd1: Int = 1

let source = IntHolder(1)
var x: IntHolder = source
var y: IntHolder? = source
var equal = IntHolder(1)

source == equal
source === equal
x == source
x === source
x == y
x === y