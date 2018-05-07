//
//  AppDelegate.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

let isPhoneX: Bool = {
    guard #available(iOS 11.0, *),
        UIDevice().userInterfaceIdiom == .phone else {
            return false
    }
    let nativeSize = UIScreen.main.nativeBounds.size
    let (w, h) = (nativeSize.width, nativeSize.height)
    let (d1, d2): (CGFloat, CGFloat) = (1125.0, 2436.0)
    return (w == d1 && h == d2) || (w == d2 && h == d1)
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
