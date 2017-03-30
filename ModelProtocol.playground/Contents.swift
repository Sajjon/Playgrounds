//: Playground - noun: a place where people can play

import UIKit

struct JSON {
    let json: [String: Any]
    func value<Value>(_ key: String) throws -> Value {
        guard let value = json[key] as? Value else { throw NSError() }
        return value
    }
}

protocol JSONDeserializable {
    init(json: JSON) throws
}

protocol JSONSerializable {
    func toJSON() -> JSON
}

protocol UserModel: JSONDeserializable {
    var username: String { get }
    var firstname: String { get }
    var lastname: String { get }
    var country: String { get }
    init(
        username: String,
        firstname: String,
        lastname: String,
        country: String
    )
}

extension UserModel {
    init(json: JSON) throws {
        self.init(
            username: try json.value("username"),
            firstname: try json.value("firstname"),
            lastname: try json.value("lastname"),
            country: try json.value("country")
        )
    }
}

struct UserStruct: UserModel {
    let username: String
    let firstname: String
    let lastname: String
    let country: String
}

class ManagedObject: NSObject {}

final class UserClass: ManagedObject, UserModel {
    let username: String
    let firstname: String
    let lastname: String
    let country: String
    init(
        username: String,
        firstname: String,
        lastname: String,
        country: String
        ) {
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.country = country
    }
}

let json: JSON = JSON(json: [
    "username": "Sajjon",
    "firstname": "Alexander",
    "lastname": "Cyon",
    "country": "Sweden"
    ])
let u1 = try UserStruct(json: json)
let u2 = try UserClass(json: json)
print(u1.username) // prints "Sajjon"
print(u2.username) // prints "Sajjon"


protocol ToStructConvertible: class, JSONSerializable {
    associatedtype ToStruct: JSONDeserializable
    var asStruct: ToStruct { get }
}

extension ToStructConvertible {
    var asStruct: ToStruct {
        return try! ToStruct(json: toJSON())
    }
}

protocol BaseToClassConvertible {
    var classType: NSObject.Type { get }
    var asNSObject: NSObject { get }
}


extension BaseToClassConvertible {
    var asNSObject: NSObject {
        guard let jsonDeserializable = classType as? JSONDeserializable else { fatalError("should be jsondeserializable") }
        guard let jsonSerializable = self as? JSONSerializable else { fatalError("should be jsonserializable") }
        let json: JSON = jsonSerializable.toJSON()
        return jsonDeserializable.init(from: json)
    }
}

protocol ToClassConvertible: BaseToClassConvertible {
    associatedtype ToClass: NSObject
    var asClass: ToClass { get }
}

extension ToClassConvertible {
    var classType: NSObject.Type { return ToClass.self }
    var asClass: ToClass { return self.asNSObject as! ToClass }
}

typealias Model = JSONDeserializable & ToClassConvertible
typealias Persisted = JSONSerializable & ToStructConvertible
protocol Repository {
    func getModels<P: ManagedObject, M: Model>() -> [M] where M.ToClass == P, P: Persisted, P.ToStruct == M
}

extension Repository {
    func getModels<P: ManagedObject, M: Model>() -> [M] where M.ToClass == P, P: Persisted, P.ToStruct == M {
        fatalError()
    }
}
