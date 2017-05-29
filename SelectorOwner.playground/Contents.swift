//: Playground - noun: a place where people can play

import UIKit

struct Actor {
    let target: NSObject
    let selector: Selector
    let event: UIControlEvents
}

func inspect(selector: Selector) {
    let mirror = Mirror(reflecting: selector)
    mirror.displayStyle
    mirror.subjectType
    for child in mirror.children {
        print(child)
    }
}

extension NSObject {
    func target(_ selector: Selector, event: UIControlEvents = .primaryActionTriggered) -> Actor {
        inspect(selector: selector)
        return Actor(target: self, selector: selector, event: event)
    }
}

//func autoTarget(_ selector: Selector, event: UIControlEvents = .primaryActionTriggered) -> Actor {
//    return Actor(target: self, selector: selector, event: event)
//}

final class Clazz: NSObject {
    func foobar() {}
    func makeTarget() {
        let actor = self.target(#selector(foobar))
    }
}

let clazz = Clazz()
clazz.makeTarget()