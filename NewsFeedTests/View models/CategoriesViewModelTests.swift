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
        delegate = MockCategoryViewModelDelegate()
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
    func testCanFetchCategories() async {
        let stubbedCategories = createStubbedCategories(count: 7).sorted()
        let articles = createArticles(with: stubbedCategories)

        mockNetworkServiceResult(.success(articles))
        
        await viewModel.fetchArticles()

        // Sort array via name to match the stubbedCategories
        viewModel.categories.sort()

        // Assert the categories are the same.
        XCTAssertEqual(viewModel.categories, stubbedCategories, "Did not return correct categories")

        // Assert the delegate method was called.
        XCTAssertTrue(delegate.didLoadCategoriesCalled, "didLoadCategoriesCalled not called")
    }

    /// Test that the categories held by the CategoriesViewModel categories
    /// are unique and therefore contain no duplicates.
    func testCategoriesAreUnique() async {
        // Create an array with duplicate category name "Business"
        let stubbedCategories = [
            Category(name: "Business"),
            Category(name: "Investing"),
            Category(name: "Tech"),
            Category(name: "Business"),
            Category(name: "Travel"),
            Category(name: "Sport"),
        ]
        
        // Double up "Business" named category
        let articles = createArticles(with: stubbedCategories)
        
        // Create unique array of Article ordered by name.
        let uniqueCategories = Array(Set(stubbedCategories)).sorted()

        mockNetworkServiceResult(.success(articles))

        // Fetch mocked articles.
        await viewModel.fetchArticles()
        
        // Sort array to match the uniqueCategories order.
        viewModel.categories.sort()
        
        // Assert that the categories are unique.
        XCTAssertEqual(self.viewModel.categories, uniqueCategories, "Categories returned are not unique")
    }
    
    /// Test if the articles returned via the CategoriesViewModel are
    /// the same category as the selected category.
    func testArticlesAreWithinCategory() async {
        // Create categories with two with name "Business"
        let stubbedCategories = [
            Category(name: "Business"),
            Category(name: "Investing"),
            Category(name: "Tech"),
            Category(name: "Business"),
            Category(name: "Travel"),
            Category(name: "Sport"),
        ]
        
        let articles = createArticles(with: stubbedCategories)
        
        // Mock the successful response.
        networkService.mockResult = .success(articles)
        
        // Fetch mocked articles.
        await viewModel.fetchArticles()
        
        let selectedCategory = Category(name: "Business")
        
        // Retrieve articles within the selected category.
        let categorisedArticles = self.viewModel.articlesWithin(selectedCategory)
        
        // Filter articles the array should contain a count of 2 as there are
        // two categories with the name "Business".
        let filteredArticles = articles.filter { $0.categories?.first == selectedCategory }
        
        // Assert that the count of articles returned from articlesWithin
        // is the same as the local filteredArticles count.
        XCTAssertEqual(categorisedArticles.count, filteredArticles.count, "Categories were not successfully filtered")
    }
    
    /// Test that the CategoryViewModelDelegate method is called
    /// when an error is passed via the CategoriesViewModel.
    func testCanTriggerError() async {
        // Use delegate to present NewsFeedError.
        viewModel.delegate?.present(NewsFeedError.invalidURL)
        
        // Assert the delegate method was called
        XCTAssertTrue(self.delegate.presentErrorCalled, "presentErrorCalled method not called")
    }
    
    // MARK: -  Helper functions
    
    func createStubbedCategories(count: Int) -> [Category] {
        return (0..<count).map { index in Category(name: "\(index)") }
    }

    func createArticles(with categories: [Category]) -> [Article] {
        return categories.map { Article(category: $0) }
    }
    
    func mockNetworkServiceResult(_ result: Result<[Article], Error>) {
        networkService.mockResult = result
    }
}
