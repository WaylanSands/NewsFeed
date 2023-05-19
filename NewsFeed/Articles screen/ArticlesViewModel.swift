//
//  ArticlesViewModel.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

class ArticlesViewModel {
    /// Array of Article ordered by timestamp.
    let articles: [Article]
    
    /// Returns number of articles
    var numberOfRows: Int {
        articles.count
    }
    
    init(articles: [Article]) {
        // Sort the articles by timestamp.
        self.articles = articles.sorted()
    }
    
}
