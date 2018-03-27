//
//  GitHubAPI.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation
import APIKit

final class GitHubAPI {
    private init() {}

    struct SearchRepositories: GitHubRequest {
        typealias Response = SearchRepositoriesResponse

        let method: HTTPMethod = .get
        let path: String = "/search/repositories"
        var parameters: Any? {
            return ["q": query, "page": 1]
        }

        let query: String
    }
}
