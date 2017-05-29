//: Playground - noun: a place where people can play

import UIKit

protocol Foo {
    static func <(lhs: Self, rhs: Self) -> Bool
}

class FooClass: Foo {
    let value: Int = 0
    static func <(lhs: FooClass, rhs: FooClass) -> Bool { return lhs.value < rhs.value }
}

class BarClass {}

enum FooRawEnum: String, Foo {
    case foo
    case bar
    static func <(lhs: FooRawEnum, rhs: FooRawEnum) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum FooAssociatedEnum: Foo {
    case foo(FooClass)
    case bar(BarClass)
    case baz
    case buz([BarClass])
    
    static func <(lhs: FooAssociatedEnum, rhs: FooAssociatedEnum) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}