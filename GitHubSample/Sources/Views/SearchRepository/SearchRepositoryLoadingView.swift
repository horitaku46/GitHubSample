//
//  SearchRepositoryLoadingView.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/05/06.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

final class SearchRepositoryLoadingView: UIView {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.startAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        isHidden = true
    }
}
