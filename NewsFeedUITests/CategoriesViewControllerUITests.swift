//
//  CategoriesViewControllerUITests.swift
//  NewsFeedUITests
//
//  Created by Waylan Sands on 18/5/2023.
//

import Foundation

import XCTest

class CategoriesViewControllerUITests: XCTestCase {
    var mockDelegate: MockCategoriesCoordinatorDelegate!
    var viewController: CategoriesViewController!
    var viewModel: CategoriesViewModel!
    
    override func setUp() {
        super.setUp()
        
        let stubbedCategories = [
            Category(name: "Category 1"),
            Category(name: "Category 2"),
            Category(name: "Category 3")
        ]
        
        let articles = createArticles(with: stubbedCategories)
        
        let mockService = MockNetworkService()
        mockService.mockResult = .success(articles)
        
        viewModel = CategoriesViewModel(networkService: mockService)
        
        viewController = CategoriesViewController(viewModel: viewModel)
        mockDelegate = MockCategoriesCoordinatorDelegate()
        viewController.coordinatorDelegate = mockDelegate
        viewModel.delegate = viewController
        
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockDelegate = nil
        
        super.tearDown()
    }
    
    /// Test that collection view on CategoriesViewController
    /// contains the same categories returned via the CategoriesViewModel.
    func testCategoriesAreAdded() {
        let cellCount = viewController.collectionView.numberOfItems(inSection: 0)
        
        // Assert that the collectionView has the expected number of items.
        XCTAssertEqual(cellCount, viewModel.categories.count)
        
        for (index, category) in viewModel.categories.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = viewController.collectionView(viewController.collectionView,
                                                     cellForItemAt: indexPath) as? CategoryCollectionViewCell
                        
            self.verifyConfiguration(for: cell, with: category)
            
            // Tap on "Category 3" cell.
            if let categoryName = cell?.titleLabel.text, categoryName == "Category 3" {
                viewController.collectionView.delegate?.collectionView?(viewController.collectionView, didSelectItemAt: indexPath)
            }
            
            // Check articles passed to coordinator delegate all contain the selected category.
            let articlesContainSelectedCategory = mockDelegate.articles.allSatisfy {
                $0.categories?.contains(where: { $0.name == "Category 3" }) ?? false
            }
            
            XCTAssertTrue(mockDelegate.didShowArticles, "Category selection delegate method not called")
            XCTAssertTrue(articlesContainSelectedCategory, "Incorrect articles passed to coordinator delegate")
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
