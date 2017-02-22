//: Playground - noun: a place where people can play

import UIKit

let printThreshold = 0

func print(_ level: Int, str: String) {
    guard level >= printThreshold else { return }
    print(str)
}

extension Dictionary {
    func mapValues<T>(transform: (Value) -> T) -> Dictionary<Key, T> {
        var dict = [Key:T]()
        for (key, value) in zip(self.keys, self.values.map(transform)) {
            dict[key] = value
        }
        return dict
    }
}

func unwrap(any :Any) -> Any {
    let mirror = Mirror(reflecting: any)
    if mirror.displayStyle != .optional {
        return any
    }

    if mirror.children.count == 0 { return NSNull() }
    let (_, some) = mirror.children.first!
    return some

}
extension BaseConvertible {
    func asNSObject(_ depth: Int = 0) -> NSObject {
        let nextDepth = depth + 1
        print(1, str: "\n\n*** D:\(depth) - Converting struct '\(type(of: self))' -> '\(classType)' (class) ***\n")
        let mirror = Mirror(reflecting: self)
        let classInstance = classType.init()
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            var processed = value
            processed = unwrap(any: value)

            print(2, str: "type(of:value): '\(type(of: value))'")
            if let array = value as? [BaseConvertible] {
                print(3, str: "found array")
                processed = array.map { $0.asNSObject(nextDepth) }
            } else if let dictionary = value as? [AnyHashable: BaseConvertible] {
                print(3, str: "found dict")
                processed = NSDictionary(dictionary: dictionary.mapValues { $0.asNSObject(nextDepth) })
            } else if let conv = value as? BaseConvertible {
                print(3, str: "found BaseConvertible")
                processed = conv.asNSObject(nextDepth)
            } else {
                print(3, str: "found value type")
            }

            print(2, str: "Name: '\(name)', proccessedValue: '\(processed)'")
            classInstance.setValue(processed, forKey: name)
        }
        return classInstance
    }
}

protocol BaseConvertible {
    var classType: NSObject.Type { get }
    //var asNSObject: NSobjet { get }
    func asNSObject(_ depth: Int) -> NSObject
}


protocol Convertible: BaseConvertible {
    associatedtype To: NSObject
    var asClass: To { get }
}

extension Convertible {
    var asClass: To {
        return self.asNSObject() as! To
    }

    var classType: NSObject.Type { return To.self }
}

//MARK: - **** USAGE ****

//MARK: Engine
struct Engine {
    let cylinderCount: Int
}

extension Engine: Convertible {
    typealias To = EngineClass
}

class EngineClass: NSObject {
    var cylinderCount: Int = 0

    override init() {
        super.init()
    }

    override var description: String {
        return "Cylinder count: \(cylinderCount)"
    }
}

//MARK: Vehicle
struct Vehicle {
    let price: Int
    let engine: Engine
}

extension Vehicle: Convertible {
    typealias To = VehicleClass
}

class VehicleClass: NSObject {
    var price: Int = 0
    var engine: EngineClass?

    override init() {
        super.init()
    }

    override var description: String {
        let noEngine = "no engine"
        return "VehicleClass(Price: \(price), engine: '\(engine?.description ?? noEngine)')"
    }
}

//MARK: Cars
struct Cars {
    let cars: [Vehicle]
}

extension Cars: Convertible {
    typealias To = CarsClass
}

class CarsClass: NSObject {
    var cars: [VehicleClass] = []

    override var description: String {
        return "Cars: '\(cars)'"
    }
}

//MARK: Garage
struct Garage {
    let parkingSpots: [Int: Vehicle]
}

extension Garage: Convertible {
    typealias To = GarageClass
}

class GarageClass: NSObject {
    var parkingSpots = [Int: VehicleClass]()//[:]

    override var description: String {
        return "Parkingspots: '\(parkingSpots)'"
    }
}


let _sportCar = Vehicle(price: 227000, engine: Engine(cylinderCount: 8))
let sportCar: VehicleClass = _sportCar.asClass
let _familyCar = Vehicle(price: 160000, engine: Engine(cylinderCount: 6))
let familyCar: VehicleClass = _familyCar.asClass

print("\n\n\n\n\n\n\n\n@@@@@@@@")
//let _cars = Cars(cars: [_sportCar])
//let cars = _cars.asClass
//print("struct -> cars: \(cars)")

let _garage = Garage(parkingSpots: [0: _sportCar])//, 1: _familyCar])
let garage = _garage.asClass
print("struct -> garage: \(garage)")
