//: Playground - noun: a place where people can play

import UIKit


protocol RadiusProtocol: Equatable, Hashable {
    var value: CGFloat? { get }
}

extension RadiusProtocol {
    var value: CGFloat? { return nil }
}

extension Double: RadiusProtocol {
    var value: CGFloat? { return CGFloat(self) }
}

extension Int: RadiusProtocol {
    var value: CGFloat? { return CGFloat(self) }
}

enum ViewAttribute<RadiusValue: RadiusProtocol> {
    case cornerRadius(RadiusValue)
}

extension ViewAttribute {
    func apply(to view: UIView) {
        switch self {
        case .cornerRadius(let radiusProtocol):
            guard let value = radiusProtocol.value else { break }
            print("setting corner radious to: \(value)")
            view.layer.cornerRadius = value
        }
    }
}

enum Radius: RadiusProtocol {
    case rounded
}


let customFloat: ViewAttribute = .cornerRadius(2.0)
let customInt: ViewAttribute = .cornerRadius(3)
let rounded: ViewAttribute = .cornerRadius(Radius.rounded)

let view = UIView()
customFloat.apply(to: view)
customInt.apply(to: view)
rounded.apply(to: view)

