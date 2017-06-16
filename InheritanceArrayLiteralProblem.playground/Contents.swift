import UIKit

// This protocol has been REALLY simplified, in fact it has another name and important code.
public protocol ExpressibleByNumberArrayLiteral: ExpressibleByArrayLiteral {
    associatedtype Element
}

public protocol Makeable: ExpressibleByNumberArrayLiteral {
    // we want `init()` but we are unable to satisfy such a protocol from `UILabel`, thus we need this work around
    associatedtype SelfType
    static func make(values: [Element]) -> SelfType
}

public protocol Instantiatable: ExpressibleByNumberArrayLiteral {
    init(values: [Element])
}

// My code might have worked if it would be possible to check for _NON-conformance_ in where clause
// like this: `extension Makeable where !(Self: Instantiatable)`
extension Makeable {
    public init(arrayLiteral elements: Self.Element...) {
        self = Self.make(values: elements) as! Self
    }
}

extension Instantiatable {
    init(arrayLiteral elements: Self.Element...) {
        self.init(values: elements)
    }
}

extension UILabel: Makeable {
    public typealias SelfType = UILabel
    public typealias Element = Int
    
    public static func make(values: [Element]) -> SelfType {
        let label = UILabel()
        label.text = "Sum: \(values.reduce(0,+))"
        return label
    }
}

public class MyLabel: UILabel, Instantiatable {
    public typealias Element = Int
    required public init(values: [Element]) {
        super.init(frame: .zero)
        text = "Sum: \(values.reduce(0,+))"
    }
    
    public required init?(coder: NSCoder) { fatalError() }
}

let vanilla: UILabel = [1, 2, 3, 4]
print(vanilla.text!) // prints: "Sum: 10"


postfix operator ^
postfix func ^<I: Instantiatable>(attributes: [I.Element]) -> I {
    return I(values: attributes)
}


let custom: MyLabel = [1, 2, 3, 4]^
print(custom.text!)
