//: Playground - noun: a place where people can play

import UIKit

protocol Foo {
    func calculatePythagoras(minorCathetus: Int, majorCathetus: Int) -> Int
}

extension Foo where Self: NSObject {
    func calculatePythagoras(minorCathetus: Int, majorCathetus: Int) -> Int{
        
    }
    @objc func callFoo() {
        guard let foo = self as? Foo else { return }
        foo.foo()
    }
    @objc func foo() { print("foo") }
}

class FooClass: NSObject, Foo {
    override init() {}
    
//    func foo() { print("foo") }
    
    func setupSelector() -> UIButton {
        let button = UIButton()
        button.addTarget(foo, action: #selector(foo), for: .primaryActionTriggered)
        return button
    }
    
}

let foo = FooClass()
foo.foo()


