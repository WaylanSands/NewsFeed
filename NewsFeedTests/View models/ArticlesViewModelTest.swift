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
        
        let dummyCategories = createDummyCategories(count: 7)
        let articles = createArticles(with: dummyCategories)
        
        viewModel = ArticlesViewModel(articles: articles)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testNumberOfRows() {
        // Test numberOfRows is equal to viewModel.articles.count
        // Open to changes down the line
        let expectedRowCount = viewModel.articles.count
        XCTAssertEqual(viewModel.numberOfRows, expectedRowCount)
    }
    
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
            
            return article1.timeStamp! < article2.timeStamp!
        }
        
        // Get sorted timestamps arrays for comparison.
        let sortedDates = sortedArticles.compactMap { $0.timeStamp }
        let vmSortedDates = viewModel.articles.compactMap { $0.timeStamp }

            
        XCTAssertEqual(sortedDates, vmSortedDates)
    }
    
    // MARK: - Helper functions
    
    func createDummyCategories(count: Int) -> [Category] {
        return (0..<count).map { _ in Category(name: "") }
    }
    
    func createArticles(with categories: [Category]) -> [Article] {
        return categories.map { Article(category: $0) }
    }
}
