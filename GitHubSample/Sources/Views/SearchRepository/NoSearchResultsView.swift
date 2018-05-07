//
//  NoSearchResultsView.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/05/07.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

final class NoSearchResultsView: UIView {

    @IBOutlet private weak var noSearchResultslabel: UILabel! {
        didSet {
            noSearchResultslabel.text = "No search results"
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
