//
//  SearchRepositoryViewController.swift
//  GitHubSample
//
//  Created by Takuma Horiuchi on 2018/03/27.
//  Copyright © 2018年 Takuma Horiuchi. All rights reserved.
//

import UIKit
import APIKit

final class SearchRepositoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Session.send(GitHubAPI.SearchRepositories(query: "rxswift")) {
            switch $0 {
            case .success(let response):
                print(response.items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
