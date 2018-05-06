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

    private enum Const {
        static let estimatedRowHeight: CGFloat = 100
        static let contentInsetBottom: CGFloat = 150
    }

    let selectedIndexPath: AnyObserver<IndexPath>

    private let viewModel: SearchRepositoryViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SearchRepositoryViewModel,
         selectedIndexPath: AnyObserver<IndexPath>) {
        self.viewModel = viewModel
        self.selectedIndexPath = selectedIndexPath
    }

    func configure(tableView: UITableView) {
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = Const.estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset.bottom = Const.contentInsetBottom
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

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                tableView.deselectRow(at: $0, animated: true)
                self?.selectedIndexPath.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
