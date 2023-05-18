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
        // Sort the articles by timestamp. Articles with a timestamp of nil
        // will be placed at the end of the array.
        self.articles = articles.sorted { article1, article2 in
            let timeStamp1 = article1.timeStamp ?? Int.max
            let timeStamp2 = article2.timeStamp ?? Int.max
            return timeStamp1 < timeStamp2
        }
    }
    
}
