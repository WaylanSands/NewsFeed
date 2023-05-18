//
//  CategoriesViewModelTests.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import XCTest
@testable import NewsFeed

class CategoriesViewModelTests: XCTestCase {
    
    var delegate: MockCategoryViewModelDelegate!
    var networkService: MockNetworkService!
    var viewModel: CategoriesViewModel!
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        viewModel = CategoriesViewModel(networkService: networkService)
        viewModel.delegate = delegate
    }
    
    override func tearDownWithError() throws {
        networkService = nil
        viewModel = nil
        delegate = nil
    }
    
    func testCanFetchCategories() async throws {
        let dummyCategories = createDummyCategories(count: 7)
        let articles = createArticles(with: dummyCategories)

        mockNetworkServiceResult(.success(articles))

        // Fetch mocked articles.
        await viewModel.fetchArticles()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.categories, dummyCategories)
            XCTAssertTrue(self.delegate.didLoadCategoriesCalled)
        }
    }

    func testCategoriesAreUnique() async throws {
        let dummyCategories = [
            Category(name: "Business"),
            Category(name: "Investing"),
            Category(name: "Tech"),
            Category(name: "Business"),
            Category(name: "Travel"),
            Category(name: "Sport"),
        ]
        
        // Double up "Business" named category
        let articles = createArticles(with: dummyCategories)
        
        // Create unique array of Article.
        let uniqueCategories = Array(Set(dummyCategories))

        mockNetworkServiceResult(.success(articles))

        // Fetch mocked articles.
        await viewModel.fetchArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Verify that the categories are unique.
            XCTAssertEqual(self.viewModel.categories, uniqueCategories)
        }
    }
    
    func testArticlesAreWithinCategory() async throws {
        let dummyCategories = [
            Category(name: "Business"),
            Category(name: "Investing"),
            Category(name: "Tech"),
            Category(name: "Business"),
            Category(name: "Travel"),
            Category(name: "Sport"),
        ]
        
        let articles = createArticles(with: dummyCategories)
        
        // Mock the successful response
        networkService.mockResult = .success(articles)
        
        // Fetch mocked articles.
        await viewModel.fetchArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let selectedCategory = Category(name: "Business")
            
            // Retrieve articles within the selected category.
            let categorisedArticles = self.viewModel.articlesWithin(selectedCategory)
            let filteredArticles = articles.filter { $0.categories?.first ==  selectedCategory }
            
            XCTAssertEqual(categorisedArticles.count, filteredArticles.count)
        }
    }
    
    func testCanTriggerError() async throws {
        // Use delegate to present NewsFeedError.
        viewModel.delegate?.present(NewsFeedError.invalidURL)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.delegate.presentErrorCalled)
        }
    }
    
    
    // MARK: -  Helper functions
    
    func createDummyCategories(count: Int) -> [Category] {
        return (0..<count).map { _ in Category(name: "") }
    }

    func createArticles(with categories: [Category]) -> [Article] {
        return categories.map { Article(category: $0) }
    }
    
    func mockNetworkServiceResult(_ result: Result<[Article], Error>) {
        networkService.mockResult = result
    }
}
