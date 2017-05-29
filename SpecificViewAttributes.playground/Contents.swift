//: Playground - noun: a place where people can play

import UIKit

protocol AnyAttributed {
    func install<S: Styleable>(on styleable: S)
}
protocol Attributed: AnyAttributed, ExpressibleByArrayLiteral {
    associatedtype Attribute: AssociatedValueStrippable
    var attributes: [Attribute] { get }
    init(_ attributes: [Attribute])
    associatedtype Element = Attribute
}

enum ViewAttributes {
    case text(String)
    case custom(AnyAttributed)
}

extension ViewAttributes: Equatable, Hashable {
    static func == (lhs: ViewAttributes, rhs: ViewAttributes) -> Bool {
        return lhs.stripped == rhs.stripped
    }
    
    var hashValue: Int {
        switch self {
        case .text:
            return 0.hashValue
        case .custom:
            return 1.hashValue
        }
    }
}

extension ViewAttributes: AssociatedValueStrippable {
    typealias Stripped = ViewAttributesStripped
    var stripped: Stripped {
        let stripped: ViewAttributesStripped
        switch self {
        case .text:
            stripped = .text
        case .custom:
            stripped = .custom
        }
        return stripped
    }
}

enum ViewAttributesStripped: String, StrippedRepresentation {
    case text, custom
}

protocol StrippedRepresentation: RawRepresentable, Equatable {}
protocol AssociatedValueStrippable: Equatable {
    associatedtype Stripped: StrippedRepresentation
    var stripped: Stripped { get }
}

extension ViewAttributesStripped: Equatable, Hashable {
    static func == (lhs: ViewAttributesStripped, rhs: ViewAttributesStripped) -> Bool {
        return lhs == rhs
    }
    
    var hashValue: Int {
        switch self {
        case .text:
            return 0.hashValue
        case .custom:
            return 1.hashValue
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

protocol TextHolder {
    var text: String? { get set }
}


enum LabelAttribute {
    case foo(String)
}

struct LabelStyle: AnyAttributed {
    let attributes: [LabelAttribute]
    
    init(_ attributes: [LabelAttribute]) {
        self.attributes = attributes
    }
    
    init(arrayLiteral elements: LabelAttribute...) {
        self.attributes = elements
    }
    
}


extension LabelStyle {
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

final class Label: TextHolder, Styleable {
    var text: String?
    var foo: String?
    let style: ViewStyle
    init(style: ViewStyle) {
        self.style = style
        setup(with: style)
    }
}

let label: Label = [.text("Hej"), .custom(LabelStyle([.foo("bar")]))]
label.text!
label.foo!
