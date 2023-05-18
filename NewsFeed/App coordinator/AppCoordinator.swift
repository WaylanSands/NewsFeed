//
//  AppCoordinator.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = NetworkService()
        let viewModel = CategoriesViewModel(networkService: service)
        let categoriesViewController = CategoriesViewController(viewModel: viewModel)
        categoriesViewController.coordinatorDelegate = self
        navigationController.pushViewController(categoriesViewController, animated: false)
    }
}

extension AppCoordinator: CategoriesCoordinator {
    func showArticles(_ articles: [Article]) {
        let viewModel = ArticlesViewModel(articles: articles)
        let viewController = ArticlesViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: ArticleCoordinator {
    func presentWebView(for URL: URL) {
        let webViewViewController = WebViewController(url: URL)
        navigationController.pushViewController(webViewViewController, animated: true)
    }
}
