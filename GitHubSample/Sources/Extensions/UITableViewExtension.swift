//
//  UITableViewExtension.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/24.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<T: CellNibable>(_ cell: T.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<T: CellNibable>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! T
    }
}
