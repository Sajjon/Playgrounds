//: Playground - noun: a place where people can play

import UIKit

protocol Bar {
    init(cyon: Int)
}

extension UILabel: Bar {
    convenience init(cyon: Int) {
        
    }
}

protocol Foo {
    static func make(cyon: Int) -> AnyObject
}

class IntHolder {
    var value: Int = 0
}

extension IntHolder: Foo {
    static func make(cyon: Int) -> AnyObject {
        let instance = IntHolder()
        instance.value = cyon
        return instance
    }
}

//extension UIButton: Foo {
//    convenience init(cyon: Int) {
//        self.init(frame: .zero)
//    }
//}
//
//extension Int: Foo {
//    init(cyon: Int) {
//        self = cyon
//    }
//}
