//: Playground - noun: a place where people can play

import UIKit

protocol Event {}

typealias AnyHashableObject = AnyObject & Hashable
protocol Listener: AnyHashableObject {
//    func listen(to event: Event, from source: EventSource)
//    func remove(from source: EventSource)
}

protocol EventSource {
    associatedtype ListenerType: Listener
    var listeners: Set<WeakBox<ListenerType>> { get set }
    func addListerner(_ listener: ListenerType)
    func removeListener(_ listener: ListenerType)
}

extension EventSource {
    mutating func addListerner(_ listener: ListenerType) {
        listeners.insert(WeakBox(listener))
    }

    mutating func removeListener(_ listener: ListenerType) {
        listeners.remove(WeakBox(listener))
    }
}

struct WeakBox<T: AnyHashableObject>: Hashable {
    weak var value: T?
    init(_ value: T?) {
        self.value = value
    }
    
    var hashValue: Int { return value?.hashValue ?? 0 }
    static func == (lhs: WeakBox, rhs: WeakBox) -> Bool {
        return lhs.value == rhs.value
    }
}

//protocol SessionListener: Listener {}

final class SessionManager: EventSource {
//    typealias ListenerType = SessionListener
    let loginService: LoginServiceProtocol
    
}
protocol LoginServiceProtocol {
    func login(email: String, password: String, done: Done<User>)
}

protocol Model {}
enum Result<M: Model> {
    case failure(Error)
    case success(M)
}

typealias Done<M: Model> =  (Result<M>) -> Void
struct User: Model {}

final class LoginViewViewModel {
    private let sessionManager: SessionManager
    
    func login(email: String, password: String) {
        sessionManager.loginService.login(email: email, password: password) {
            switch $0 {
            case .success(let user):
                sessionManager.
                print("success")
            case .failure(let error):
                print("Failed to login user, error: \(error)")
            }
        }
    }
}