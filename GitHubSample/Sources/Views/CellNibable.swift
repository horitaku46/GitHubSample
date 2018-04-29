//
//  CellNibable.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/24.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

protocol CellNibable: Nibable, Reusable {}

extension CellNibable {}

extension UITableViewCell: CellNibable {}
