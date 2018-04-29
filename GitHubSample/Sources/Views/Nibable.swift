//
//  Nibable.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/24.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

protocol Nibable: NSObjectProtocol {
    static func makeFromNib() -> Self
    static var nib: UINib { get }
}

extension Nibable {
    static func makeFromNib() -> Self {
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }

    static var nib: UINib {
        return UINib(nibName: className, bundle: Bundle(for: self))
    }
}
