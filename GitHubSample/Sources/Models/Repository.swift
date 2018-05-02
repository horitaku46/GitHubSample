//
//  Repository.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation
import RxDataSources

struct Repository {
    let id: Int
    let avatarUrlStr: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let htmlUrlStr: String
}

extension Repository: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case owner
        case fullName        = "full_name"
        case description
        case language
        case stargazersCount = "stargazers_count"
        case forksCount      = "forks_count"
        case htmlUrlStr      = "html_url"
    }

    private enum OwnerKeys: String, CodingKey {
        case avatarUrlStr = "avatar_url"
    }

    init(from decoder: Decoder) throws {
        let values      = try decoder.container(keyedBy: CodingKeys.self)
        id              = try values.decode(Int.self, forKey: .id)
        fullName        = try values.decode(String.self, forKey: .fullName)
        description     = try? values.decode(String.self, forKey: .description)
        language        = try? values.decode(String.self, forKey: .language)
        stargazersCount = try values.decode(Int.self, forKey: .stargazersCount)
        forksCount      = try values.decode(Int.self, forKey: .forksCount)
        htmlUrlStr      = try values.decode(String.self, forKey: .htmlUrlStr)

        let owner    = try values.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        avatarUrlStr = try owner.decode(String.self, forKey: .avatarUrlStr)
    }
}

extension Repository: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        return id
    }
}

extension Repository: Equatable {
    static func ==(lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}
