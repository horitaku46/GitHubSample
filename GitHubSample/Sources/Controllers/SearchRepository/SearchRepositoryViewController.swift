//
//  SearchRepositoryViewController.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import APIKit

final class SearchRepositoryViewController: UIViewController {

    @IBOutlet weak var searchBar: SearchRepositoryBar!
    @IBOutlet weak var searchRepositoryLoadingView: SearchRepositoryLoadingView!
    @IBOutlet weak var tableView: UITableView!

    private let _selectedIndexPath = PublishSubject<IndexPath>()
    private let keyboardObserver = KeyboardObserver()
    private lazy var dataSource: SearchRepositoryViewDataSource = {
        .init(viewModel: viewModel,
              selectedIndexPath: _selectedIndexPath.asObserver())
    }()
    private lazy var viewModel: SearchRepositoryViewModel = {
        .init(searchText: searchBar.rx.text.orEmpty,
              reachedBottom: tableView.rx.reachedBottom,
              selectedIndexPath: _selectedIndexPath)
    }()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.configure(tableView: tableView)

        viewModel.firstFetchingRepositories
            .bind(to: firstFetchingRepositories)
            .disposed(by: disposeBag)

        keyboardObserver.willShow
            .bind(to: keyboardWillShow)
            .disposed(by: disposeBag)

        keyboardObserver.willHide
            .bind(to: keyboardWillHide)
            .disposed(by: disposeBag)

        searchBar.rx.cancelButtonClicked
            .bind(to: cancelButtonClicked)
            .disposed(by: disposeBag)

        viewModel.selectedRepository
            .bind(to: showWeb)
            .disposed(by: disposeBag)
    }

    private var keyboardWillShow: AnyObserver<KeyboardObserver.Info> {
        return Binder(self) { (me, info) in
            me.searchBar.setShowsCancelButton(true, animated: true)
        }.asObserver()
    }

    private var keyboardWillHide: AnyObserver<KeyboardObserver.Info> {
        return Binder(self) { (me, info) in
            me.searchBar.setShowsCancelButton(false, animated: true)
        }.asObserver()
    }

    private var cancelButtonClicked: AnyObserver<Void> {
        return Binder(self) { (me, _) in
            me.searchBar.resignFirstResponder()
        }.asObserver()
    }

    private var firstFetchingRepositories: AnyObserver<(Bool)> {
        return Binder(self) { (me, isHidden) in
            me.searchRepositoryLoadingView.isHidden = isHidden
        }.asObserver()
    }

    private var showWeb: AnyObserver<Repository> {
        return Binder(self) { (me, repository) in
            me.searchBar.resignFirstResponder()
            let webViewController = WebViewController.make(urlStr: repository.htmlUrlStr)
            me.show(webViewController, sender: nil)
        }.asObserver()
    }
}
