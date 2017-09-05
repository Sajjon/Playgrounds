//: Playground - noun: a place where people can play

import UIKit

protocol ForwardingTableViewDataSource {
    func forwardTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func forwardTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

protocol TableSource: ForwardingTableViewDataSource {
    var models: [Any] { get }
}

extension TableSource {
    func forwardTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func forwardTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError() // TODO implementation here... using some data provided by this protocol.
    }
}

final class StaticTableSource: NSObject, TableSource {
    var models: [Any] = []
}

protocol AutoForwardTableViewDataSource {}
extension StaticTableSource: AutoForwardTableViewDataSource {}

// Then using sourcery, we will automatically generate this extension for every type conforming to `AutoForwardTableViewDataSource`:
extension StaticTableSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forwardTableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return forwardTableView(tableView, cellForRowAt: indexPath)
    }
}