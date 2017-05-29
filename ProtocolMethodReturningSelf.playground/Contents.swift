//: Playground - noun: a place where people can play

import UIKit

protocol TextHolder: class {
    var font: UIFont! { get set}
    func setFont(_ font: UIFont) -> Self
}

extension TextHolder {
    func setFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
}

extension UILabel: TextHolder {}

let label = UILabel(frame: .zero).setFont(.boldSystemFont(ofSize: 10))
print(label.frame.height)
