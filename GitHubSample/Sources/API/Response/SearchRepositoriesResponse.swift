//
//  SearchRepositoriesResponse.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation

struct SearchRepositoriesResponse: Decodable {
    let items: [Repository]
}
