//
//  SessionExtension.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

extension Session: ReactiveCompatible {}

extension Reactive where Base: Session {
    func response<T: Request>(_ request: T) -> Observable<T.Response> {
        return Observable.create { [weak base] observer in
            let task = base?.send(request) { result in
                switch result {
                case .success(let response):
                    observer.on(.next(response))
                    observer.on(.completed)
                case .failure(let error):
                    observer.on(.error(error))
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
