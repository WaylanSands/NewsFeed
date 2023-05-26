//
//  ArticlesViewModelTest.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import Foundation

import XCTest
@testable import NewsFeed

class ArticlesViewModelTest: XCTestCase {
    var viewModel: ArticlesViewModel!
    
    override func setUp() {
        super.setUp()
        let stubbedCategories = createStubbedCategories(count: 7)
        let articles = createArticles(with: stubbedCategories)
        
        viewModel = ArticlesViewModel(articles: articles)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    /// Test numberOfRows is equal to viewModel.articles.count
    /// Open to changes down the line.
    func testNumberOfRows() {
        let expectedRowCount = viewModel.articles.count
        XCTAssertEqual(viewModel.numberOfRows, expectedRowCount, "Incorrect number of rows")
    }
    
    /// Test that the articles contained by ArticlesViewModel are
    /// ordered by their timestamp.
    func testArticleOrderingByTimestamp() {
        let categories = [
            Category(name: "Business"),
            Category(name: "Investing"),
            Category(name: "Travel"),
            Category(name: "Sport"),
            Category(name: "Tech"),
        ]
    
        // Create articles and provide random timestamps.
        let articles: [Article] = categories.map { category in
            let timestamp = Int.random(in: 0...100000000)
            return Article(category: category, timeStamp: timestamp)
        }
        
        let viewModel = ArticlesViewModel(articles: articles)
        
        // Sort articles by timestamp.
        let sortedArticles = viewModel.articles.sorted { article1, article2 in
            XCTAssertNotNil(article1.timeStamp, "Nil timeStamp found in articles")
            XCTAssertNotNil(article2.timeStamp, "Nil timeStamp found in articles")
            
            return article1.timeStamp! > article2.timeStamp!
        }

        // Assert that sortedArticles are the same as the viewModel.articles.
        XCTAssertEqual(sortedArticles, viewModel.articles, "Articles not ordered by timestamp")
    }
    
    // MARK: - Helper functions
    
    func createStubbedCategories(count: Int) -> [Category] {
        return (0..<count).map { _ in Category(name: "") }
    }
    
    func createArticles(with categories: [Category]) -> [Article] {
        return categories.map { Article(category: $0) }
    }
}
