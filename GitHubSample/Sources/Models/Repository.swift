//
//  Repository.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let fullName: String
    let language: String?
    let url: String

    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case language
        case url
    }
}
