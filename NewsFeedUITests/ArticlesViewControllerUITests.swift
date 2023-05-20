//
//  ArticlesViewControllerUITests.swift
//  NewsFeedUITests
//
//  Created by Waylan Sands on 20/5/2023.
//

import Foundation
import XCTest

class ArticlesViewControllerUITests: XCTestCase {
    
    /// Test that collection view on CategoriesViewController
    /// contains the same categories returned via the CategoriesViewModel.
    func testCategoriesAreAdded()  {
        let articles = createArticles()
        let viewModel = ArticlesViewModel(articles: articles)
        let viewController = ArticlesViewController(viewModel: viewModel)
        
        // Load the view
        viewController.loadViewIfNeeded()
        
        RunLoop.current.run(until: Date().addingTimeInterval(1))

        let cellCount = viewController.tableView.numberOfRows(inSection: 0)
        
        // Assert that the cell count is the same number of items.
        XCTAssertEqual(cellCount, articles.count, "Incorrect number of cells")
                
        for (index, article) in viewModel.articles.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = cell(for: viewController, at: indexPath) as? ArticleTableViewCell
            let lastIndex = articles.count - 1
         
            if indexPath.row == 0  {
                // Assert that the first article is the most recent created
                XCTAssertTrue(article.headline == "Headline 2", "Articles are not ordered by timestamp")
            } else if indexPath.row == lastIndex {
                // Assert that article without timestamp is last.
                XCTAssertTrue(article.headline == "Headline 3", "Articles are not ordered by timestamp")
            }
            
            verifyConfiguration(for: cell, with: article)
        }

    }
    
    func verifyConfiguration(for cell: ArticleTableViewCell?, with article: Article) {
        // Assert image view background colour is set to the category colour.
        XCTAssertEqual(cell?.articleImageView.backgroundColor, article.categories?.first?.colour)
        
        // Assert that the titleLabel text is the article headline.
        XCTAssertEqual(cell?.titleLabel.text, article.headline)
        
        // Assert that the abstractLabel text is article abstract.
        XCTAssertEqual(cell?.abstractLabel.text, article.theAbstract)
        
        let authorName = article.authors?.first?.name ?? "Unknown author"
        // Assert authorLabel text is the same as the article authors.
        XCTAssertEqual(cell?.authorLabel.text, authorName)
        
        // Assert that createdAtLabel text is the article's timeSinceNow
        XCTAssertEqual(cell?.createdAtLabel.text, article.createdDate?.timeSinceNow)
    }
    
    // MARK: -  Helper functions
    
    func cell(for vc: ArticlesViewController, at index: IndexPath) -> UITableViewCell {
        return vc.tableView(vc.tableView, cellForRowAt: index)
    }

    func createArticles(with categories: [Category]) -> [Article] {
        return categories.map { Article(category: $0) }
    }
    
    func createArticles() -> [Article] {
        // Article with all values, with timestamp 1 second ago.
        let articleOne = Article(category: Category(name: "Category"),
                               url: "www.google.com",
                               timeStamp: Int(Date().timeIntervalSince1970) - 1,
                               headline: "Headline 1",
                               authors: [Author(name: "Author")],
                               theAbstract: "Abstract 1")
        
        // Article missing authors, with current timestamp.
        let articleTwo = Article(category: Category(name: "Category"),
                               url: "www.google.com",
                               timeStamp: Int(Date().timeIntervalSince1970),
                               headline: "Headline 2",
                               authors: [],
                               theAbstract: "Abstract 2")
        
        // Article missing timestamp, should be last in the order.
        let articleThree = Article(category: Category(name: "Category"),
                               url: "www.google.com",
                               timeStamp: nil,
                               headline: "Headline 3",
                               authors: [Author(name: "Author")],
                               theAbstract: "Abstract 3")
        
        return [articleOne, articleTwo, articleThree]
    }
}
