//
//  WebViewController.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/05/06.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, Storyboardable {

    private enum Const {
        static let progressViewScaleY: CGFloat = isPhoneX ? 16.5 : 7.5
        static let progressViewTopConstant: CGFloat = isPhoneX ? 20.8 : 8.8
    }

    class func make(urlStr: String) -> WebViewController {
        let viewController = WebViewController.makeFromStoryboard()
        viewController.urlStr = urlStr
        return viewController
    }

    private var urlStr: String!
    private var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.ignoresViewportScaleLimits = true
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.transform = CGAffineTransform(scaleX: 1, y: Const.progressViewScaleY)
        progressView.progress = 0.5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        webView.addSubview(progressView)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                progressView.topAnchor.constraint(equalTo: webView.topAnchor, constant: Const.progressViewTopConstant),
                progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
                progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                progressView.topAnchor.constraint(equalTo: webView.topAnchor, constant: Const.progressViewTopConstant),
                progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
                progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
                ])
        }
        webView.load(URLRequest(url: URL(string: urlStr)!))
    }
}
