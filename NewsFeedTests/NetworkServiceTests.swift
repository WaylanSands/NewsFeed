//
//  NetworkServiceTests.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import XCTest
@testable import NewsFeed

class NetworkServiceTests: XCTestCase {
    
    func testGetArticles() async throws {
        // Create a mock article list response.
        let article1 = Article(category: Category(name: "1"))
        let article2 = Article(category: Category(name: "2"))
        let article3 = Article(category: Category(name: "3"))
        let mockResponse = ArticleListResponse(assets: [article1, article2, article3])
        
        // Create a mock URLSession and set the expected response.
        let mockSession = sessionMockWith(response: mockResponse)
        
        // Create an instance of NetworkService with the mock session.
        let networkService = NetworkService(session: mockSession)
        
        // Call the getArticleList method and await the result
        let result = await networkService.getArticleList()
        
        switch result {
        case .success(let articles):
            // Assert that the article list is as expected
            XCTAssertEqual(articles.count, 3)
            XCTAssertEqual(articles[0].categories?.first?.name, "1")
            XCTAssertEqual(articles[1].categories?.first?.name, "2")
            XCTAssertEqual(articles[2].categories?.first?.name, "3")
            
        case .failure(let error):
            XCTFail("Unexpected failure: \(error)")
        }
    }
    
    func testEmptyAssetsResponse() async throws {
        // Add empty asset array in response.
        let mockResponse = ArticleListResponse(assets: [])
        
        // Create a mock URLSession and set the expected response.
        let mockSession = sessionMockWith(response: mockResponse)
        
        // Create an instance of NetworkService with the mock session.
        let networkService = NetworkService(session: mockSession)
        
        // Call the getArticleList method and await the result.
        let result = await networkService.getArticleList()
        
        // Assert that the result is failure with assetError.
        switch result {
        case .success:
            XCTFail("Expected failure due missing assets")
            
        case .failure(let error):
            XCTAssertEqual(error as? NewsFeedError, NewsFeedError.assetError)
        }
    }
    
    private func sessionMockWith(response: ArticleListResponse) -> URLSessionMock {
        let data = try? JSONEncoder().encode(response)
        let response = HTTPURLResponse(url: Constants.newsURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        return URLSessionMock(data: data, response: response)
    }
}







