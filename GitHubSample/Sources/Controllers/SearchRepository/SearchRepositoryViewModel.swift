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
    let isEmptyRepositories: Observable<Bool>
    let isEmptySearchResult: Observable<Bool>
    let lastPageFetchingRepositories: Observable<Void>
    let selectedRepository: Observable<Repository>

    private let _repositories = BehaviorRelay<[Repository]>(value: [])
    private let _error = PublishSubject<Error>()
    private let _isEmptyRepositories = PublishSubject<Bool>()
    private let _isEmptySearchResult = PublishSubject<Bool>()
    private let _lastPageFetchingRepositories = PublishSubject<Void>()

    private let isFetchingRepositories = BehaviorRelay<Bool>(value: true)
    private let page = BehaviorRelay<Int>(value: 1)
    private let lastPage = BehaviorRelay<Int>(value: 0)

    private let disposeBag = DisposeBag()

    init(session: Session = .shared,
         searchText: ControlProperty<String>,
         reachedBottom: Observable<Void>,
         selectedIndexPath: Observable<IndexPath>) {

        repositories = _repositories.asObservable()
        error = _error.asObservable()
        isEmptyRepositories = _isEmptyRepositories.asObservable()
        isEmptySearchResult = _isEmptySearchResult.asObservable()
        lastPageFetchingRepositories = _lastPageFetchingRepositories.asObservable()

        selectedRepository = selectedIndexPath
            .withLatestFrom(_repositories) { $1[$0.row] }

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
            .bind(to: _isEmptyRepositories)
            .disposed(by: disposeBag)

        searchTrigger
            .filter { !$0.isEmpty }
            .map { _ in false }
            .bind(to: _isEmptySearchResult)
            .disposed(by: disposeBag)

        let query = searchTrigger
            .filter { !$0.isEmpty }
            .share(replay: 1, scope: .whileConnected)

        query
            .map { _ in true }
            .bind(to: isFetchingRepositories)
            .disposed(by: disposeBag)

        let requestWillStart = PublishSubject<(query: String, page: Int)>()

        query
            .flatMap { [weak self] (query) -> Observable<(query: String, page: Int)> in
                guard let me = self else { return .empty() }
                me.page.accept(1)
                me.lastPage.accept(0)
                return .of((query, me.page.value))
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
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
            .flatMap { [weak self] (query) -> Observable<(query: String, page: Int)> in
                guard let me = self else { return .empty() }
                me.page.accept(me.page.value + 1)
                return .of((query, me.page.value))
            }
            .bind(to: requestWillStart)
            .disposed(by: disposeBag)

        let response = PublishSubject<(repositories: [Repository], isFirstAdd: Bool)>()

        requestWillStart
            .flatMapLatest { (query, page) -> Observable<(repositories: [Repository], isFirstAdd: Bool)> in
                let request = GitHubAPI.SearchRepositories(query: query, page: page)
                return session.rx
                    .response(request)
                    .catchError { [weak self] in
                        let response = Observable.just(SearchRepositoriesResponse(totalCount: 0, repositories: []))
                        guard let me = self else { return response }
                        me._error.onNext($0)
                        me._isEmptyRepositories.onNext(true)
                        return response
                    }
                    .flatMap { [weak self] response -> Observable<(repositories: [Repository], isFirstAdd: Bool)> in
                        guard let me = self else { return .just(([], false)) }
                        let isRemainder = response.totalCount % 30 != 0
                        let quotient = response.totalCount / 30
                        me.lastPage.accept(isRemainder ? quotient + 1 : quotient)
                        let isFirstAdd = page == 1
                        me._isEmptyRepositories.onNext(true)
                        me.isFetchingRepositories.accept(false)
                        return .of((response.repositories, isFirstAdd))
                }
            }
            .bind(to: response)
            .disposed(by: disposeBag)

        response
            .flatMap { [weak self] (repositories, isFirstAdd) -> Observable<[Repository]> in
                guard let me = self else { return .just([]) }
                return .of(isFirstAdd ? repositories : me._repositories.value + repositories)
            }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        response
            .withLatestFrom(query) { ($0, $1) }
            .filter { $0.0.0.isEmpty && !$0.1.isEmpty }
            .map { _ in }
            .subscribe(onNext: { [weak self] in
                guard let me = self else { return }
                me._isEmptySearchResult.onNext(true)
                me._repositories.accept([])
            })
            .disposed(by: disposeBag)

        response
            .map { _ in }
            .filter { [weak self] in
                guard let me = self else { return false }
                return me.page.value == me.lastPage.value
            }
            .bind(to: _lastPageFetchingRepositories)
            .disposed(by: disposeBag)
    }
}
