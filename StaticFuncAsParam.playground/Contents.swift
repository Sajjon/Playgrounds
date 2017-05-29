//: Playground - noun: a place where people can play

import UIKit

struct IntSet: ExpressibleByArrayLiteral {
    
    typealias Element = Int
    
    let set: Set<Int>
    
    init(_ set: Set<Int>) {
        self.set = set
    }
    
    init(_ array: [Int] = []) {
        self.init(Set(array))
    }
    
    init(arrayLiteral elements: Int...) {
        self.init(elements)
    }
    
    init(_ literals: Int...) {
        self.init(literals)
    }
    
    func union(_ other: IntSet) -> IntSet {
        return IntSet(set.union(other.set))
    }
}

extension IntSet {
    static let odd = IntSet(1, 3, 5, 7, 9)
    static let even = IntSet(0, 2, 4, 6, 8)
}

func makeStyle(_ lhs: IntSet, _ rhs: IntSet) -> IntSet {
    return lhs.union(rhs)
}

typealias SetUnifier = (IntSet) -> IntSet
let setUnifier: SetUnifier = { return  }
final class SetHolder {
    let set: IntSet
    init(_ newSet: IntSet = .odd, transformation: SetUnifier = makeStyle(newSet, .even)) {
//        let set = set.union(.odd)
        self.set = newSet
        setup(with: newSet)
    }
    
    func setup(with set: IntSet) {
        print("Found #\(set.set.count)")
    }
}

//extension SetHolder: ExpressibleByArrayLiteral {
//    
//    convenience init(arrayLiteral elements: Int...) {
//        self.init(IntSet(elements))
//    }
//    
//    convenience init(_ literals: Int...) {
//        self.init(IntSet(literals))
//    }
//}

let holder = SetHolder(IntSet(17))
let defaul = SetHolder()
