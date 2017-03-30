//: Playground - noun: a place where people can play

import UIKit

protocol VehicleProtocol {
    func drive(to destination: CGPoint)
}

protocol Parking {
    func park<Vehicle: VehicleProtocol>(vehicle: Vehicle)
}

extension NSObject {
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

protocol CountryProtocol {
    associatedtype Animal: NSObject
}

protocol AnimalProtocol {
    associatedtype Country: CountryProtocol
    static var name: String { get }
}

class Tanzania: NSObject, CountryProtocol {
    typealias Animal = Lion
}

class Lion: NSObject, AnimalProtocol {
    typealias Country = Tanzania
    static var name: String {
        return className
    }
}


protocol HunterProtocol {
    func hunt<CountryToHuntIn: NSObject, AnimalToHunt: AnimalProtocol>(animal: AnimalToHunt.Type) where AnimalToHunt.Country == CountryToHuntIn, CountryToHuntIn: CountryProtocol, CountryToHuntIn.Animal == AnimalToHunt
}

extension HunterProtocol {
    func hunt<CountryToHuntIn: NSObject, AnimalToHunt: AnimalProtocol>(animal: AnimalToHunt.Type) where AnimalToHunt.Country == CountryToHuntIn, CountryToHuntIn: CountryProtocol, CountryToHuntIn.Animal == AnimalToHunt {
        print("Hunting \(animal.name)s in \(CountryToHuntIn.className)")
    }
}

protocol SafariHunterProtocol: HunterProtocol {

}