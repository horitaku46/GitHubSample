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

final class SearchRepositoryViewModel {

    let repositories: Observable<[Repository]>

    private let _repositories = BehaviorRelay<[Repository]>(value: [])
    private let disposeBag = DisposeBag()

    init(searchText: ControlProperty<String>) {
        self.repositories = _repositories.asObservable()

        searchText
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
