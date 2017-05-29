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
    static var identity: Int = 0
}

extension Double: Countable {
    static var identity: Double = 0
}

extension Float: Countable {
    static var identity: Float = 0
}

typealias Next<Value, Artimetic> = (Value, Artimetic) -> Value
protocol Reducable {
    associatedtype Value: Identity
    var value: Value { get }
    static var next: Next<Value, Self> { get }
}

extension Collection where Iterator.Element: Reducable {
    func reduce(_ initial: Iterator.Element.Value = .identity) -> Iterator.Element.Value {
        return reduce(initial, Iterator.Element.next)
    }
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
    func addition(initial: Iterator.Element.Value = .identity) -> Iterator.Element.Value {
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
    func subtraction(initial: Iterator.Element.Value = .identity) -> Iterator.Element.Value {
        return reduce(initial, Iterator.Element.subtraction)
    }
}

typealias Counting = Subtracting & Adding

postfix operator +
postfix func +<Element: Adding>(array: [Element]) -> Element.Value {
    return array.addition()
}

postfix operator -
postfix func -<Element: Subtracting>(array: [Element]) -> Element.Value {
    return array.subtraction()
}


//MARK: - Usage
///////////////////////////////////////////////////////////////
//////////////// USAGE ///////////////////////////////////////
///////////////////////////////////////////////////////////////


//MARK: Int - Counting
extension Int: Counting {
    var value: Int { return self }
}

let integers = [1, 2, 3, 4]
print("integers adding: \(integers.addition())")
print("integers (+): \(integers+)")
print("integers subtracting: \(integers.subtraction())")
print("integers (-): \(integers-)")

//MARK: Float - Counting
extension Float: Counting {
    var value: Float { return self }
}

let floats: [Float] = [1, 2, 3, 4]
print("floats adding: \(floats.addition())")
print("floats (+): \(floats+)")
print("floats subtracting: \(floats.subtraction())")
print("floats (-): \(floats-)")

//MARK: IntHolder - Reducable (Addition)
struct IntHolder {
    let value: Int
    init(_ value: Int) { self.value = value }
}

extension IntHolder: Reducable {
    static var next: Next<Int, IntHolder> {
        return { return $0 + $1.value }
    }
}

let intHolders = [1, 2, 3, 4].map { IntHolder($0) }
print("IntHolder reduce (addition): \(intHolders.reduce())")


//MARK: FloatHolder - Adding/Subtracting
struct FloatHolder {
    let value: Float
    init(_ value: Float) { self.value = value }
}

extension FloatHolder: Adding {}
extension FloatHolder: Subtracting {}


let floatHolders = [1, 2, 3, 4].map { FloatHolder($0) }
print("float addition: \(floatHolders.addition(initial: 100))")
print("float (+): \(floatHolders+)")
print("float subtraction: \(floatHolders.subtraction())")
print("float (-): \(floatHolders-)")

let ints1 = [1, 2, 3]
let ints2 = [2, 4, 5]
let sum = ints1+ - ints2+
let sum2 = ints1 + ints2+
print(sum)
print(sum2)
