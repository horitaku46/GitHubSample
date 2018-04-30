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
        let query: String
        let page: Int

        typealias Response = SearchRepositoriesResponse

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/search/repositories"
        }

        var parameters: Any? {
            return ["q": query, "page": page]
        }
    }
}
