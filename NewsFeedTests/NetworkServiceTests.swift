//
//  NetworkServiceTests.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import XCTest
@testable import NewsFeed

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    let apiURL = Constants.newsURL!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        networkService = NetworkService(session: urlSession)
    }
    
    /// Test a successful response of type [Article]
    func testGetArticles() async {
        // Create a mock article list response.
        let article1 = Article(category: Category(name: "1"))
        let article2 = Article(category: Category(name: "2"))
        let article3 = Article(category: Category(name: "3"))
        let stubbedArticles = [article1, article2, article3]
        let articleList = ArticleListResponse(assets: stubbedArticles)
        
        // Create a mock URLSession response with articleList.
        createMockResponseWith(articleList: articleList, with: apiURL)
        
        // Call the getArticleList method and await the result
        let result = await networkService.getArticleList()
        
        switch result {
        case .success(let resultArticles):
            // Assert that the article returned is the same as the dummyArticles.
            XCTAssertEqual(stubbedArticles, resultArticles)
        case .failure(let error):
            XCTFail("Unexpected failure: \(error)")
        }
    }
    
    /// Test that the getArticleList method will return an Result of type Error
    /// if the response has no articles.
    func testEmptyAssetsResponse() async {
        // Add empty asset array in response.
        let articleList = ArticleListResponse(assets: [])

        // Create a mock URLSession response with empty articles.
        createMockResponseWith(articleList: articleList, with: apiURL)

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

        // Create a mock URLSession response with an invalid data.
        createMockResponseWith(jsonDict: incorrectData, with: apiURL)

        // Call the getArticleList method and await the result.
        let result = await networkService.getArticleList()

        // Assert that the result is failure with assetError.
        switch result {
        case .success:
            XCTFail("Expected failure due to missing assets")

        case .failure(let error):
            XCTAssertEqual(error as? NewsFeedError, NewsFeedError.decodingError)
        }
    }
    
    func testInvalidURL() async {
        // Create a mock article list response.
        let article1 = Article(category: Category(name: "1"))
        let stubbedArticles = [article1]
        let articleList = ArticleListResponse(assets: stubbedArticles)
        
        let invalidURL = URL(string: "incorrect")!
        
        // Create a mock URLSession response with an invalid url.
        createMockResponseWith(articleList: articleList, with: invalidURL)

        // Call the getArticleList method and await the result.
        let result = await networkService.getArticleList()

        // Assert that the result is failure with assetError.
        switch result {
        case .success:
            XCTFail("Expected failure due to invalid URL")

        case .failure(let error):
            // Assert that the error returned contains the invalidURL error code.
            XCTAssertTrue(error.localizedDescription.contains(NewsFeedError.invalidURL.errorCode))
        }
    }
    
    private func createMockResponseWith(articleList: ArticleListResponse, with url: URL) {
        let data = try? JSONEncoder().encode(articleList)
        
        MockURLProtocol.requestHandler = { request in
            guard let requestURL = request.url, requestURL == url else {
              throw NewsFeedError.invalidURL
          }
          
          let response = HTTPURLResponse(url: requestURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
    }
    
    private func createMockResponseWith(jsonDict: [String: Any], with url: URL) {
        let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        MockURLProtocol.requestHandler = { request in
          guard let requestURL = request.url, requestURL == url else {
              throw NewsFeedError.invalidURL
          }
          
          let response = HTTPURLResponse(url: requestURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
    }
}







