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
import Action

final class SearchRepositoryViewModel {

    var repositories: Observable<[Repository]> {
        return loadAction.elements
            .filter { !$0.isEmpty }
    }

    var error: Observable<Error> {
        return loadAction.errors
            .flatMap { error -> Observable<Error> in
            switch error {
            case .underlyingError(let error):
                return .of(error)
            case .notEnabled:
                return .empty()
            }
        }
    }

    private let loadAction: Action<(String, Int), [Repository]>
    private let page = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()

    init(session: Session = .shared,
         searchText: ControlProperty<String>) {

        loadAction = Action {
            let request = GitHubAPI.SearchRepositories(query: $0, page: $1)
            return session.rx
                .response(request)
                .map { $0.items }
        }

        let query = searchText
            .debounce(0.3, scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)

        Observable.combineLatest(query, page)
            .bind(to: loadAction.inputs)
            .disposed(by: disposeBag)
    }
}
