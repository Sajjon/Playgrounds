//: Playground - noun: a place where people can play

import UIKit

protocol SomeType {}

struct MyDataType: SomeType {}
struct IncorrectDataType: SomeType {}

protocol Foo {
    associatedtype DataType: SomeType
    func setup(with type: DataType)
    func customSetup(with type: DataType)
}

extension Foo where Self: UIView {
    func setup(with type: DataType) {
        print("setup inside extension Foo where Self: UIView")
        customSetup(with: type)
    }
    func customSetup(with type: DataType) { print("default customSetup") }
}

protocol FooBar: Foo {
    func fooBar()
}

extension FooBar {
    func setup(with type: DataType) {
        print("setup inside extension FooBar where Self: UIView")
        customSetup(with: type)
    }
}

final class MyView: UIView {}
extension MyView: FooBar {
    typealias DataType = MyDataType
    func customSetup(with type: MyDataType) {
        print("customSetup inside extension of MyView")
    }
    
    func fooBar() {}
}

let myView = MyView()
myView.setup(with: MyDataType())