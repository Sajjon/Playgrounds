//: [Previous](@previous)

import UIKit

//: Playground - noun: a place where people can play

import UIKit

protocol AnyAttributed {
    func install<S: Styleable>(on styleable: S)
}
protocol Attributed: Collection, ExpressibleByArrayLiteral, AnyAttributed {
    associatedtype Attribute: AssociatedValueStrippable
    var attributes: [Attribute] { get }
    init(_ attributes: [Attribute])
    associatedtype Element = Attribute
    
    var startIndex: Int { get }
}

//extension Attributed {
//    func apply<S: Styleable>(to styleable: )
//}

extension Attributed {
    typealias Index = Int
    typealias Iterator = IndexingIterator<Self>
    typealias Indices = DefaultIndices<Self>
    
    public var endIndex: Int { return count }
    public var count: Int { return attributes.count }
    public var isEmpty: Bool { return attributes.isEmpty }
    
    public subscript (position: Int) -> Self.Attribute { return attributes[position] }
    
    public func index(after index: Int) -> Int {
        guard index < endIndex else { return endIndex }
        return index + 1
    }
    
    public func index(before index: Int) -> Int {
        guard index > startIndex else { return startIndex }
        return index - 1
    }
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
    var startIndex: Int = 0
    
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

protocol Styleable {
    associatedtype Style: Attributed
//    var style: Style { get }
//    init(style: Style)
//    associatedtype Element = Style.Element
    func setup(with style: Style)
//    static func make<S: Styleable>(_ fromStyle: [Style.Attribute]) -> S
}

//extension Styleable {
//    init(arrayLiteral elements: Style.Attribute...) {
//        self.init(style: Style(elements))
//    }
//}

extension Styleable {
    func setup(with style: Style) {
        style.install(on: self)
    }
}

protocol TextHolder {
    var text: String? { get set }
}


enum ButtonAttribute {
    case enabled(Bool)
}

struct ButtonStyle: AnyAttributed {
    let attributes: [ButtonAttribute]
    
    init(_ attributes: [ButtonAttribute]) {
        self.attributes = attributes
    }
    
    init(arrayLiteral elements: ButtonAttribute...) {
        self.attributes = elements
    }
}


extension ButtonStyle {
    func install<S: Styleable>(on styleable: S) {
        guard let button = styleable as? UIButton else { return }
        attributes.forEach {
            switch $0 {
            case .enabled(let enabled):
                button.isEnabled = enabled
            }
        }
    }
}

extension UILabel: TextHolder {}

extension UILabel: Styleable {
    typealias Style = ViewStyle
}

extension UIButton: TextHolder {
    var text: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
}

extension UIButton: Styleable {
    typealias Style = ViewStyle
}

func make(_ fromStyle: [UILabel.Style.Attribute]) -> UILabel {
    let label = UILabel(frame: .zero)
    label.setup(with: ViewStyle(fromStyle))
    return label
}

func make(_ fromStyle: [UIButton.Style.Attribute]) -> UIButton {
    let button = UIButton(frame: .zero)
    button.setup(with: ViewStyle(fromStyle))
    return button
}

class MyView {
    lazy var label: UILabel = make([.text("baz")])
    lazy var button: UIButton = make([.text("press me"), .custom(ButtonStyle([.enabled(false)]))])
}

let view = MyView()
view.label.text!
view.button.text!
view.button.isEnabled