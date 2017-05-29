//: Playground - noun: a place where people can play

import UIKit

extension String {
    var titlecased: String {
        return self.capitalized(with: Locale.current)
    }
}



func verify(_ string: String, _ facit: String) { assert(string.titlecased == facit) }

verify("", "")
verify("a", "A")
verify("we're having dinner in the garden", "We're Having Dinner In The Garden")
verify("ONLY CAPS", "Only Caps")
print("ONLY CAPS".titlecased)