//: Playground - noun: a place where people can play

import UIKit
import ObjectiveC.runtime
import ObjectiveC.Protocol

@objc protocol Vehicle {}

infix operator <!>: AdditionPrecedence

func <!> <AnyProtocol: Protocol>(type: Any, anyProtocol: AnyProtocol) -> Bool {
    print("baba")
    return (type as? AnyProtocol) != nil
}

func verifyVehicle(_ any: Any) {
    print("hoho")
    let info = "'\(any)' of type '\(type(of: any))'"
    let conform = "conform to protocol 'Vehicle'"
    if any <!> Vehicle.self {
        print("\(info) does not \(conform)")
    } else {
        print("\(info) does \(conform)")
    }
    print("hihi")
}

let int: Int = 1
verifyVehicle(int)
