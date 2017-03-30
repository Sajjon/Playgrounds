//: Playground - noun: a place where people can play

import UIKit

public extension Dictionary {
    func mapKeys<T>(transform: (Key) -> T) -> Dictionary<T, Value> {
        var dict = [T: Value]()
        for (key, value) in zip(self.keys.map(transform), self.values) {
            dict[key] = value
        }
        return dict
    }
}

public protocol JSONKey: Hashable {
    var rawValue: String { get }
}

protocol JSONRepresentable {}
extension String: JSONRepresentable {}
extension Float: JSONRepresentable {}

enum UserKey: String, JSONKey { case firstName, height, lastName }

struct User {
    let firstName: String
//    let height: Float
    let lastName: String

}

protocol JSONEncodable {
    associatedtype Key: JSONKey
    func makeDictionary<T: JSONRepresentable>(_ dictionary: [Key: T]) -> [String: Any]
    var json: [String: Any] { get }
}

extension JSONEncodable {
    func makeDictionary<T: JSONRepresentable>(_ dictionary: [Key: T]) -> [String: Any] {
        return dictionary.mapKeys { $0.rawValue }
    }
}


extension User: JSONEncodable {
    typealias Key = UserKey
    var json: [String: Any] {
        return makeDictionary(
            [
                .firstName: firstName,
                .lastName: lastName
            ]
        )
    }
}

//let user = User(firstName: "Steve", height: 1.75)
let user = User(firstName: "Steve", lastName: "Jobs")
let json = user.json
print(json)
