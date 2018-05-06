//
//  WebViewController.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/05/06.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

final class WebViewController: UIViewController, Storyboardable {

    class func make(urlStr: String) -> WebViewController {
        let viewController = WebViewController.makeFromStoryboard()
        viewController.urlStr = urlStr
        return viewController
    }

    private var urlStr: String!
}
