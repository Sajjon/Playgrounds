//: Playground - noun: a place where people can play

import UIKit

typealias Sorting = (Int, Int) -> Bool
typealias Filter = (Int) throws -> Bool
struct Query {
    var filter: Filter?
    var sorting: Sorting?
    init(_ filter: Filter? = nil, _ sorting: Sorting? = nil) {
        self.filter = filter
        self.sorting = sorting
    }
}

extension Array where Element == Int {
    func strings() -> [String] {
        return self.map { "\($0)" }
    }
}

func testQuery(_ query: Query) -> [String] {
    var queried: [Int] {
        let list = [1, 9, 5, 2, 3, 0, 4, 7, 6, 8]
        var end: [Int]
        guard
            let filter = query.filter,
            end = try! list.filter(filter),
            let sorting = query.sorting
        else { return end }
        end = end.sorted(by: sorting)
        return end
    }
    return queried.strings()
}

//func testQuery(_ query: Query) -> [String] {
//    var queried: [Int] {
//        var list = [1, 9, 5, 2, 3, 0, 4, 7, 6, 8]
//        guard let filter = query.filter else { return list }
//        list = try! list.filter(filter)
//        guard let sorting = query.sorting else { return list }
//        list = list.sorted(by: sorting)
//        return list
//    }
//    return queried.strings()
//}

let f: Filter = { $0 > 5 }
let s: Sorting = { $0 > $1 }

print(testQuery(Query()))
print(testQuery(Query(f)))
print(testQuery(Query(f, s)))
