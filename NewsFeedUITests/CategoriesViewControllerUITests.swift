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
        let stubbedCategories = [
            Category(name: "Category 1"),
            Category(name: "Category 2"),
            Category(name: "Category 3")
        ]
        
        // Create articles from the stubs.
        let articles = createArticles(with: stubbedCategories)
        
        let mockService = MockNetworkService()
        
        // Configure the networkService to return stubbed categories
        mockService.mockResult = .success(articles)
        
        let viewModel = CategoriesViewModel(networkService: mockService)
        
        let viewController = CategoriesViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        
        // Load the view
        viewController.loadViewIfNeeded()
        
        RunLoop.current.run(until: Date().addingTimeInterval(1))
        
        let cellCount = viewController.collectionView.numberOfItems(inSection: 0)
        
        // Assert that the collectionView has the expected number of items.
        XCTAssertEqual(cellCount, stubbedCategories.count)
        
        for (index, category) in viewModel.categories.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = viewController.collectionView(viewController.collectionView,
                                                     cellForItemAt: indexPath) as? CategoryCollectionViewCell
            
            self.verifyConfiguration(for: cell, with: category)
        }
    }
    
    func verifyConfiguration(for cell: CategoryCollectionViewCell?, with category: Category) {
        XCTAssertNotNil(cell, "Cell should not be nil")

        // Assert that the cell text is the same as the category name.
        XCTAssertEqual(cell?.titleLabel.text, category.name, "Incorrect title label")
        
        // Assert that the cell backgroundColor is the same as the category colour.
        XCTAssertEqual(cell?.cardView.backgroundColor, category.colour, "Incorrect cell colour")
        
        // Assert that the cell font is extraLargeFont.
        XCTAssertEqual(cell?.titleLabel.font, Constants.extraLargeFont, "Incorrect cell font")
    }
    
    // MARK: -  Helper functions

    func createArticles(with categories: [Category]) -> [Article] {
        return categories.map { Article(category: $0) }
    }
}
