//
//  SearchRepositoryViewModel.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/28.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit

final class SearchRepositoryViewModel {

    var repositories: Observable<[Repository]> {
        return _repositories.asObservable()
    }

    var error: Observable<Error> {
        return _error.asObservable()
    }

    private let _repositories = BehaviorRelay<[Repository]>(value: [])
    private let _error = PublishSubject<Error>()
    private let page = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()

    init(session: Session = .shared,
         searchText: ControlProperty<String>) {

        let searchTrigger = searchText
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .share()

        searchTrigger
            .filter { $0.isEmpty }
            .map { _ in [] }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        let query = searchTrigger
            .filter { !$0.isEmpty }

        Observable.combineLatest(query, page)
            .flatMapLatest { (query, page) -> Observable<[Repository]> in
                let request = GitHubAPI.SearchRepositories(query: query, page: page)
                return session.rx
                    .response(request)
                    .map { $0.items }
                    .catchErrorJustReturn([])
                    .do(onError: { [weak self] in
                        self?._error.onNext($0)
                    })
            }
            .bind(to: _repositories)
            .disposed(by: disposeBag)
    }
}
