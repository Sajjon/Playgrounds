//: Playground - noun: a place where people can play

import UIKit

var alex: [String: String] = ["nickname": "Sasha", "lastname": "Cyon"]
var klara: [String: String] = ["firstname": "Klara", "lastname": "Strandberg"]

enum Precedence {
    case left
    case right
}


typealias Person = [String: String]

func marry(_ lhs: Person, with rhs: Person, prededence: Precedence) -> Person {
    switch prededence {
    case .left:
        return mergeKeepLeftHandSideValues(lhs, rhs: rhs)
    case .right:
        return mergeKeepRightHandSideValues(lhs, rhs: rhs)
    }
}

func mergeKeepLeftHandSideValues(_ lhs: Person, rhs: Person) -> Person {
    var merged = rhs
    for (key, value) in lhs {
        merged[key] = value
    }
    return merged
}

func mergeKeepRightHandSideValues(_ lhs: Person, rhs: Person) -> Person {
    var merged = lhs
    for (key, value) in rhs {
        merged[key] = value
    }
    return merged
}

let married: Person = marry(alex, with: klara, prededence: .left)















//func printValue(forKey key: String) -> Void {
//    guard let value = dictionary[key] else { return }
//    print(value)
//}
//
//printValue(forKey: "firstname")
//
