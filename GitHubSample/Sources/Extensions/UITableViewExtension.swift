//
//  UITableViewExtension.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/24.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit
import RxSwift

extension UITableView {
    func registerCell<T: CellNibable>(_ cell: T.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<T: CellNibable>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! T
    }
}

extension Reactive where Base: UITableView {
    var reachedBottom: Observable<Void> {
        return contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Bool> in
                guard let scrollView = base else { return .empty() }
                let insetTop = scrollView.contentInset.top
                let insetBottom = scrollView.contentInset.bottom
                let visibleHeight = scrollView.frame.height - insetTop - insetBottom
                let y = contentOffset.y + insetTop
                let threshold = max(0, scrollView.contentSize.height - visibleHeight)
                return .just(y > threshold)
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
    }
}
