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
    @IBOutlet weak var tableView: UITableView!

    private lazy var dataSource: SearchRepositoryViewDataSource = {
        .init(viewModel: viewModel)
    }()
    private lazy var viewModel: SearchRepositoryViewModel = {
        .init(searchText: searchBar.rx.text.orEmpty)
    }()
    private let keyboardObserver = KeyboardObserver()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.configure(tableView: tableView)

        keyboardObserver.willShow
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.setShowsCancelButton(true, animated: true)
            })
            .disposed(by: disposeBag)

        keyboardObserver.willHide
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.setShowsCancelButton(false, animated: true)
            })
            .disposed(by: disposeBag)

        searchBar.rx.cancelButtonClicked
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}
