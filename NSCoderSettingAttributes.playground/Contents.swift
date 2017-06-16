//: Playground - noun: a place where people can play

import UIKit

//func make<V: NSCoding>(from style: ViewStyle) -> V? {
//    return V(coder: style.encoded)
//}
//
//protocol CreateEmpty {
//    associatedtype SelfType
//    static func createEmpty() -> SelfType
//}
//
//protocol ViewCreator: CreateEmpty {
//    init(style: ViewStyle)
//}


//extension UILabel {
//    convenience init?(style: ViewStyle) {
//        self.init(coder: style.encoded)
//    }
//}

extension NSCoder {
    
    func encode(_ value: Any?, forKey key: CodingKeys) {
        encode(value, forKey: key.rawValue)
    }
    
    func decodeValue<Value>(forKey key: CodingKeys) -> Value? {
        return decodeObject(forKey: key.rawValue) as? Value
    }
}

enum CodingKeys: String {
    case text, backgroundColor, textColor, clazz
}

final class SajjonLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.text = aDecoder.decodeValue(forKey: .text)
        if let text = text {
            print("Sajjonlabel set text: `\(text)`")
        }
    }
}

final class ViewStyle: NSObject, NSCoding {
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var text: String?
    init(backgroundColor: UIColor? = nil, textColor: UIColor? = nil, text: String? = nil) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.text = text
    }
    

    
    public func encode(with aCoder: NSCoder) {
        print("encode:with")
        if let text = text {
            aCoder.encode(text, forKey: .text)
        }
        
        if let backgroundColor = backgroundColor {
        aCoder.encode(backgroundColor, forKey: .backgroundColor)
//            print("encoded backgroundcolor")
        }
        
        if let textColor = textColor {
            aCoder.encode(textColor, forKey: .textColor)
//            print("encoded textColor")
        }
        
        if let nameOfViewClass = nameOfClassOfView {
            aCoder.encode(nameOfViewClass, forKey: .clazz)
//            print("encoding clazzName: `\(nameOfViewClass)`")
        }
    }
    
    public init?(coder aDecoder: NSCoder) {
        super.init()
        print("init:coder")
    
        text = aDecoder.decodeValue(forKey: .text)
        backgroundColor = aDecoder.decodeValue(forKey: .backgroundColor)
        textColor = aDecoder.decodeValue(forKey: .textColor)
        nameOfClassOfView = aDecoder.decodeValue(forKey: .clazz)
        
    
        if let clazzName = nameOfClassOfView, let clazz = NSClassFromString(clazzName), let viewClass = clazz as? UIView.Type {
            theView = viewClass.init(coder: aDecoder)
        }
        
 
        print("RETURNING NIL")
        
//        return nil
    } // NS_DESIGNATED_INITIALIZER
    var nameOfClassOfView: String?
    var theView: UIView?
//    var _classForCoder: UIView.Type!
    
    var codeStuffAsView = false
    
//    override var classForCoder: AnyClass {
//        if codeStuffAsView {
//            print("OVERRIDING classForCoder")
//            return _classForCoder
//        }
//        return super.classForCoder
//    }
    
    func createView<V: UIView>() -> V? {
        print("trying to create view")
//        _classForCoder = V.self
        let clazzDescription = V.self.description()
        print("clazzDescription: `\(clazzDescription)`")
        nameOfClassOfView = clazzDescription
        print("setting `classForCoder` to: `\(V.self)`")
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        print("archived")
        let decodedShit = NSKeyedUnarchiver.unarchiveObject(with: data)
        print("unarchived")
        if let viewStyle = decodedShit as? ViewStyle {
            print("IS viewStyle: `\(viewStyle)`")
            if let underlyingView = viewStyle.theView {
                print("has underlying view")
                if let underlyingLabel = underlyingView as? UILabel {
                    print("underlying view is Label")
                    if let textOfTheDecodedLabel = underlyingLabel.text {
                        print("has text: \(textOfTheDecodedLabel)")
                    } else {
                        print("but has no text")
                    }
                }
            } else {
                print("but has no underlying view")
            }
        }
        
        if let label = decodedShit as? UILabel {
            print("IS label: `\(label)`")
            if let textOfTheDecodedLabel = label.text {
                print("has text: \(textOfTheDecodedLabel)")
            } else {
                print("but has no text")
            }
        }
        return (decodedShit as? ViewStyle)?.theView as? V
    }
}

//extension NSCoder {
//    func encode<Value>(_ optionalValue: Value?, forKey key: String) {
//        print("encode optional")
//        guard let value = optionalValue else { return }
//        print("encode optional had value")
//        print("Value: `\(value)`, key: `\(key)`")
//        encode(value, forKey: key)
//    }
//}

let style = ViewStyle(backgroundColor: .red, textColor: .blue, text: "*************\n\n\n\nqwertyfdafafanfljuiop\n\n\n\n\n********")
let label: SajjonLabel? = style.createView()
//let label = UILabel(style: style)
//print(label.text!)
if let text = label?.text {
    print("Label has text: `\(text)`")
} else {
    print("no text")
}
print("banan")
