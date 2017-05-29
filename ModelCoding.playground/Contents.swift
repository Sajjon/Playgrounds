//: Playground - noun: a place where people can play

import UIKit
import Foundation

protocol ToClassConvertible: Codable {
    associatedtype ToClass: Codable
    var `class`: ToClass { get }
}

extension ToClassConvertible {
    var `class`: ToClass {
        let encoded = try! JSONEncoder().encode(self)
        return try! JSONDecoder().decode(ToClass.self, from: encoded)
    }
}

protocol ToStructConvertible: class, Codable {
    associatedtype ToStruct: Codable
    var `struct`: ToStruct { get }
}

extension ToStructConvertible {
    var `struct`: ToStruct {
        let encoded = try! JSONEncoder().encode(self)
        return try! JSONDecoder().decode(ToStruct.self, from: encoded)
    }
}

protocol UserModel: Codable {
    associatedtype CodingKeys = UserKeys
    var firstname: String { get }
    var lastname: String { get }
}

enum UserKeys: String, CodingKey {
    case firstname = "firstName"
    case lastname
}

struct UserStruct: UserModel {
    let firstname: String
    let lastname: String
}

final class UserClass: UserModel {
    let firstname: String
    let lastname: String
    init(firstname: String, lastname: String) {
        self.firstname = firstname
        self.lastname = lastname
    }
}

extension UserClass: ToStructConvertible {
    typealias ToStruct = UserStruct
}

extension UserStruct: ToClassConvertible {
    typealias ToClass = UserClass
}


let json = try! JSONEncoder().encode([UserKeys.firstname.rawValue: "Alex", UserKeys.lastname.rawValue: "Cyon"])

let userClass = try! JSONDecoder().decode(UserClass.self, from: json)
let userStruct =  userClass.struct
let userClassAgain = userStruct.class
print(userClass.firstname)
print(userStruct.firstname)
print(userClassAgain.firstname)



/*
 class PersistenceClass: NSObject {}
 typealias Persistable = PersistenceClass & ToStructConvertible
 typealias Model = ToClassConvertible
 
 protocol Observable {
 associatedtype Value
 func onNext(_ onNext: (Value) -> Void)
 }
 
 struct Observer<Value> {
 func onNext(_ onNext: (Value) -> Void) {}
 func onError(_ onError: (Error) -> Void) {}
 }
 
 struct Future<FutureValue> {
 typealias ObserverClosure<V> = (Observer<V>) -> Void
 private let observer: ObserverClosure<FutureValue>
 init(_ observer: @escaping ObserverClosure<FutureValue>) {
 self.observer = observer
 }
 }
 extension Future: Observable {
 typealias Value = FutureValue
 func onNext(_ onNext: (Value) -> Void) {}
 }
 
 protocol RequestConvertible {
 var request: URLRequest { get }
 }
 
 protocol HTTPClientProtocol {
 func makeArrayRequest<M: Model>(_ request: RequestConvertible) -> Future<[M]>
 }
 
 protocol Persistence {
 func get<P: Persistable>() -> Future<[P]>
 func save<P: Persistable>(_ persistables: [P])
 }
 
 protocol Repository {
 var persistence: Persistence { get }
 var httpClient: HTTPClientProtocol { get }
 func getModels<M: Model, P: Persistable>(request: RequestConvertible?) -> Future<[M]> where M.ToClass == P, P.ToStruct == M
 }
 
 extension Repository {
 func getModels<M: Model, P: Persistable>(request: RequestConvertible?) -> Future<[M]> where M.ToClass == P, P.ToStruct == M {
 return Future<[M]> { observer in
 
 let persistenceFuture: Future<[P]> = self.persistence.get()
 persistenceFuture.onNext { (persisted: [P]) in
 //                let converted: [M] = persisted.map { $0.struct as M }
 var converted = [M]()
 for p in persisted {
 converted.append(p.struct as M)
 }
 observer.onNext(converted)
 }
 
 guard let request = request else { return }
 
 let backendFuture: Future<[M]> = self.httpClient.makeArrayRequest(request)
 backendFuture.onNext { (apiModels: [M]) in
 let persisted: [P] = apiModels.map { $0.class }
 self.persistence.save(persisted)
 }
 }
 }
 }
 */
