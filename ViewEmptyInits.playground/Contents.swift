//: Playground - noun: a place where people can play

import UIKit

protocol CreateEmpty {
    associatedtype SelfType
    static func make() -> SelfType
}

func make<C: CreateEmpty>() -> C {
    return C.make() as! C
}

func viewFactory<E: NSObject>() -> E {
    return E.init()
}

extension NSObject: CreateEmpty {
    static func make() -> UILabel {
        return viewFactory()
    }
}

//extension UILabel: CreateEmpty {
//    static func make() -> UILabel {
//        return viewFactory()
//    }
//}

let label: UILabel = make()
label.text = "hej"
print(label.text!)
let cv: UICollectionView = make()


//
//
//extension UICollectionView {
//    @nonobjc convenience init() {
//        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    }
//}
//
//let label = UILabel()
//let button = UIButton()
//let field = UITextField()
//let textView = UITextView()
//let stackView = UIStackView()
//let tableView = UITableView()
//let collectionView = UICollectionView()
//let switch_ = UISwitch()
