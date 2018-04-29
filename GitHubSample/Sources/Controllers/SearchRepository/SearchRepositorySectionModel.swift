//
//  SearchRepositorySectionModel.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/29.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation
import RxDataSources

struct SearchRepositorySectionModel {
    var repositories: [Repository]
}

extension SearchRepositorySectionModel: AnimatableSectionModelType {
    typealias Item = Repository

    var identity: String {
        return "noSection"
    }

    var items: [Repository] {
        return repositories
    }

    init(original: SearchRepositorySectionModel, items: [Item]) {
        self = original
        self.repositories = items
    }
}
