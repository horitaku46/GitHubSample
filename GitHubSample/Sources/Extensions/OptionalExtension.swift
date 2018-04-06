//
//  OptionalExtension.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/06.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}
