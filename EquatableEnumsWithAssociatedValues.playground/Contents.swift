//: Playground - noun: a place where people can play

import UIKit
protocol StrippedRepresentation: RawRepresentable {}
protocol AssociatedValueStrippable: Equatable {
    associatedtype Stripped: StrippedRepresentation, Equatable
    var stripped: Stripped { get }
}


enum ViewAttributeStripped: String, StrippedRepresentation {
    case axis
    case spacing
}

extension ViewAttribute: AssociatedValueStrippable {
    static func == (lhs: ViewAttribute, rhs: ViewAttribute) -> Bool {
        return lhs.stripped == rhs.stripped
    }
    
    typealias Stripped = ViewAttributeStripped
    var stripped: Stripped {
        switch self {
        case .axis:
            return .axis
        case .spacing:
            return .spacing
        }
    }
}


extension Collection where Iterator.Element: AssociatedValueStrippable, Iterator.Element: Hashable {
    func contains<Stripped: StrippedRepresentation>(_ element: Stripped) -> Bool where Stripped == Iterator.Element.Stripped {
        return map { $0.stripped }.contains(element)
    }
}

enum ViewAttribute {
    case axis(UILayoutConstraintAxis)
    case spacing(CGFloat)
}

protocol AssociatedValueExtractor {
    var associatedValue: Any { get }
}

extension AssociatedValueExtractor {
    func associatedValueTyped<T>() -> T {
        //swiftlint:disable:next force_cast
        return associatedValue as! T
    }
}

extension ViewAttribute: AssociatedValueExtractor {
    
    var associatedValue: Any {
        switch self {
        case .axis(let axis):
            return axis
        case .spacing(let spacing):
            return spacing
        }
    }
}


//
//fileprivate func combineHashes(_ hashes: [Int]) -> Int {
//    return hashes.reduce(0, combineHashValues)
//}
//
//fileprivate func combineHashValues(_ initial: Int, _ other: Int) -> Int {
//    #if arch(x86_64) || arch(arm64)
//        let magic: UInt = 0x9e3779b97f4a7c15
//    #elseif arch(i386) || arch(arm)
//        let magic: UInt = 0x9e3779b9
//    #endif
//    var lhs = UInt(bitPattern: initial)
//    let rhs = UInt(bitPattern: other)
//    lhs ^= rhs &+ magic &+ (lhs << 6) &+ (lhs >> 2)
//    return Int(bitPattern: lhs)
//}
//
//
//// MARK: - AutoHashable for classes, protocols, structs
//
//// MARK: - AutoHashable for Enums
//
//// MARK: - ViewAttribute AutoHashable
extension ViewAttribute: Hashable {
    var hashValue: Int {
        return associatedValue.hashValue
    }
}

let axisHorizontal = ViewAttribute.axis(.horizontal)
let axisVertical = ViewAttribute.axis(.vertical)
let spacing0 = ViewAttribute.spacing(0)
let spacing1 = ViewAttribute.spacing(1)

axisVertical == axisHorizontal
spacing0 == spacing1
spacing0 == axisHorizontal


let values: [ViewAttribute] = [axisHorizontal, axisVertical]

values.contains(.axis)
//values.contains(.axis)
//values.contains(.spacing)
//
//let set = Set(values)
//set.contains(.axis)
//set.contains(.spacing)
