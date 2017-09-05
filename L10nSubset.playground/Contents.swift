//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//: Playground - noun: a place where people can play

import UIKit

let localizableStrings = [
    "Screen.Profile.Title": "Profile",
    "Screen.Profile.Label.FirstName": "Firstname",
    "Screen.Profile.Label.LastName": "Lastname",
    "Screen.Profile.Label.Email": "Email"
]

protocol Localizable: CustomStringConvertible {
    var translated: String { get }
}

extension Localizable {
    var description: String { return translated }
}

//MARK: - L9e
enum L9e: Localizable {
    indirect case screen(Screen)
    enum Screen: Localizable {
        
        indirect case profile(Profile)
        enum Profile: Localizable {
            case title
            
            indirect case label(Label)
            enum Label: Localizable {
                case firstName
                case lastName
                case email
                
                var translated: String {
                    switch self {
                    case .firstName:
                        return tr("Screen.Profile.Label.FirstName")
                    case .lastName:
                        return tr("Screen.Profile.Label.LastName")
                    case .email:
                        return tr("Screen.Profile.Label.Email")
                    }
                }
            }
            
            var translated: String {
                switch self {
                case .title:
                    return tr("Screen.Profile.Title")
                case .label(let label):
                    return label.translated
                }
            }
        }
        
        var translated: String {
            switch self {
            case .profile(let profile):
                return profile.translated
            }
        }
    }
    
    var translated: String {
        switch self {
        case .screen(let screen):
            return screen.translated
        }
    }
    
    static func tr(_ key: String) -> String {
        return localizableStrings[key] ?? "STRING_NOT_FOUND"
    }
    
    func tr(_ key: String) -> String {
        return L9e.tr(key)
    }
}

//MARK: - L10n
enum L10n {
    enum Screen {
        enum Profile {
            static let title = tr("Screen.Profile.Title")
            enum Label {
                static let firstName = tr("Screen.Profile.Label.FirstName")
                static let lastName = tr("Screen.Profile.Label.LastName")
                static let email = tr("Screen.Profile.Label.Email")
            }
        }
    }
    static func tr(_ key: String) -> String {
        return localizableStrings[key] ?? "STRING_NOT_FOUND"
    }
}


//MARK: - LabelsView
extension UILabel {
    convenience init(_ text: String) { self.init(frame: .zero); self.text = text }
}

final class LabelsView: UIView {
    let titleLabel: UILabel; let valueLabel: UILabel
    init(title: String, value: String) {
        titleLabel = UILabel(title); valueLabel = UILabel(value) //then stack them using UIStackViwe
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override var description: String {
        guard let title = titleLabel.text, let value = valueLabel.text else { return "" }
        return "`\(title)`: `\(value)`"
    }
}

//MARK: - User Model
struct User {
    let firstName: String
    let lastName: String
    let email: String
}

func profileLabels(_ title: String, _ valueKeyPath: KeyPath<User, String>, in user: User) -> LabelsView {
    let value: String = user[keyPath: valueKeyPath]
    return LabelsView(title: title, value: value)
}

//MARK: - ProfileL9eViewController
func profileLabelsL9e(_ key: L9e.Screen.Profile.Label, _ valueKeyPath: KeyPath<User, String>, in user: User) -> LabelsView {
    return profileLabels(key.translated, valueKeyPath, in: user)
}

protocol ProfileView {
    var firstNameLabels: LabelsView { get set }
    var lastNameLabels: LabelsView { get set }
    var emailLabels: LabelsView { get set }
}
extension ProfileView {
    func printLabels() {
        
        print(firstNameLabels)
        print(lastNameLabels)
        print(emailLabels)
    }
}

final class ProfileL9eViewController: UIViewController, ProfileView {
    let user: User
    lazy var firstNameLabels: LabelsView = profileLabelsL9e(.firstName, \.firstName, in: self.user)
    lazy var lastNameLabels: LabelsView = profileLabelsL9e(.lastName, \.lastName, in: self.user)
    lazy var emailLabels: LabelsView = profileLabelsL9e(.email, \.email, in: self.user)
    
    init(user: User) { self.user = user; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L9e.Screen.Profile.title.translated
    }
}

//MARK: - ProfileL10nViewController
final class ProfileL10nViewController: UIViewController, ProfileView {
    let user: User
    lazy var firstNameLabels: LabelsView = profileLabels(L10n.Screen.Profile.Label.firstName, \.firstName, in: self.user)
    lazy var lastNameLabels: LabelsView = profileLabels(L10n.Screen.Profile.Label.lastName, \.lastName, in: self.user)
    lazy var emailLabels: LabelsView = profileLabels(L10n.Screen.Profile.Label.email, \.email, in: self.user)
    
    init(user: User) { self.user = user; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Screen.Profile.title
    }
}



let user = User(firstName: "Alex", lastName: "Cyon", email: "alex.cyon@gmail.com")

let profileL9eVC = ProfileL9eViewController(user: user)
profileL9eVC.printLabels()

print("\n$$$ PRINTING L10n viewcontroller $$$\n")

let profileL10nVC = ProfileL10nViewController(user: user)
profileL10nVC.printLabels()



