//
//  SearchRepositoryViewDataSource.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/24.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit
import RxSwift
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

final class SearchRepositoryViewDataSource: NSObject {

    private let viewModel: SearchRepositoryViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SearchRepositoryViewModel) {
        self.viewModel = viewModel
    }

    func configure(tableView: UITableView) {
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerCell(SearchRepositoryCell.self)

        let dataSource = RxTableViewSectionedAnimatedDataSource<SearchRepositorySectionModel>(
            configureCell: { _, tableView, indexPath, reposiory in
                let cell = tableView.dequeueReusableCell(SearchRepositoryCell.self, for: indexPath)
                cell.configure(repository: reposiory)
                return cell
            }
        )

        viewModel.repositories
            .flatMap { repositories -> Observable<[SearchRepositorySectionModel]> in
                return .of([SearchRepositorySectionModel(repositories: repositories)])
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
