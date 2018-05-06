//
//  SearchRepositoryLoadingView.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/05/06.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

final class SearchRepositoryLoadingView: UIView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.startAnimating()
        }
    }
}
