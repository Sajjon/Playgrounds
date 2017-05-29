//: Playground - noun: a place where people can play

import UIKit
func requiredInit() -> Never { fatalError() }

protocol StrippedRepresentation: RawRepresentable, Equatable, Hashable {
    associatedtype AssociatedValueType
}//, CustomStringConvertible {}

protocol AssociatedValueStrippable {
    associatedtype Stripped: StrippedRepresentation
    var stripped: Stripped { get }
}

protocol AssociatedValueExtractable {
//    var associatedValue: AssociatedValue { get }
//    func extractAssociatedValue<AssociatedValue>() -> AssociatedValue
    var associatedValue: Any { get }
}

extension Array where Element: AssociatedValueStrippable {
    func filter(stripped: [Element.Stripped]) -> [Element] {
        let filtered = filter { stripped.contains($0.stripped) }
        return filtered
    }
}

//extension Array where Element: StrippedRepresentation {
//    func filter(
//}

//protocol AssociatedValueConvertible {
//    associatedtype AssociatedValueRepresentation: AssociatedValueStrippable
//    func associatedValueRepresentation<Value>(AssociatedValueRepresentation) ->
//}

enum ViewAttribute {
    case backgroundColor(UIColor)
    case cornerRadius(CGFloat)
}

extension ViewAttribute {
    
//    var associatedValue: AssociatedValue {
//        return extractAssociatedValue()
//    }
    
    var associatedValue: Any {
        switch self {
        case .backgroundColor(let backgroundColor):
            return backgroundColor
        case .cornerRadius(let cornerRadius):
            return cornerRadius
        }
    }
//    func extractAssociatedValue<AssociatedValue>() -> AssociatedValue {
//        switch self {
//        case .backgroundColor(let backgroundColor):
//            return backgroundColor as AssociatedValue
//        case .cornerRadius(let cornerRadius):
//            return cornerRadius as AssociatedValue
//        }
//    }
    
//    var backgroundColor: UIColor? {
//        switch self {
//        case .backgroundColor(let backgroundColor):
//            return backgroundColor
//        default:
//            return nil
//        }
//    }
//    
//    var cornerRadius: CGFloat? {
//        switch self {
//        case .cornerRadius(let cornerRadius):
//            return cornerRadius
//        default:
//            return nil
//        }
//    }
}

enum ViewAttributeStripped: String, StrippedRepresentation {
    typealias AssociatedValueType = ViewAttribute
    case backgroundColor
    case cornerRadius
}

//extension ViewAttributeStripped: AssociatedValueConvertible {
//    typealias AssociatedValueRepresentation = ViewAttribute
//    var associatedValueRepresentation: AssociatedValueRepresentation {
//        switch self {
//        case .backgroundColor:
//            fatalError()
//        case .cornerRadius:
//            fatalError()
//        }
//    }
//}

extension ViewAttribute: AssociatedValueStrippable {
    typealias Stripped = ViewAttributeStripped
    var stripped: Stripped {
        switch self {
            case .backgroundColor:
                return .backgroundColor
            case .cornerRadius:
                return .cornerRadius
        }
    }
}


final class ViewStyle {
    let attributes: [ViewAttribute]
    init(_ attributes: [ViewAttribute]) {
        self.attributes = attributes
    }
}

class View: UIView {
    let style: ViewStyle
    init(_ style: ViewStyle) {
        self.style = style
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { requiredInit() }
}

extension View {
    convenience init(_ attributes: [ViewAttribute]) {
        self.init(ViewStyle(attributes))
    }
}

enum StackViewAttribute {
    case axis(UILayoutConstraintAxis)
    case distribution(UIStackViewDistribution)
}

final class StackViewStyle {
    let attributes: [StackViewAttribute]
    init(_ attributes: [StackViewAttribute]) {
        self.attributes = attributes
    }
}

final class StackView: UIStackView {
    let style: StackViewStyle
    init(_ style: StackViewStyle) {
        self.style = style
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) { requiredInit() }
}


extension StackView {
    convenience init(_ attributes: [StackViewAttribute]) {
        self.init(StackViewStyle(attributes))
    }
}

final class ViewController: UIViewController {
    fileprivate lazy var containerView: View = View([.backgroundColor(.red)])
    fileprivate lazy var stackView: StackView = StackView([.axis(.vertical)])
}

let viewAttribute: ViewAttribute = .cornerRadius(237)
let associatedValue = viewAttribute.associatedValue
type(of: associatedValue)
let strippedAttribute = viewAttribute.stripped
let values: [ViewAttribute] = [viewAttribute, .backgroundColor(.red)]
let strippedValues = [values].map { $0.stripped }
let filtered = values.filter(stripped: [strippedAttribute])
let filtered2 = strippedValues.associatedValues(with: values)


extension Array where Element: StrippedRepresentation {
    func associatedValues<AssociatedValue: AssociatedValueStrippable>(with values: [AssociatedValue]) -> [AssociatedValue] where AssociatedValue == Element.AssociatedValueType, AssociatedValue.Stripped == Element {
        return values.filter(stripped: self) as! [AssociatedValue]
    }
}

