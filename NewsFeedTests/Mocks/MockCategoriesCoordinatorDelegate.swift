//
//  MockCategoriesCoordinatorDelegate.swift
//  NewsFeedUITests
//
//  Created by Waylan Sands on 26/5/2023.
//

import Foundation

class MockCategoriesCoordinatorDelegate: CategoriesCoordinatorDelegate {
    var articles: [Article] = []
    var didShowArticles = false
    
    func showArticles(_ articles: [Article]) {
        self.didShowArticles = true
        self.articles = articles
    }
}
