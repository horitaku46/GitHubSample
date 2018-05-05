//
//  ObservableExtension.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/06.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
}
