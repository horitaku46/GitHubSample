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

    let repositories: Observable<[Repository]>
    let error: Observable<Error>
    let firstFetchingRepositories: Observable<Bool>

    private let _repositories = BehaviorRelay<[Repository]>(value: [])
    private let _error = PublishSubject<Error>()
    private let _firstFetchingRepositories = PublishSubject<Bool>()
    private let isFetchingRepositories = BehaviorRelay<Bool>(value: true)
    private let page = BehaviorRelay<Int>(value: 1)
    private var lastPage = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()

    init(session: Session = .shared,
         searchText: ControlProperty<String>,
         reachedBottom: Observable<Void>) {

        self.repositories = _repositories.asObservable()
        self.error = _error.asObservable()
        self.firstFetchingRepositories = _firstFetchingRepositories.asObservable()

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

        searchTrigger
            .filter { [weak self] in
                guard let me = self else { return false }
                return me._repositories.value.isEmpty && !$0.isEmpty
            }
            .map { _ in false }
            .bind(to: _firstFetchingRepositories)
            .disposed(by: disposeBag)

        let query = searchTrigger
            .debounce(0.7, scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .share(replay: 1, scope: .whileConnected)

        /// (query: String, Int: page, Bool: isAdditions Repository)
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
            .flatMapLatest { (query, page, isAdditions) -> Observable<([Repository], Bool)> in
                let request = GitHubAPI.SearchRepositories(query: query, page: page)
                return session.rx
                    .response(request)
                    .catchError { [weak self] in
                        let response = Observable.just(SearchRepositoriesResponse(totalCount: 0, repositories: []))
                        guard let me = self else { return response }
                        me._error.onNext($0)
                        me._firstFetchingRepositories.onNext(true)
                        return response
                    }
                    .flatMap { [weak self] response -> Observable<([Repository], Bool)> in
                        guard let me = self else { return .just(([], false)) }
                        let isRemainder = response.totalCount % 30 != 0
                        let quotient = response.totalCount / 30
                        me.lastPage.accept(isRemainder ? quotient + 1 : quotient)
                        me._firstFetchingRepositories.onNext(true)
                        me.isFetchingRepositories.accept(false)
                        return .of((response.repositories, isAdditions))
                }
            }
            .flatMap { [weak self] (repositories, isAdditions) -> Observable<[Repository]> in
                guard let me = self else { return .just([]) }
                return .of(isAdditions ? me._repositories.value + repositories : repositories)
            }
            .bind(to: _repositories)
            .disposed(by: disposeBag)
    }
}
