//: Playground - noun: a place where people can play

import UIKit

extension Optional where Wrapped == String {
    var emptyIfNil: String {
        guard let unwrapped = self else { return "" }
        return unwrapped
    }
}

var string: String? = "bar"
string.emptyIfNil
string = nil
string.emptyIfNil
