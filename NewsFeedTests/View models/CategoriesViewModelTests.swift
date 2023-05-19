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
    
    /// Test the CategoriesViewModel is capable of fetching articles
    /// and settings the categories property to the articles's categories.
    /// Also check that the CategoryViewModelDelegate was updated.
    func testCanFetchCategories() async throws {
        let dummyCategories = createDummyCategories(count: 7)
        let articles = createArticles(with: dummyCategories)

        mockNetworkServiceResult(.success(articles))

        // Fetch mocked articles.
        await viewModel.fetchArticles()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Verify the categories are the same.
            XCTAssertEqual(self.viewModel.categories, dummyCategories)
            
            // Verify the delegate method was called.
            XCTAssertTrue(self.delegate.didLoadCategoriesCalled)
        }
    }

    /// Test that the categories held by the CategoriesViewModel categories
    /// are unique and therefore contain no duplicates.
    func testCategoriesAreUnique() async throws {
        // Create an array with duplicate category name "Business"
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
    
    /// Test if the articles returned via the CategoriesViewModel are
    /// the same category as the selected category.
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
        
        // Mock the successful response.
        networkService.mockResult = .success(articles)
        
        // Fetch mocked articles.
        await viewModel.fetchArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let selectedCategory = Category(name: "Business")
            
            // Retrieve articles within the selected category.
            let categorisedArticles = self.viewModel.articlesWithin(selectedCategory)
            
            // Filter articles the array should contain a count of 2 as there are
            // two categories with the name "Business".
            let filteredArticles = articles.filter { $0.categories?.first ==  selectedCategory }
            
            XCTAssertEqual(categorisedArticles.count, filteredArticles.count)
        }
    }
    
    /// Test that the CategoryViewModelDelegate method is called
    /// when an error is passed via the CategoriesViewModel.
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
