//
//  KeyboardObserver.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/06.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct KeyboardObserver {

    struct Info {
        let duration: TimeInterval
        let rect: CGRect

        init?(_ notification: Notification) {
            guard let info = notification.userInfo,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
                let rect = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return nil
            }
            self.duration = duration.doubleValue
            self.rect = rect.cgRectValue
        }
    }

    let willShow: Observable<Info>
    let didShow:  Observable<Info>
    let willHide: Observable<Info>
    let didHide:  Observable<Info>

    init(notification: NotificationCenter = .default) {

        willShow = notification.rx.notification(.UIKeyboardWillShow)
            .map { Info($0) }
            .filterNil()
            .asObservable()

        didShow = notification.rx.notification(.UIKeyboardDidShow)
            .map { Info($0) }
            .filterNil()
            .asObservable()

        willHide = notification.rx.notification(.UIKeyboardWillHide)
            .map { Info($0) }
            .filterNil()
            .asObservable()

        didHide = notification.rx.notification(.UIKeyboardDidHide)
            .map { Info($0) }
            .filterNil()
            .asObservable()
    }
}
