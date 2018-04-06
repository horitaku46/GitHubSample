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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.keyboardDismissMode = .onDrag
        }
    }

    private let keyboardObserver = KeyboardObserver()

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

        Session.send(GitHubAPI.SearchRepositories(query: "rxswift")) {
            switch $0 {
            case .success(let response):
                print(response.items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
