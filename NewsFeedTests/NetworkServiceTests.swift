//
//  NetworkServiceTests.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import XCTest
@testable import NewsFeed

class NetworkServiceTests: XCTestCase {
    
    /// Test a successful response of type [Article]
    func testGetArticles() async {
        // Create a mock article list response.
        let article1 = Article(category: Category(name: "1"))
        let article2 = Article(category: Category(name: "2"))
        let article3 = Article(category: Category(name: "3"))
        let dummyArticles = [article1, article2, article3]
        let mockResponse = ArticleListResponse(assets: dummyArticles)
        
        // Create a mock URLSession and set the expected response.
        let mockSession = sessionMockWith(response: mockResponse)
        
        // Create an instance of NetworkService with the mock session.
        let networkService = NetworkService(session: mockSession)
        
        // Call the getArticleList method and await the result
        let result = await networkService.getArticleList()
        
        switch result {
        case .success(let resultArticles):
            // Assert that the article returned is the same as the dummyArticles.
            XCTAssertEqual(dummyArticles, resultArticles)
        case .failure(let error):
            XCTFail("Unexpected failure: \(error)")
        }
    }
    
    /// Test that the getArticleList method will return an Result of type Error
    /// if the response has no articles.
    func testEmptyAssetsResponse() async {
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
            XCTAssertEqual(error as? NewsFeedError, NewsFeedError.missingAssets)
        }
    }
    
    /// Test that when decoding fails the appropriate error is returned.
    func testDecodingFailure() async {
        // Create an incorrect ArticleResponse json format.
        let incorrectData = ["Channel" : 9]
        
        // Create a mock URLSession and set the expected response.
        let mockSession = sessionMockWith(jsonDict: incorrectData)
        
        // Create an instance of NetworkService with the mock session.
        let networkService = NetworkService(session: mockSession)
        
        // Call the getArticleList method and await the result.
        let result = await networkService.getArticleList()
        
        // Assert that the result is failure with assetError.
        switch result {
        case .success:
            XCTFail("Expected failure due missing assets")
            
        case .failure(let error):
            XCTAssertEqual(error as? NewsFeedError, NewsFeedError.decodingError)
        }
    }
    
    private func sessionMockWith(response: ArticleListResponse) -> URLSessionMock {
        let data = try? JSONEncoder().encode(response)
        let response = HTTPURLResponse(url: Constants.newsURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        return URLSessionMock(data: data, response: response)
    }
    
    private func sessionMockWith(jsonDict: [String: Any]) -> URLSessionMock {
        let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        let response = HTTPURLResponse(url: Constants.newsURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        return URLSessionMock(data: data, response: response)
    }
}







