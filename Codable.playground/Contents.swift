//: Playground - noun: a place where people can play

import UIKit

struct StringCodableMap<Decoded: LosslessStringConvertible>: Codable {
    let decoded: Decoded
    init(_ decoded: Decoded) {
        self.decoded = decoded
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(String.self)
        guard let decoded = Decoded(decodedString) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath,
                      debugDescription: "The string \(decodedString) is not representable as a \(Decoded.self)")
            )
        }
        self.decoded = decoded
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(decoded.description)
    }
}

protocol StructRepresentable: class, Codable {
    associatedtype Struct: ClassRepresentable
    func asStruct() -> Struct
}

extension StructRepresentable {
    func asStruct() -> Struct {
        let json = try! JSONEncoder().encode(self)
        return try! JSONDecoder().decode(Struct.self, from: json)
    }
}

protocol ClassRepresentable: Codable {
    associatedtype Class: StructRepresentable
    func asClass() -> Class
}

extension ClassRepresentable {
    func asClass() -> Class {
        let json = try! JSONEncoder().encode(self)
        return try! JSONDecoder().decode(Class.self, from: json)
    }
}


enum UserKeys: String, CodingKey {
    case userId = "id"
    case name, height
}

enum NameKeys: String, CodingKey {
    case firstName = "firstname"
    case lastName = "lastname"
}

protocol NameModel: Codable, CustomStringConvertible {
    var firstName: String { get }
    var lastName: String { get }
    init(firstName: String, lastName: String)
}

extension NameModel {
    init(_ name: NameModel) {
        self.init(firstName: name.firstName, lastName: name.lastName)
    }
}

//CustomStringConvertible
extension NameModel {
    var description: String {
        return "firstName: \(firstName), lastName: \(lastName)"
    }
}

extension NameModel {
    typealias CodingKeys = NameKeys
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        self.init(firstName: firstName, lastName: lastName)
    }
    //Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
    }
}

// typealias Codable = Decodable & Encodable
protocol UserModel: Codable, CustomStringConvertible {
    var userId: Int { get }
    var name: NameModel { get set }
    var height: String { get }
    
    init(userId: Int, name: NameModel, height: String)
}

enum MyError: Error {
    case encodingError
}

//self.price = try container.decode(StringCodableMap<Double>.self, forKey: .price).decoded
extension UserModel {
    typealias CodingKeys = UserKeys
    
    //Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userId = try container.decode(Int.self, forKey: .userId)
        let name = try container.decode(NameStruct.self, forKey: .name)
        let height = try container.decode(String.self, forKey: .height)
        self.init(userId: userId, name: name, height: height)
    }
    //Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(NameStruct(name), forKey: .name)
        try container.encode(height, forKey: .height)
    }
    
}

extension UserModel {
    var description: String {
        return """
        User(id: `\(userId)`, name: `\(name)`, height: \(String(format: "%.2f", height))
        """
    }
}

struct NameStruct: NameModel {
    let firstName: String
    let lastName: String
}

final class NameClass: NameModel {
    let firstName: String
    let lastName: String
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct UserStruct: UserModel, ClassRepresentable {
    typealias Class = UserClass
    
    let userId: Int
    var name: NameModel
    let height: String
}

final class UserClass: UserModel, StructRepresentable {
    typealias Struct = UserStruct
    
    let userId: Int
    
    var _name: NameClass
    var name: NameModel {
        get { return _name }
        set { _name = NameClass(newValue) }
    }
    
    let height: String
    init(userId: Int, name: NameModel, height: String) {
        self.userId = userId
        self._name = NameClass(name)
        self.height = height
    }
}


let json = """
{
    "id": 237,
    "name": {
        "firstname": "Alex",
        "lastname": "Cyon"
    },
    "height": "175.5"
}
""".data(using: .utf8)! // our data in native (JSON) format

let userClassFromJson = try! JSONDecoder().decode(UserClass.self, from: json)

let userStructFromClass = userClassFromJson.asStruct()
print(userStructFromClass)

let userClassFromUserStruct = userStructFromClass.asClass()
print(userClassFromUserStruct)

let userStructFromJson = try! JSONDecoder().decode(UserStruct.self, from: json)
print(userStructFromJson)
let userClassFromUserStructFromJson = userStructFromJson.asClass()
print(userClassFromUserStructFromJson)

func printUser(_ user: UserModel) {
    print(user)
}

func printUserClass(_ user: UserClass) {
    print(user)
}

func printUserStruct(_ user: UserStruct) {
    print(user)
}

//printUser(userClassFromUserStruct)
//printUserClass(userClassFromUserStruct)
//printUserStruct(userStructFromJson)






