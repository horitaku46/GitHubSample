//
//  Repository.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let avatarUrlStr: String
    let fullName: String
    let description: String
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let htmlUrlStr: String

    private enum CodingKeys: String, CodingKey {
        case avatarUrlStr    = "avatar_url"
        case fullName        = "full_name"
        case description
        case language
        case stargazersCount = "stargazers_count"
        case forksCount      = "forks_count"
        case htmlUrlStr      = "html_url"
    }
}
