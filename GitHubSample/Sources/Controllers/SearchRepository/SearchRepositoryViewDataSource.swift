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

final class SearchRepositoryViewDataSource: NSObject {

    private let viewModel: SearchRepositoryViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SearchRepositoryViewModel) {
        self.viewModel = viewModel
    }

    func configure(tableView: UITableView) {
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerCell(SearchRepositoryCell.self)

        let dataSource = RxTableViewSectionedAnimatedDataSource<SearchRepositorySectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(SearchRepositoryCell.self, for: indexPath)
                return cell
            }
        )

        let sections = [SearchRepositorySectionModel(repositories:
            [Repository(id: 0, avatarUrlStr: "", fullName: "A", description: "a", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 1, avatarUrlStr: "", fullName: "B", description: "b", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 2, avatarUrlStr: "", fullName: "C", description: "c", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 3, avatarUrlStr: "", fullName: "D", description: "d", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 4, avatarUrlStr: "", fullName: "E", description: "e", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 5, avatarUrlStr: "", fullName: "F", description: "f", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 6, avatarUrlStr: "", fullName: "G", description: "g", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 7, avatarUrlStr: "", fullName: "H", description: "h", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: ""),
             Repository(id: 8, avatarUrlStr: "", fullName: "I", description: "i", language: "swift", stargazersCount: 0, forksCount: 0, htmlUrlStr: "")])]

        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

//        tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
    }
}
