//
//  SearchRepositoryCell.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/04/16.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit

final class SearchRepositoryCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.contentMode = .scaleAspectFill
        }
    }

    @IBOutlet weak var repositoryNameLabel: UILabel! {
        didSet {
            repositoryNameLabel.textColor = UIColor.GitHub.blueText
            repositoryNameLabel.font = .systemFont(ofSize: 20, weight: .heavy)
            repositoryNameLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var repositoryDescLabel: UILabel! {
        didSet {
            repositoryDescLabel.textColor = .darkText
            repositoryDescLabel.font = .systemFont(ofSize: 12)
            repositoryDescLabel.textAlignment = .left
            repositoryDescLabel.numberOfLines = 0
        }
    }

    @IBOutlet weak var repositoryLangLabel: UILabel! {
        didSet {
            repositoryLangLabel.textColor = .darkText
            repositoryLangLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        }
    }

    @IBOutlet weak var repositoryStarLabel: UILabel! {
        didSet {
            repositoryStarLabel.textColor = .darkText
            repositoryStarLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        }
    }
    @IBOutlet weak var repositoryForkLabel: UILabel! {
        didSet {
            repositoryForkLabel.textColor = .darkText
            repositoryForkLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        }
    }
}
