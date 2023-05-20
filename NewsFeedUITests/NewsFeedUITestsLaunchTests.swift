//
//  NewsFeedUITestsLaunchTests.swift
//  NewsFeedUITests
//
//  Created by Waylan Sands on 17/5/2023.
//

import XCTest

class NewsFeedUITestsLaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Step 1: Assert starting view controller is CategoriesViewController
        let categoriesViewController = app.navigationBars["News Categories"].exists
        XCTAssertTrue(categoriesViewController, "Starting view controller is not CategoriesViewController")

        // Step 2: Assert cells exist.
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10.0), "First cell does not exist")

        // Step 3: Assert first cell is of type CategoryCollectionViewCell.
        XCTAssertEqual(firstCell.identifier, CategoryCollectionViewCell.identifier)

        // Step 4: Tap cell to visit article.
        firstCell.tap()

        // Step 5: Assert the next screen is ArticlesViewController.
        let articlesViewController = app.navigationBars["Articles"]
        XCTAssertTrue(articlesViewController.exists, "Next screen is not ArticlesViewController")

        // Step 6: Assert it shows a cell of type ArticleTableViewCell.
        let articleCells = app.cells.matching(identifier: ArticleTableViewCell.identifier)
        XCTAssertTrue(articleCells.count > 0, "No cells of type ArticleTableViewCell found")
        
        // Step 7: Find the cta button of the Article cell.
        let button = articleCells.buttons.element(matching: .button,
                                                  identifier: "Visit Article").firstMatch
        
        // Step 8: Assert the cta button exists.
        XCTAssertTrue(button.exists, "Did not find the ArticleTableViewCell cta button.")
        button.tap()
        
        // Step 9: Assert the next screen is WebViewController.
        let webViewController = app.navigationBars["Article"]
        XCTAssertTrue(webViewController.exists, "Next screen is not WebViewController")
        
        // Step 10: Navigate backwards
        webViewController.buttons["Articles"].tap()
        
        // Step 11: Assert that WebViewController is not in memory
        XCTAssertFalse(app.navigationBars["Article"].exists, "WebViewController is still in memory")
        
        // Step 12: Navigate backwards
        articlesViewController.buttons["News Categories"].tap()
        
        // Step 13: Assert that ArticlesViewController is not in memory
        XCTAssertFalse(app.navigationBars["Articles"].exists, "ArticlesViewController is still in memory")
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
