//: Playground - noun: a place where people can play

import UIKit

//: Playground - noun: a place where people can play

import UIKit

protocol Attributed: AnyAttributed, ExpressibleByArrayLiteral {
    associatedtype Attribute
    var attributes: [Attribute] { get }
    init(_ attributes: [Attribute])
    associatedtype Element = Attribute
}

protocol AnyAttributed {
    func install<S: Styleable>(on styleable: S)
}

protocol Styleable: ExpressibleByArrayLiteral {
    associatedtype Style: Attributed
    var style: Style { get }
    init(style: Style)
    associatedtype Element = Style.Element
}

extension Styleable {
    init(arrayLiteral elements: Style.Attribute...) {
        self.init(style: Style(elements))
    }
}

extension Styleable {
    func setup(with style: Style) {
        style.install(on: self)
    }
}









enum ViewAttributes {
    case text(String)
    case custom(AnyAttributed)
}

extension ViewStyle {
    func install<S: Styleable>(on styleable: S) {
        attributes.forEach {
            switch $0 {
            case .text(let text):
                if var textHolder = styleable as? TextHolder {
                    textHolder.text = text
                }
            case .custom(let attributed):
                attributed.install(on: styleable)
            }
        }
    }
}

struct ViewStyle: Attributed {
    let attributes: [ViewAttributes]
    
    init(_ attributes: [ViewAttributes]) {
        self.attributes = attributes
    }
    
    typealias Element = ViewAttributes
    init(arrayLiteral elements: ViewAttributes...) {
        self.attributes = elements
    }
}

protocol TextHolder {
    var text: String? { get set }
}

final class Label: TextHolder, Styleable {
    var text: String?
    var foo: String?
    let style: ViewStyle
    init(style: ViewStyle) {
        self.style = style
        setup(with: style)
    }
}

enum LabelAttribute {
    case foo(String)
}

struct LabelStyle: Attributed {
    let attributes: [LabelAttribute]
    
    init(_ attributes: [LabelAttribute]) {
        self.attributes = attributes
    }
    
    init(arrayLiteral elements: LabelAttribute...) {
        self.attributes = elements
    }
    
    func install<S: Styleable>(on styleable: S) {
        attributes.forEach {
            switch $0 {
            case .foo(let foo):
                if let label = styleable as? Label {
                    print("fuck yeah")
                    label.foo = foo
                }
            }
        }
    }
}


let label: Label = [.text("Hej"), .custom(LabelStyle([.foo("bar")]))]
label.text!
label.foo!

final class SimpleLabel: TextHolder, Styleable {
    var text: String?
    let style: ViewStyle
    init(style: ViewStyle) {
        self.style = style
        setup(with: style)
    }
}

let simpleLabel: SimpleLabel = [.text("Haha")]
simpleLabel.text!
