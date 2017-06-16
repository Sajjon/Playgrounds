//: Playground - noun: a place where people can play

import UIKit

protocol Mergeable {
    associatedtype MergeResult: Whole
    func merge(master: Self) -> MergeResult
}


protocol Atomic {
    func merge(master: Self) -> Whole
}

protocol Whole {}
protocol Molecule: Whole, Mergeable {
    associatedtype Atom: Atomic
}

struct Oxygen: Atomic {
    func merge(master: Self) -> Whole
}