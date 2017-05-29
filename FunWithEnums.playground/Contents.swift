//: Playground - noun: a place where people can play

import UIKit

enum Foo {
    case foo, bar
    case cornerRadius(CGFloat)
}

enum ViewAttribute {
    case bar
    
    case cornerRadius(CGFloat)
    case backgroundColor(UIColor)
}

enum City: String {
    case stockholm, oslo
    case helsinki = "Helsingfors"
    
}

extension City: CustomStringConvertible {
    var description: String { return rawValue.capitalized }
    
}



let foo: Foo = .foo
let stockholm: City = .stockholm
print(stockholm)
let helsinki: City = .helsinki
print(helsinki)