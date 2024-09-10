//
//  UITableView+Registering.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(type, forCellReuseIdentifier: identifier ?? cellId)
    }

    func dequeueCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T? where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
