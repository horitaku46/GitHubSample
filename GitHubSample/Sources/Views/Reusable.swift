//
//  Reusable.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/24.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
