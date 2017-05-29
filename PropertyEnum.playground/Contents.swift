//: Playground - noun: a place where people can play

import UIKit

protocol PropertyRepresentable {}

struct Person {
    let firstname: String
    let lastname: String
}
extension Person: PropertyRepresentable {}

struct Country {
    let name: String
    let capitolName: String
}
extension Country: PropertyRepresentable {}

enum Property {
    indirect case person(PropertyPerson)
    enum PropertyPerson {
        case firstname
        case lastname
    }
    
    indirect case country(PropertyCountry)
    enum PropertyCountry {
        case name
        case capitolName
    }
}

extension Person {
    func valueOf<Value>(property: Property.PropertyPerson) -> Value {
        let value: Any
        switch property {
        case .firstname:
            value = firstname
        case .lastname:
            value = lastname
        }
        return value as! Value
    }
}


struct DebugLabel {
    let title: String
    init(_ title: String) {
        self.title = title
    }
}

extension DebugView {
    func personLabel(_ property: Property.PropertyPerson) -> DebugLabel {
        return DebugLabel(person.valueOf(property: property))
    }
}

class DebugView {
    fileprivate let person: Person
    fileprivate lazy var firstnameLabe1: DebugLabel = DebugLabel(self.person.firstname)
    fileprivate lazy var firstnameLabel: DebugLabel = self.personLabel(.firstname)
//    fileprivate lazy var firstnameLabe1: DebugLabel = DebugLabel(person.firstname)
//    fileprivate lazy var firstnameLabel: DebugLabel = personLabel(.firstname)
    
    fileprivate lazy var lastnameLabel: DebugLabel = self.personLabel(.lastname)
    
    init(person: Person) {
        self.person = person
    }

    func debug() {
        print("Value of label: \(firstnameLabel.title)")
        print("Value of label: \(lastnameLabel.title)")
        Property.PropertyPerson.firstname
    }
}

let alex = Person(firstname: "Alex", lastname: "Cyon")
let view = DebugView(person: alex)
view.debug()