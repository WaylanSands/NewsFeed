//
//  ArticleCoordinator.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

protocol ArticleCoordinatorDelegate {
    func presentWebView(with url: URL)
}
