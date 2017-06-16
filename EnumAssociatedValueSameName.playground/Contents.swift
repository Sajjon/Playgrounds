//: Playground - noun: a place where people can play

import UIKit

extension UIImage {
    @nonobjc static let back: UIImage = UIImage()
}

protocol ControlState {
    var state: UIControlState { get }
    
    var title: String? { get set }
    var titleColor: UIColor? { get set }
    var image: UIImage? { get set }
    init(title: String?, titleColor: UIColor?, image: UIImage?)
}

extension ControlState {
    init(_ title: String) {
        self.init(title: title, titleColor: nil, image: nil)
    }
    
    init(_ image: UIImage) {
        self.init(title: nil, titleColor: nil, image: image)
    }

    init(_ title: String, _ titleColor: UIColor) {
        self.init(title: title, titleColor: titleColor, image: nil)
    }
    
    init(_ title: String, _ image: UIImage) {
        self.init(title: title, titleColor: nil, image: image)
    }
    
    init(_ title: String, _ titleColor: UIColor, _ image: UIImage) {
        self.init(title: title, titleColor: titleColor, image: image)
    }
}

struct Normal: ControlState {
    let state: UIControlState = .normal
    
    var title: String?
    var titleColor: UIColor?
    var image: UIImage?
}

struct Highligted: ControlState {
    let state: UIControlState = .highlighted
    
    var title: String?
    var titleColor: UIColor?
    var image: UIImage?
}

struct Disabled: ControlState {
    let state: UIControlState = .disabled
    
    var title: String?
    var titleColor: UIColor?
    var image: UIImage?
}

let states: [ControlState] = [Normal("Hej"), Normal(.back), Disabled("Hej", .red), Normal("Hej", .back), Highligted("Hej", .red, .back)]