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
    private let isFetchingRepositories = BehaviorRelay<Bool>(value: false)
    private let page = BehaviorRelay<Int>(value: 1)
    private var lastPage = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()

    init(session: Session = .shared,
         searchText: ControlProperty<String>,
         reachedBottom: Observable<Void>) {

        let searchTrigger = searchText
            .distinctUntilChanged()
            .share()

        searchTrigger
            .filter { $0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                guard let me = self else { return }
                me.page.accept(1)
                me.lastPage.accept(0)
                me._repositories.accept([])
            })
            .disposed(by: disposeBag)

        let query = searchTrigger
            .debounce(0.3, scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .share(replay: 1, scope: .whileConnected)


        /// (query: String, Int: page, Bool: isAddtions)
        let requestWillStart = PublishSubject<(String, Int, Bool)>()

        query
            .flatMap { [weak self] (query) -> Observable<(String, Int, Bool)> in
                guard let me = self else { return .empty() }
                me.page.accept(1)
                me.lastPage.accept(0)
                return .of((query, me.page.value, false))
        }
        .bind(to: requestWillStart)
        .disposed(by: disposeBag)

        reachedBottom
            .filter { [weak self] in
                guard let me = self else { return false }
                let isFetching = me.isFetchingRepositories.value
                let isEmpty = me._repositories.value.isEmpty
                let isLast = me.page.value == me.lastPage.value
                return !isFetching && !isEmpty && !isLast
            }
            .withLatestFrom(query)
            .flatMap { [weak self] (query) -> Observable<(String, Int, Bool)> in
                guard let me = self else { return .empty() }
                me.page.accept(me.page.value + 1)
                return .of((query, me.page.value, true))
            }
            .bind(to: requestWillStart)
            .disposed(by: disposeBag)

        requestWillStart
            .map { _ in true }
            .bind(to: isFetchingRepositories)
            .disposed(by: disposeBag)

        requestWillStart
            .flatMapLatest { (query, page, isAddions) -> Observable<([Repository], Bool)> in
                let request = GitHubAPI.SearchRepositories(query: query, page: page)
                return session.rx
                    .response(request)
                    .catchError { [weak self] in
                        self?._error.onNext($0)
                        return .just(SearchRepositoriesResponse(totalCount: 0, repositories: []))
                    }
                    .flatMap { [weak self] response -> Observable<([Repository], Bool)> in
                        guard let me = self else { return .of(([], false)) }
                        let isRemainder = response.totalCount % 30 != 0
                        let quotient = response.totalCount / 30
                        me.lastPage.accept(isRemainder ? quotient + 1 : quotient)
                        me.isFetchingRepositories.accept(false)
                        return .of((response.repositories, isAddions))
                    }
            }
            .flatMap { [weak self] (repositories, isAddions) -> Observable<[Repository]> in
                guard let me = self else { return .empty() }
                return .of(isAddions ? me._repositories.value + repositories : repositories)
            }
            .bind(to: _repositories)
            .disposed(by: disposeBag)
    }
}
