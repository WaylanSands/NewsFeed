//
//  MockNetworkService.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import Foundation

class MockNetworkService: ArticleService {
    var mockResult: Result<[Article], Error>?
    
    func getArticleList() async -> Result<[Article], Error> {
        if let mockResult = mockResult {
            return mockResult
        } else {
            fatalError("Mock result not set for NetworkService")
        }
    }
}
