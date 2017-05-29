//: Playground - noun: a place where people can play

import UIKit

protocol Identity: Comparable, Equatable {
    static var identity: Self { get }
}

protocol Addable: Identity {
    static func +(lhs: Self, rhs: Self) -> Self
}

protocol Subtractable: Identity {
    static func -(lhs: Self, rhs: Self) -> Self
}

typealias Countable = Identity & Addable & Subtractable

extension Int: Countable {
    static var identity: Int { return 0 }
}

extension Double: Countable {
    static var identity: Double { return 0 }
}

extension Float: Countable {
    static var identity: Float { return 0 }
}

protocol Adding {
    associatedtype Value: Addable
    var value: Value { get }
}

extension Adding {
    static var addition: Next<Value, Self> {
        return { return $0 + $1.value }
    }
}


extension Collection where Iterator.Element: Adding {
    func adding(_ initial: Iterator.Element.Value = .identity) -> Iterator.Element.Value {
        return reduce(initial, Iterator.Element.addition)
    }
}

protocol Subtracting {
    associatedtype Value: Subtractable
    var value: Value { get }
}

extension Subtracting {
    static var subtraction: Next<Value, Self> {
        return { return $0 - $1.value }
    }
}

extension Collection where Iterator.Element: Subtracting {
    func subtracting(_ initial: Iterator.Element.Value = .identity) -> Iterator.Element.Value {
        return reduce(initial, Iterator.Element.subtraction)
    }
}

typealias Counting = Subtracting & Adding

postfix operator +
postfix func +<Element: Adding>(array: [Element]) -> Element.Value {
    return array.adding()
}

postfix operator -
postfix func -<Element: Subtracting>(array: [Element]) -> Element.Value {
    return array.subtracting()
}



typealias Next<Value, Artimetic> = (Value, Artimetic) -> Value
protocol Reducable {
    associatedtype Value: Identity
    var value: Value { get }
    var next: Next<Value, Self> { get }
}

enum Operator {
    
    case add(Adding)
    case subtract(Subtracting)

    var initial: Any {
        switch self {
        case .add(let adding):
            return adding.value
        case .subtract(let subtracting):
            return subtracting.value
        }
    }

//    var value: Value {
//        fatalError()
//    }
    //var next: Next<Value, Self> { get }
    var next: Next<Any, Any> {
        switch self {
        case .add(let adding):
            return adding.addition
        case .subtract(let subtracting):
            return subtracting.subtraction
        }
    }
}

extension Collection where Iterator.Element: Reducable {
    func foo(operator foo: Operator) -> Iterator.Element.Value {
        return reduce(foo.initial, foo.next)
    }
}

extension Int: Reducable {
    var value: Int { return self }
    var next: Next<Int, Int> { return { $0 + $1 } }
}

let integers = [1, 2, 3, 4]
//let sum: Int = integers.foo(operator: Operator.add(2))
//print(sum)
//let subtr: Int = integers.foo(operator: Operator.subtract(0))
//print(subtr)

























