//
//  CategoriesViewModel.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func present(_ error: Error)
    func loadCategories()
}

class CategoriesViewModel {
    
    /// delegate will  be updated when categories have been fetched.
    weak var delegate: CategoryViewModelDelegate?
        
    /// Array of unique categories from fetched articles.
    lazy var categories = [Category]()
    
    /// Articles returned from api accessed via articlesWithin method.
    private lazy var articles = [Article]()
    
    /// Number of collection view sections.
    let numberOfSections: Int = 1
    
    let title = "News Categories"
    
    private let networkService: ArticleService

    init(networkService: ArticleService) {
        self.networkService = networkService
    }
    
    /// Will fetch a list of articles from API, update categories and delegate.
    /// Displays an error alert if an error occurs.
    func fetchArticles() async {
        let result = await networkService.getArticleList()
        
        switch result {
        case .success(let articles):
            // Get all the categories within the articles.
            let allCategories = articles.compactMap { $0.categories }.flatMap { $0 }
            
            // Remove duplicates.
            self.categories = Array(Set(allCategories))
            self.articles = articles
            
            // Update the delegate categories have been loaded
            self.delegate?.loadCategories()
        case .failure(let error):
            self.delegate?.present(error)
        }
    }
    
    /// Returns an Array of Article within the provided category
    func articlesWithin(_ category: Category) -> [Article] {
        return articles.filter { $0.categories?.contains(category) ?? false }
    }
}
