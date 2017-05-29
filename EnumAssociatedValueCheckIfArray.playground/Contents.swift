//: Playground - noun: a place where people can play

import UIKit

struct Foo {
    let value: Int
    init(_ value: Int) { self.value = value }
}
extension Foo: Equatable, Hashable {
    static func == (lhs: Foo, rhs: Foo) -> Bool { return lhs.value == rhs.value }
    var hashValue: Int { return value.hashValue }
}

class Bar { init() {} }

enum Value {
    case int(Int)
    case intArray([Int])
    case stringArray([String])
    case fooArray([Foo])
}

//protocol AssociatedValueExtractor {
//    var associatedValue: Any { get }
//}
//
//extension Value: AssociatedValueExtractor {
//    var associatedValue: Any {
//        switch self {
//        case .int(let value):
//            return value
//        case .array(let value):
//            return value
//        }
//    }
//}
//
//func typeFrom(_ value: Any) -> Mirror.DisplayStyle {
//    let mirror = Mirror(reflecting: value)
//    guard let type = mirror.displayStyle else { return .struct }
//    return type
//}
//
//func isValueArray(_ value: Any) -> Bool {
//    switch typeFrom(value) {
//    case .collection:
//        return true
//    default:
//        return false
//    }
//}
//
//extension Value {
//    var isAssociatedValueArray: Bool {
//        return isValueArray(associatedValue)
//    }
//}

fileprivate func combineHashes<HashableElement: Hashable>(_ hashableArray: [HashableElement]) -> Int {
    let arrayOfHashes: [Int] = hashableArray.map { $0.hashValue }
    return arrayOfHashes.reduce(0, combineHashValues)
}

//fileprivate func combineHashes(_ stringArray: [String]) -> Int {
//    let arrayOfHashes: [Int] = stringArray.map { $0.hashValue }
//    return arrayOfHashes.reduce(0, combineHashValues)
//}
//
//fileprivate func combineHashes(_ hashes: [Int]) -> Int {
//    return hashes.reduce(0, combineHashValues)
//}

fileprivate func combineHashValues(_ initial: Int, _ other: Int) -> Int {
    #if arch(x86_64) || arch(arm64)
        let magic: UInt = 0x9e3779b97f4a7c15
    #elseif arch(i386) || arch(arm)
        let magic: UInt = 0x9e3779b9
    #endif
    var lhs = UInt(bitPattern: initial)
    let rhs = UInt(bitPattern: other)
    lhs ^= rhs &+ magic &+ (lhs << 6) &+ (lhs >> 2)
    return Int(bitPattern: lhs)
}

extension Value: Equatable {
    static func == (lhs: Value, rhs: Value) -> Bool { return false }
}

extension Value: Hashable {
    var hashValue: Int {
        switch self {
        case .int(let data):
            return combineHashes([0, data.hashValue])
        case .intArray(let intArray):
            return combineHashes([1, combineHashes(intArray)])
        case .stringArray(let stringArray):
            return combineHashes([2, combineHashes(stringArray)])
        case .fooArray(let fooArray):
            return combineHashes([3, combineHashes(fooArray)])
        }
    }
}

let int: Value = .int(237)
let intArray: Value = .intArray([2, 3, 7])
let stringArrayInt: Value = .stringArray(["1", "2"])
let stringArrayStrings: Value = .stringArray(["Foo", "Bar"])
let stringArrayStrings2: Value = .stringArray(["Bar", "Foo"])
let fooArray: Value = .fooArray([Foo(2), Foo(3)])
let fooArray2: Value = .fooArray([Foo(2), Foo(3)])
let fooArray3: Value = .fooArray([Foo(3), Foo(2)])

//int.isAssociatedValueArray
//intArray.isAssociatedValueArray
int.hashValue
intArray.hashValue
stringArrayInt.hashValue
stringArrayStrings.hashValue
stringArrayStrings2.hashValue
fooArray.hashValue
fooArray2.hashValue
fooArray3.hashValue
