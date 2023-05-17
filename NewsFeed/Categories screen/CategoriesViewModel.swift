//
//  CategoriesViewModel.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

class CategoriesViewModel {
    
    let networkService: NetworkService
    
    var categories = [Category]()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        loadArticles()
    }
    
    private func loadArticles() {
        Task {
            let result = await networkService.getArticleList()
            
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    let allCategories = articles.compactMap { $0.categories?.first }
                    print(allCategories.count)
                    self.categories = Array(Set(allCategories))
                    print(self.categories.count)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
