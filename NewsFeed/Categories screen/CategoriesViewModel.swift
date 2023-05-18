//
//  CategoriesViewModel.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

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
    
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
        loadArticles()
    }
    
    /// Will fetch a list of articles from API, update categories and delegate.
    /// Displays an error alert if an error occurs.
    private func loadArticles() {
        Task {
            let result = await networkService.getArticleList()
            
            switch result {
            case .success(let articles):
                
                // Update changes on the main thread.
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    let allCategories = articles.compactMap { $0.categories?.first }
                    self.categories = Array(Set(allCategories))
                    self.articles = articles

                    // Update the delegate categories have been loaded
                    self.delegate?.loadCategories()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func articlesWithin(_ category: Category) -> [Article] {
        return articles.filter { $0.categories?.first == category}
    }
}
