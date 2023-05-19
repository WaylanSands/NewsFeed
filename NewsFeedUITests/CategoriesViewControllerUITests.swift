//
//  CategoriesViewControllerUITests.swift
//  NewsFeedUITests
//
//  Created by Waylan Sands on 18/5/2023.
//

import Foundation

import XCTest

class CategoriesViewControllerUITests: XCTestCase {
    
    /// Test that collection view on CategoriesViewController
    /// contains the same categories returned via the CategoriesViewModel.
    func testCategoriesAreAdded() throws {
        let dummyCategories = [
            Category(name: "Category 1"),
            Category(name: "Category 2"),
            Category(name: "Category 3")
        ]
        
        // Create articles from the stubs.
        let articles = createArticles(with: dummyCategories)
        
        let mockService = MockNetworkService()
        
        // Configure the networkService to return stubbed categories
        mockService.mockResult = .success(articles)
        
        let viewModel = CategoriesViewModel(networkService: mockService)
        
        let viewController = CategoriesViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        
        // Load the view
        viewController.loadViewIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Assert that the collectionView has the expected number of items
            let cellCount = viewController.collectionView.numberOfItems(inSection: 0)
            XCTAssertEqual(cellCount, dummyCategories.count)
            
            // Assert that the category names are correctly displayed in the cells
            for (index, category) in viewModel.categories.enumerated() {
                let indexPath = IndexPath(item: index, section: 0)
                let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: indexPath) as? CategoryCollectionViewCell
                
                XCTAssertNotNil(cell, "Cell should not be nil")
                
                // Verify that the cell text is the same as the category name of the same index.
                XCTAssertEqual(cell?.titleLabel.text, category.name)
            }
        }
    }
    
    // MARK: -  Helper functions

    func createArticles(with categories: [Category]) -> [Article] {
        return categories.map { Article(category: $0) }
    }
}
